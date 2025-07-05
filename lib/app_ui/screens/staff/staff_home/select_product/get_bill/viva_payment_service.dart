import 'dart:convert';
import 'package:http/http.dart' as http;

class VivaPaymentService {
  final String clientId;
  final String clientSecret;
  final bool isLive;

  VivaPaymentService({
    required this.clientId,
    required this.clientSecret,
    this.isLive = false,
  });

  String get baseUrl => isLive
      ? "https://accounts.vivapayments.com"
      : "https://demo-accounts.vivapayments.com";

  String get apiUrl => isLive
      ? "https://api.vivapayments.com"
      : "https://demo-api.vivapayments.com";

  /// Step 1: Get Access Token
  Future<String?> getAccessToken() async {
    final response = await http.post(
      Uri.parse('$baseUrl/connect/token'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization':
            'Basic ' + base64Encode(utf8.encode('$clientId:$clientSecret')),
      },
      body: {
        'grant_type': 'client_credentials',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)['access_token'];
    } else {
      print('Failed to get access token: ${response.body}');
      return null;
    }
  }

  /// Step 2: Create Payment Order
  Future<String?> createPaymentOrder(
      String accessToken, int amountInCents, String customerEmail) async {
    final response = await http.post(
      Uri.parse('$apiUrl/checkout/v2/orders'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        "amount": amountInCents,
        "customerTrns": "Order Payment",
        "customer": {
          "email": customerEmail,
        },
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data["checkoutUrl"]; // Use this to launch payment UI
    } else {
      print('Failed to create payment order: ${response.body}');
      return null;
    }
  }
}
