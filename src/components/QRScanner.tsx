import { useEffect, useRef } from 'react';
import { Html5Qrcode } from 'html5-qrcode';

interface Props {
  onScanSuccess: (decodedText: string) => void;
}

export const QRScanner: React.FC<Props> = ({ onScanSuccess }) => {
  const qrRegionId = "reader";
  const qrCodeRef = useRef<Html5Qrcode | null>(null);

  useEffect(() => {
    const element = document.getElementById(qrRegionId);
    if (!element) {
      console.error("❌ El contenedor del QR no está presente en el DOM");
      return;
    }

    const html5QrCode = new Html5Qrcode(qrRegionId);
    qrCodeRef.current = html5QrCode;

    Html5Qrcode.getCameras()
      .then(devices => {
        const backCamera = devices.find(d => d.label.toLowerCase().includes('back')) || devices[0];

        if (!backCamera) {
          console.error("❌ No se encontró cámara disponible");
          return;
        }

        html5QrCode
          .start(
            backCamera.id,
            { fps: 10, qrbox: 250 },
            onScanSuccess,
            () => {} // Errores de escaneo ignorados silenciosamente
          )
          .catch(err => {
            console.error("❌ Error iniciando la cámara:", err);
          });
      })
      .catch(err => {
        console.error("❌ Error obteniendo cámaras:", err);
      });

    return () => {
      html5QrCode
        .stop()
        .then(() => html5QrCode.clear())
        .catch(err => {
          console.error("❌ Error deteniendo el escáner:", err);
        });
    };
  }, [onScanSuccess]);

  return <div id={qrRegionId} style={{ width: '100%', height: 'auto' }} />;
};
