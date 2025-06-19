import {
  IonContent,
  IonHeader,
  IonPage,
  IonTitle,
  IonToolbar,
  IonButton,
  IonCard,
  IonCardContent,
  IonText,
  IonModal,
  IonIcon,
  IonItem,
  IonLabel,
  IonGrid,
  IonRow,
  IonCol
} from '@ionic/react';
import { useState, useEffect } from 'react';
import { QRScanner } from '../components/QRScanner';
import { Camera } from '@capacitor/camera';
import { Capacitor } from '@capacitor/core';
import { 
  checkmarkCircle, 
  closeCircle, 
  person, 
  calendar, 
  call, 
  location, 
  male, 
  female, 
  body,
  business,
  apps
} from 'ionicons/icons';

const Home: React.FC = () => {
  const [scanning, setScanning] = useState(false);
  const [result, setResult] = useState('');
  const [loading, setLoading] = useState(false);
  const [showModal, setShowModal] = useState(false);
  const [modalData, setModalData] = useState<any>(null);

  useEffect(() => {
    const requestPermission = async () => {
      if (Capacitor.getPlatform() !== 'web') {
        try {
          const { camera } = await Camera.checkPermissions();
          if (camera !== 'granted') {
            const status = await Camera.requestPermissions();
            console.log("Camera permission status:", status);
          }
        } catch (err) {
          console.error("Error requesting camera permission", err);
        }
      } else {
        console.log("📷 No se solicita permiso en web");
      }
    };

    requestPermission();
  }, []);

  const handleScanSuccess = async (decodedText: string) => {
    let cleanQR = decodedText.trim();

    // Asegurar que comience con "qrs/"
    if (!cleanQR.startsWith("qrs/")) {
      cleanQR = `qrs/${cleanQR}`;
    }

    // Asegurar que termine con ".png"
    if (!cleanQR.endsWith(".png")) {
      cleanQR += ".png";
    }

    setResult(cleanQR);
    setScanning(false);
    setLoading(true);

    try {
      const response = await fetch('https://hayplaza.com/api/verificar_ticket.php', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          codigo_qr: cleanQR
        })
      });

      if (!response.ok) {
        const errorText = await response.text();
        setModalData({
          success: false,
          title: 'Error del Servidor',
          error: `Error ${response.status}: ${errorText}`
        });
        setShowModal(true);
        return;
      }

      const data = await response.json();

      if (data.success) {
        setModalData({
          success: true,
          title: 'Verificación Exitosa',
          evento_nombre: data.evento_nombre,
          nombre_completo: data.nombre_completo,
          ticket_id: data.ticket_id,
          tipo_ticket: data.tipo_ticket,
          // Datos específicos de palco
          numero_palco: data.numero_palco,
          numero_asiento: data.numero_asiento,
          telefono: data.telefono,
          genero: data.genero,
          ciudad: data.ciudad,
          fecha_confirmacion: data.fecha_confirmacion
        });
      } else {
        setModalData({
          success: false,
          title: 'Error de Verificación',
          error: data.error || 'Error desconocido',
          evento_nombre: data.evento_nombre,
          nombre_completo: data.nombre_completo,
          fecha_confirmacion: data.fecha_confirmacion,
          tipo_ticket: data.tipo_ticket,
          // Datos específicos de palco para errores
          numero_palco: data.numero_palco,
          numero_asiento: data.numero_asiento,
          telefono: data.telefono,
          genero: data.genero,
          ciudad: data.ciudad
        });
      }
      setShowModal(true);
    } catch (err: any) {
      console.error("❌ Error completo:", err);
      setModalData({
        success: false,
        title: 'Error de Conexión',
        error: `Error de conexión: ${err?.message || 'Error desconocido'}`
      });
      setShowModal(true);
    } finally {
      setLoading(false);
    }
  };

  const getGenderIcon = (genero: string) => {
    if (genero?.toLowerCase() === 'masculino' || genero?.toLowerCase() === 'm') {
      return male;
    } else if (genero?.toLowerCase() === 'femenino' || genero?.toLowerCase() === 'f') {
      return female;
    }
    return body;
  };

  const renderTicketInfo = () => {
    const isPalco = modalData?.tipo_ticket === 'palco';
    const cardColor = modalData?.success ? "success" : "danger";

    return (
      <IonCard color={cardColor}>
        <IonCardContent>
          <h2 style={{ marginTop: 0, color: 'white' }}>
            {modalData?.success ? '¡Bienvenido!' : 'Error'}
          </h2>
          
          {/* Información básica */}
          <IonItem lines="none" color={cardColor}>
            <IonIcon icon={calendar} slot="start" />
            <IonLabel>
              <h3>Evento</h3>
              <p>{modalData.evento_nombre}</p>
            </IonLabel>
          </IonItem>

          <IonItem lines="none" color={cardColor}>
            <IonIcon icon={person} slot="start" />
            <IonLabel>
              <h3>Participante</h3>
              <p>{modalData.nombre_completo}</p>
            </IonLabel>
          </IonItem>

          {/* Información específica de palco */}
          {isPalco && (
            <>
              <IonGrid>
                <IonRow>
                  <IonCol size="6">
                    <IonItem lines="none" color={cardColor}>
                      <IonIcon icon={business} slot="start" />
                      <IonLabel>
                        <h3>Palco</h3>
                        <p>{modalData.numero_palco || 'N/A'}</p>
                      </IonLabel>
                    </IonItem>
                  </IonCol>
                  <IonCol size="6">
                    <IonItem lines="none" color={cardColor}>
                      <IonIcon icon={apps} slot="start" />
                      <IonLabel>
                        <h3>Asiento</h3>
                        <p>{modalData.numero_asiento || 'N/A'}</p>
                      </IonLabel>
                    </IonItem>
                  </IonCol>
                </IonRow>
              </IonGrid>

              {modalData.telefono && (
                <IonItem lines="none" color={cardColor}>
                  <IonIcon icon={call} slot="start" />
                  <IonLabel>
                    <h3>Teléfono</h3>
                    <p>{modalData.telefono}</p>
                  </IonLabel>
                </IonItem>
              )}

              <IonGrid>
                <IonRow>
                  {modalData.genero && (
                    <IonCol size="6">
                      <IonItem lines="none" color={cardColor}>
                        <IonIcon icon={getGenderIcon(modalData.genero)} slot="start" />
                        <IonLabel>
                          <h3>Género</h3>
                          <p>{modalData.genero}</p>
                        </IonLabel>
                      </IonItem>
                    </IonCol>
                  )}
                  
                  {modalData.ciudad && (
                    <IonCol size="6">
                      <IonItem lines="none" color={cardColor}>
                        <IonIcon icon={location} slot="start" />
                        <IonLabel>
                          <h3>Ciudad</h3>
                          <p>{modalData.ciudad}</p>
                        </IonLabel>
                      </IonItem>
                    </IonCol>
                  )}
                </IonRow>
              </IonGrid>

              {/* Badge para identificar tipo de ticket */}
              <div style={{ 
                textAlign: 'center', 
                marginTop: '15px',
                marginBottom: '10px'
              }}>
                <span style={{
                  backgroundColor: 'rgba(255, 255, 255, 0.2)',
                  color: 'white',
                  padding: '8px 16px',
                  borderRadius: '20px',
                  fontSize: '14px',
                  fontWeight: 'bold'
                }}>
                  🎭 TICKET PALCO VIP
                </span>
              </div>
            </>
          )}

          {/* Error message */}
          {!modalData?.success && modalData?.error && (
            <div style={{ 
              color: 'white',
              fontSize: '16px',
              marginBottom: '15px',
              marginTop: '15px',
              padding: '10px',
              backgroundColor: 'rgba(255, 255, 255, 0.1)',
              borderRadius: '8px'
            }}>
              {modalData.error}
            </div>
          )}

          {/* Fecha de confirmación */}
          {modalData?.fecha_confirmacion && (
            <div style={{ 
              color: 'white',
              fontSize: '14px',
              marginTop: '15px',
              fontStyle: 'italic',
              textAlign: 'center'
            }}>
              {modalData.success ? 'Confirmado' : 'Previamente confirmado'}: {' '}
              {new Date(modalData.fecha_confirmacion).toLocaleString('es-CO', {
                timeZone: 'America/Bogota',
                year: 'numeric',
                month: '2-digit',
                day: '2-digit',
                hour: '2-digit',
                minute: '2-digit'
              })}
            </div>
          )}

          {/* Mensaje de éxito */}
          {modalData?.success && (
            <div style={{ 
              textAlign: 'center', 
              marginTop: '20px',
              color: 'white',
              fontSize: '18px',
              fontWeight: 'bold'
            }}>
              ✅ Asistencia registrada correctamente
            </div>
          )}
        </IonCardContent>
      </IonCard>
    );
  };

  return (
    <IonPage>
      <IonHeader>
        <IonToolbar color="primary">
          <IonTitle>Verificador de Tickets</IonTitle>
        </IonToolbar>
      </IonHeader>

      <IonContent className="ion-padding" fullscreen>
        {!scanning ? (
          <>
            <IonCard>
              <IonCardContent className="ion-text-center">
                <h2>Escanear Ticket</h2>
                <IonText color="medium">
                  Presiona el botón para escanear un código QR
                </IonText>
                <IonButton
                  expand="block"
                  className="ion-margin-top"
                  onClick={() => setScanning(true)}
                  disabled={loading}
                  style={{
                    height: '80vh',
                    fontSize: '24px',
                    fontWeight: 'bold'
                  }}
                >
                  {loading ? 'Verificando...' : 'Escanear'}
                </IonButton>
              </IonCardContent>
            </IonCard>

            {result && (
              <IonCard color="light">
                <IonCardContent>
                  <strong>Último código escaneado:</strong>
                  <p>{result}</p>
                </IonCardContent>
              </IonCard>
            )}
          </>
        ) : (
          <QRScanner onScanSuccess={handleScanSuccess} />
        )}

        {/* Modal mejorado */}
        <IonModal isOpen={showModal} onDidDismiss={() => setShowModal(false)}>
          <IonHeader>
            <IonToolbar color={modalData?.success ? "success" : "danger"}>
              <IonTitle>{modalData?.title}</IonTitle>
              <IonButton 
                slot="end" 
                fill="clear" 
                onClick={() => setShowModal(false)}
              >
                <IonIcon icon={closeCircle} />
              </IonButton>
            </IonToolbar>
          </IonHeader>
          
          <IonContent className="ion-padding">
            <div style={{ textAlign: 'center', marginBottom: '20px' }}>
              <IonIcon 
                icon={modalData?.success ? checkmarkCircle : closeCircle} 
                color={modalData?.success ? "success" : "danger"}
                style={{ fontSize: '64px' }}
              />
            </div>

            {modalData && renderTicketInfo()}

            <IonButton 
              expand="block" 
              onClick={() => setShowModal(false)}
              style={{ marginTop: '20px' }}
            >
              Cerrar
            </IonButton>
          </IonContent>
        </IonModal>
      </IonContent>
    </IonPage>
  );
};

export default Home;
