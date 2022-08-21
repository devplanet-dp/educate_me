class ApiConfig {
  static const String baseURL = "http://206.189.130.180:3000";

  //usser endpoints
  static const String sendOtp = "${baseURL}/users/sendMobileOtp";
  static const String verifyOtp = "${baseURL}/users/verifyMobileOtp";
  static const String loginEndpoint = "${baseURL}/users/customerLogin";
  static const String dueEndpoint = "${baseURL}AndroidApi/dues";
}
