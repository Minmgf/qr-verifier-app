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
import { Camera } from '@capacitor/camera'; // 👌 sí lo usas

const Home: React.FC = () => {
  const [scanning, setScanning] = useState(false);
  const [result, setResult] = useState('');

  useEffect(() => {
    const requestPermission = async () => {
      try {
        const status = await Camera.requestPermissions();
        console.log("Camera permission status:", status);
      } catch (err) {
        console.error("Error requesting camera permission", err);
      }
    };

    requestPermission();
  }, []);

  const handleScanSuccess = (decodedText: string) => {
    setResult(decodedText);
    setScanning(false);
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
                <IonText color="medium">Presiona el botón para escanear un código QR</IonText>
                <IonButton expand="block" className="ion-margin-top" onClick={() => setScanning(true)}>
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
