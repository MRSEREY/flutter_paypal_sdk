import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_paypal_sdk/src/models/access_token.dart';
import 'package:flutter_paypal_sdk/src/models/mode.dart';
import 'package:flutter_paypal_sdk/src/models/payment.dart';
import 'package:http_auth/http_auth.dart';

class FlutterPaypalSDK {
  final String clientId;
  final String clientSecret;
  final String mode;

  FlutterPaypalSDK({
    required this.clientId,
    required this.clientSecret,
    required this.mode,
  });

  Dio dio = Dio();

  _baseUrl() {
    String baseUrl = mode == Mode.sandbox
        ? "https://api.sandbox.paypal.com"
        : 'https://api.paypal.com';
    return baseUrl;
  }

  Future<AccessToken> getAccessToken() async {
    var client = BasicAuthClient(clientId, clientSecret);
    var response = await client.post(
      Uri.parse("${_baseUrl()}/v1/oauth2/token?grant_type=client_credentials"),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return AccessToken(
        token: body['access_token'],
        message: 'access granted',
      );
    }
    return AccessToken(token: null, message: 'access denied');
  }

  Future<Payment> createPayment(
    Map<String, dynamic> transactions,
    String accessToken,
  ) async {
    Response response = await dio.post(
      '${_baseUrl()}/v1/payments/payment',
      data: transactions,
      options: Options(headers: {
        "content-type": "application/json",
        'Authorization': 'Bearer ' + accessToken,
      }),
    );
    if (response.statusCode == 201) {
      final data = response.data;
      if (data["links"] != null && data["links"].length > 0) {
        List links = data["links"];

        String executeUrl = "";
        String approvalUrl = "";
        final item = links.firstWhere(
          (o) => o["rel"] == "approval_url",
          orElse: () => null,
        );
        if (item != null) {
          approvalUrl = item["href"];
        }
        final item1 = links.firstWhere(
          (o) => o["rel"] == "execute",
          orElse: () => null,
        );
        if (item1 != null) {
          executeUrl = item1["href"];
        }
        return Payment(
          status: true,
          executeUrl: executeUrl,
          approvalUrl: approvalUrl,
        );
      }
    }
    return Payment(status: false);
  }

  Future<Map<String, dynamic>?> executePayment(
      String executeUrl, String payerId, String accessToken) async {
    var response = await dio.post(
      executeUrl,
      data: {"payer_id": payerId},
      options: Options(headers: {
        "content-type": "application/json",
        'Authorization': 'Bearer ' + accessToken
      }),
    );
    if (response.statusCode == 200) {
      return response.data;
    }
    return null;
  }
}
