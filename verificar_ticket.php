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
$codigo_raw = isset($input['codigo_qr']) ? trim($input['codigo_qr']) : null;

if (!$codigo_raw) {
    http_response_code(400);
    echo json_encode(['error' => '❌ Código QR no proporcionado']);
    exit;
}

// LIMPIAR EL CÓDIGO QR para tickets de palco
// Remover prefijo "qrs\/" o "qrs/"
$codigo_limpio = $codigo_raw;
$codigo_limpio = preg_replace('/^qrs\\\?\//', '', $codigo_limpio);
// Remover extensión .png
$codigo_limpio = preg_replace('/\.png$/', '', $codigo_limpio);
// Limpiar espacios
$codigo_limpio = trim($codigo_limpio);

try {
    // PRIMERA BÚSQUEDA: Tickets normales (con código original)
    $stmt = $pdo->prepare("
        SELECT t.*, 
               d.tituloserv as evento_nombre,
               u.nombre as nombre_usuario,
               'normal' as tipo_ticket
        FROM tickets t 
        INNER JOIN detservicio d ON t.id_evento = d.idet 
        INNER JOIN admin_users u ON t.id_usuario = u.iduser
        WHERE t.codigo_qr = ?
    ");
    $stmt->execute([$codigo_raw]); // Usar código original para tickets normales
    $ticket = $stmt->fetch(PDO::FETCH_ASSOC);

    if ($ticket) {
        // Verificar si ya tiene asistencia registrada
        if ($ticket['asistencia'] == 1) {
            echo json_encode([
                'success' => false,
                'error' => '⚠️ Este ticket ya fue utilizado anteriormente',
                'ticket_id' => $ticket['id'],
                'evento_nombre' => $ticket['evento_nombre'],
                'nombre_completo' => $ticket['nombre_usuario'],
                'fecha_confirmacion' => $ticket['asistenciaConfirmada'],
                'tipo_ticket' => $ticket['tipo_ticket']
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
            'fecha_confirmacion' => $fechaHoraLocal,
            'tipo_ticket' => $ticket['tipo_ticket']
        ]);
        exit;
    }

    // SEGUNDA BÚSQUEDA: Tickets de palco (con código limpio, SIN JOIN)
    $stmt_palco = $pdo->prepare("
        SELECT *, 
               'HayPlaza Festival - Palco VIP' as evento_nombre,
               'palco' as tipo_ticket
        FROM tickets_palco 
        WHERE codigo_qr = ?
    ");
    $stmt_palco->execute([$codigo_limpio]); // Usar código limpio para tickets de palco
    $ticketPalco = $stmt_palco->fetch(PDO::FETCH_ASSOC);
    
    if ($ticketPalco) {
        // Verificar si ya tiene asistencia registrada
        if (isset($ticketPalco['asistencia']) && $ticketPalco['asistencia'] == 1) {
            echo json_encode([
                'success' => false,
                'error' => '⚠️ Este ticket de palco ya fue utilizado anteriormente',
                'ticket_id' => $ticketPalco['idticket'],
                'evento_nombre' => $ticketPalco['evento_nombre'],
                'nombre_completo' => $ticketPalco['nombre'],
                'numero_palco' => $ticketPalco['numero_palco'] ?? 'N/A',
                'numero_asiento' => $ticketPalco['numero_asiento'] ?? 'N/A',
                'telefono' => $ticketPalco['celular'] ?? 'N/A',
                'genero' => $ticketPalco['genero'] ?? 'N/A',
                'ciudad' => $ticketPalco['ciudad'] ?? 'N/A',
                'fecha_confirmacion' => $ticketPalco['asistenciaConfirmada'] ?? null,
                'tipo_ticket' => $ticketPalco['tipo_ticket']
            ]);
            exit;
        }

        // Obtener fecha y hora actual de Colombia
        $fechaHoraLocal = date('Y-m-d H:i:s');

        // Actualizar asistencia con hora local para ticket de palco
        $update_palco = $pdo->prepare("UPDATE tickets_palco SET asistencia = 1, asistenciaConfirmada = ? WHERE idticket = ?");
        $update_palco->execute([$fechaHoraLocal, $ticketPalco['idticket']]);

        echo json_encode([
            'success' => true,
            'mensaje' => '✅ Asistencia de palco registrada correctamente',
            'ticket_id' => $ticketPalco['idticket'],
            'evento_nombre' => $ticketPalco['evento_nombre'],
            'nombre_completo' => $ticketPalco['nombre'],
            'numero_palco' => $ticketPalco['numero_palco'] ?? 'N/A',
            'numero_asiento' => $ticketPalco['numero_asiento'] ?? 'N/A',
            'telefono' => $ticketPalco['celular'] ?? 'N/A',
            'genero' => $ticketPalco['genero'] ?? 'N/A',
            'ciudad' => $ticketPalco['ciudad'] ?? 'N/A',
            'fecha_confirmacion' => $fechaHoraLocal,
            'tipo_ticket' => $ticketPalco['tipo_ticket']
        ]);
        exit;
    }

    // Si no se encuentra en ninguna tabla
    http_response_code(404);
    echo json_encode([
        'error' => '❌ Ticket no encontrado',
        'debug' => [
            'codigo_original' => $codigo_raw,
            'codigo_limpio' => $codigo_limpio,
            'mensaje' => 'Se buscó en tickets normales y de palco'
        ]
    ]);

} catch (Exception $e) {
    http_response_code(500);
    echo json_encode([
        'error' => 'Error al procesar la solicitud',
        'detalle' => $e->getMessage(),
        'linea' => $e->getLine()
    ]);
}
?>
