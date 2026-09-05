/// Connection settings for the Kisan Dost FastAPI backend.
///
/// [baseUrl] can be overridden at run/build time without editing this file:
///   flutter run --dart-define=KISAN_BACKEND_URL=http://192.168.1.14:8000
///
/// The default `10.0.2.2` is the Android emulator's alias for the host machine.
/// A physical phone cannot use it — pass the Mac's LAN IP via --dart-define,
/// with the phone and Mac on the same Wi-Fi network.
abstract class BackendConfig {
  static const String baseUrl = String.fromEnvironment(
    'KISAN_BACKEND_URL',
    defaultValue: 'http://10.0.2.2:8000',
  );

  static const String transcribePath = '/api/v1/stt/transcribe';

  static const Duration requestTimeout = Duration(seconds: 60);

  static Uri get transcribeUri => Uri.parse('$baseUrl$transcribePath');
}
