import {
  IonContent,
  IonHeader,
  IonPage,
  IonTitle,
  IonToolbar,
  IonButton,
  IonCard,
  IonCardContent,
  IonText
} from '@ionic/react';
import { useState, useEffect } from 'react';
import { QRScanner } from '../components/QRScanner';
import { Camera } from '@capacitor/camera';
import { Capacitor } from '@capacitor/core';


const Home: React.FC = () => {
  const [scanning, setScanning] = useState(false);
  const [result, setResult] = useState('');

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

    try {
      const response = await fetch('https://hayplaza.com/api/verificar_ticket.php', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ codigo_qr: cleanQR })
      });

      if (!response.ok) {
        const errorData = await response.json();
        alert("❌ Error del servidor: " + (errorData?.error || response.status));
        return;
      }

      const data = await response.json();

      if (data.success) {
        alert("✅ Asistencia registrada correctamente");
      } else {
        alert("❌ Error: " + data.error);
      }
    } catch (err: any) {
      console.error("❌ Error detallado:", err);
      alert(`❌ Error de conexión con el servidor:\n${err?.message || JSON.stringify(err)}`);
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
                  >
                    Escanear
                  </IonButton>
                </IonCardContent>
              </IonCard>

              {result && (
                <IonCard color="success">
                  <IonCardContent>
                    <strong>Resultado:</strong>
                    <p>{result}</p>
                  </IonCardContent>
                </IonCard>
              )}
            </>
          ) : (
            <QRScanner onScanSuccess={handleScanSuccess} />
          )}
        </IonContent>
      </IonPage>
    );
  };

  export default Home;
