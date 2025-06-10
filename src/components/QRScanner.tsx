import { useEffect } from 'react';
import { Html5Qrcode } from 'html5-qrcode';

interface Props {
    onScanSuccess: (decodedText: string) => void;
}

export const QRScanner: React.FC<Props> = ({ onScanSuccess }) => {
    useEffect(() => {
        const qrRegionId = "reader";
        const html5QrCode = new Html5Qrcode(qrRegionId);

        // Esperar un poquito para asegurar que el DOM esté renderizado
        setTimeout(() => {
            Html5Qrcode.getCameras().then(devices => {
                const backCamera = devices.find(d => d.label.toLowerCase().includes('back')) || devices[0];

                if (!backCamera) {
                    console.error("No back camera found");
                    return;
                }

                html5QrCode.start(
                    backCamera.id,
                    {
                        fps: 10,
                        qrbox: 250
                    },
                    onScanSuccess,
                    error => {
                        // omit log
                    }
                );
            });
        }, 300); // 👈 pequeño delay para asegurar que #reader esté presente

        return () => {
            html5QrCode.stop().then(() => {
                html5QrCode.clear();
            });
        };
    }, [onScanSuccess]);


    return <div id="reader" style={{ width: '100%' }} />;
};
