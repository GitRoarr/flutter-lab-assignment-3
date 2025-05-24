class NetworkException implements Exception {
  final String message;

  NetworkException([this.message = 'Something went wrong with the network.']);

  @override
  String toString() => message;
}
