import { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'com.qrverifier.app',
  appName: 'QR Verifier App',
  webDir: 'dist',
  server: {
    androidScheme: 'https',
    allowNavigation: [
      'hayplaza.com',
      'https://hayplaza.com',
      'https://hayplaza.com/*'
    ]
  },
  android: {
    allowMixedContent: true,
    captureInput: true,
    webContentsDebuggingEnabled: true
  }
};

export default config;
