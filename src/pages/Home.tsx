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
  IonLabel
} from '@ionic/react';
import { useState, useEffect } from 'react';
import { QRScanner } from '../components/QRScanner';
import { Camera } from '@capacitor/camera';
import { Capacitor } from '@capacitor/core';
import { checkmarkCircle, closeCircle, person, calendar } from 'ionicons/icons';

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
          ticket_id: data.ticket_id
        });
      } else {
        setModalData({
          success: false,
          title: 'Error de Verificación',
          error: data.error || 'Error desconocido',
          evento_nombre: data.evento_nombre,
          nombre_completo: data.nombre_completo,
          fecha_confirmacion: data.fecha_confirmacion
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

            {modalData?.success ? (
              <IonCard color="success">
                <IonCardContent>
                  <h2 style={{ marginTop: 0, color: 'white' }}>¡Bienvenido!</h2>
                  
                  <IonItem lines="none" color="success">
                    <IonIcon icon={calendar} slot="start" />
                    <IonLabel>
                      <h3>Evento</h3>
                      <p>{modalData.evento_nombre}</p>
                    </IonLabel>
                  </IonItem>

                  <IonItem lines="none" color="success">
                    <IonIcon icon={person} slot="start" />
                    <IonLabel>
                      <h3>Participante</h3>
                      <p>{modalData.nombre_completo}</p>
                    </IonLabel>
                  </IonItem>

                  <div style={{ 
                    textAlign: 'center', 
                    marginTop: '20px',
                    color: 'white',
                    fontSize: '18px',
                    fontWeight: 'bold'
                  }}>
                    ✅ Asistencia registrada correctamente
                  </div>
                </IonCardContent>
              </IonCard>
            ) : (
              <IonCard color="danger">
                <IonCardContent>
                  <h2 style={{ marginTop: 0, color: 'white' }}>Error</h2>
                  
                  <div style={{ 
                    color: 'white',
                    fontSize: '16px',
                    marginBottom: '15px'
                  }}>
                    {modalData?.error}
                  </div>

                  {modalData?.evento_nombre && (
                    <IonItem lines="none" color="danger">
                      <IonIcon icon={calendar} slot="start" />
                      <IonLabel>
                        <h3>Evento</h3>
                        <p>{modalData.evento_nombre}</p>
                      </IonLabel>
                    </IonItem>
                  )}

                  {modalData?.nombre_completo && (
                    <IonItem lines="none" color="danger">
                      <IonIcon icon={person} slot="start" />
                      <IonLabel>
                        <h3>Usuario</h3>
                        <p>{modalData.nombre_completo}</p>
                      </IonLabel>
                    </IonItem>
                  )}

                  {modalData?.fecha_confirmacion && (
                    <div style={{ 
                      color: 'white',
                      fontSize: '14px',
                      marginTop: '10px',
                      fontStyle: 'italic'
                    }}>
                      Confirmado: {new Date(modalData.fecha_confirmacion).toLocaleString()}
                    </div>
                  )}
                </IonCardContent>
              </IonCard>
            )}

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
