enum AppFlavor { dev, staging, prod }

class AppEnv {
  const AppEnv({required this.flavor, required this.apiBaseUrl});

  final AppFlavor flavor;
  final String apiBaseUrl;

  String get name => flavor.name;

  static AppEnv fromDartDefine() {
    const flavorRaw = String.fromEnvironment('APP_FLAVOR', defaultValue: 'dev');
    const apiBaseUrl = String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'https://example.api.local',
    );

    return AppEnv(flavor: _mapFlavor(flavorRaw), apiBaseUrl: apiBaseUrl);
  }

  static AppFlavor _mapFlavor(String value) {
    switch (value.toLowerCase()) {
      case 'prod':
      case 'production':
        return AppFlavor.prod;
      case 'staging':
        return AppFlavor.staging;
      case 'dev':
      default:
        return AppFlavor.dev;
    }
  }
}
