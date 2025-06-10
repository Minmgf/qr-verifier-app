import { Camera } from '@capacitor/camera';

export const requestCameraPermission = async () => {
  await Camera.requestPermissions();
};
