class ConstKeys {
  static const devEnv = true;
  static const baseUrlDev = String.fromEnvironment("BASE_URL_DEV");
  static const baseUrlLive = String.fromEnvironment("BASE_URL");
  static const moyaser = "";
  static String paymentKeyLive = '';
  static String paymentKeyTest = '';

  static String get paymentKey => devEnv ? paymentKeyTest : paymentKeyLive;
  static String get baseUrl => devEnv ? baseUrlDev : baseUrlLive;

  static String get baseNoApi {
    return baseUrl.replaceAll("/api", "");
  }
}
