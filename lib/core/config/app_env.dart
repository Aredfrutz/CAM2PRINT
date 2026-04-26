class AppEnv {
  final String name;
  final String apiBaseUrl;

  AppEnv({required this.name, required this.apiBaseUrl});

  factory AppEnv.fromDartDefine() {
    // Default values - can be overridden via --dart-define
    return AppEnv(
      name: const String.fromEnvironment('app.name', defaultValue: 'production'),
      apiBaseUrl: const String.fromEnvironment('app.apiBaseUrl', defaultValue: 'https://api.example.com'),
    );
  }
}