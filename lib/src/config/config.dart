class APIConfig {
  static String apiUrl = 'http://localhost:3000';

  static void setEnvironment(Environment env) {
    switch (env) {
      case Environment.LOCAL:
        apiUrl = 'http://localhost:3000';
        break;
      case Environment.ANDROID:
        apiUrl = 'http://localhost:3000';  // Use 10.0.2.2 for Android emulator to access localhost
        break;
      case Environment.IOS:
        apiUrl = 'http://localhost:3000';  // For iOS emulator/local testing
        break;
      case Environment.PRODUCTION:
        apiUrl = 'https://your-production-api.com';  // Actual production API
        break;
    }
  }
}

enum Environment { LOCAL, ANDROID, IOS, PRODUCTION }
