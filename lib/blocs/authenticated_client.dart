import 'package:http/http.dart' as http;

class AuthenticatedClient extends http.BaseClient {
  final http.Client _client = http.Client();
  final String authToken;

  AuthenticatedClient({required this.authToken});

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.putIfAbsent('Authorization', () => authToken);

    return _client.send(request);
  }

  @override
  void close() {
    _client.close();

    super.close();
  }
}
