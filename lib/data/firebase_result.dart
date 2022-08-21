class FirebaseResult {
  final dynamic data;

  /// Contains the error message for the request
  final String errorMessage;

  FirebaseResult({this.data}) : errorMessage = '';

  FirebaseResult.error({required this.errorMessage}) : data = null;

  /// Returns true if the response has an error associated with it
  bool get hasError => errorMessage.isNotEmpty;
}