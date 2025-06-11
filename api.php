<?php
// CORS para permitir acceso desde apps y navegadores móviles
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');
header('Content-Type: application/json');

// Configurar zona horaria de Colombia
date_default_timezone_set('America/Bogota');

// Manejo de preflight (CORS OPTIONS)
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

// Requiere la clase de conexión centralizada
require_once __DIR__ . '/../core/Database.php';

try {
    $pdo = Database::connect();
    // También configurar la zona horaria en MySQL
    $pdo->exec("SET time_zone = '-05:00'");
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode([
        'error' => 'Error al conectar a la base de datos',
        'detalle' => $e->getMessage()
    ]);
    exit;
}

// Obtener y validar el cuerpo JSON
$input = json_decode(file_get_contents('php://input'), true);
$codigo = isset($input['codigo_qr']) ? trim($input['codigo_qr']) : null;

if (!$codigo) {
    http_response_code(400);
    echo json_encode(['error' => '❌ Código QR no proporcionado']);
    exit;
}

try {
    // Buscar ticket con información del evento y usuario
    $stmt = $pdo->prepare("
        SELECT t.*, 
               d.tituloserv as evento_nombre,
               u.nombre as nombre_usuario
        FROM tickets t 
        INNER JOIN detservicio d ON t.id_evento = d.idet 
        INNER JOIN admin_users u ON t.id_usuario = u.iduser
        WHERE t.codigo_qr = ?
    ");
    $stmt->execute([$codigo]);
    $ticket = $stmt->fetch(PDO::FETCH_ASSOC);

    if ($ticket) {
        // Verificar si ya tiene asistencia registrada
        if ($ticket['asistencia'] == 1) {
            echo json_encode([
                'success' => false,
                'error' => 'Este ticket ya fue utilizado anteriormente',
                'ticket_id' => $ticket['id'],
                'evento_nombre' => $ticket['evento_nombre'],
                'nombre_completo' => $ticket['nombre_usuario'],
                'fecha_confirmacion' => $ticket['asistenciaConfirmada']
            ]);
            exit;
        }

        // Obtener fecha y hora actual de Colombia
        $fechaHoraLocal = date('Y-m-d H:i:s');

        // Actualizar asistencia con hora local
        $update = $pdo->prepare("UPDATE tickets SET asistencia = 1, asistenciaConfirmada = ? WHERE id = ?");
        $update->execute([$fechaHoraLocal, $ticket['id']]);

        echo json_encode([
            'success' => true,
            'mensaje' => '✅ Asistencia registrada correctamente',
            'ticket_id' => $ticket['id'],
            'evento_nombre' => $ticket['evento_nombre'],
            'nombre_completo' => $ticket['nombre_usuario'],
            'fecha_confirmacion' => $fechaHoraLocal
        ]);
    } else {
        // También verificar en tickets_palco si no se encuentra en tickets
        $stmt2 = $pdo->prepare("SELECT * FROM tickets_palco WHERE codigo_qr = ?");
        $stmt2->execute([$codigo]);
        $ticketPalco = $stmt2->fetch(PDO::FETCH_ASSOC);
        
        if ($ticketPalco) {
            echo json_encode([
                'success' => true,
                'mensaje' => '✅ Ticket de palco verificado',
                'ticket_id' => $ticketPalco['idticket'],
                'evento_nombre' => 'Evento Palco VIP',
                'nombre_completo' => $ticketPalco['nombre']
            ]);
        } else {
            http_response_code(404);
            echo json_encode(['error' => '❌ Ticket no encontrado']);
        }
    }
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode([
        'error' => 'Error al procesar la solicitud',
        'detalle' => $e->getMessage()
    ]);
}
