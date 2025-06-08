enum AppEnvironmentType { development, staging, production }

enum AppEnvironment {
  development._(
    type: AppEnvironmentType.development,
    baseUrl: 'http://localhost:3000',
  ),
  staging._(
    type: AppEnvironmentType.staging,
    baseUrl: 'https://stage.api.example.com',
  ),
  production._(
    type: AppEnvironmentType.production,
    baseUrl: 'https://api.example.com',
  );

  const AppEnvironment._({required this.type, required this.baseUrl});

  final AppEnvironmentType type;
  final String baseUrl;
}
