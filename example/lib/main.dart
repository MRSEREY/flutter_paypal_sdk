import 'package:example/paypal_webview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal_sdk/flutter_paypal_sdk.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Paypal SDK',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Paypal SDK'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.blue,
              child: GestureDetector(
                onTap: () async {
                  await payNow();
                },
                child: const Text(
                  'Pay Now',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  payNow() async {
    FlutterPaypalSDK sdk = FlutterPaypalSDK(
      clientId: 'yourClientId',
      clientSecret: 'yourClientSecret',
      mode: Mode.sandbox, // this will use sandbox environment
    );
    AccessToken accessToken = await sdk.getAccessToken();
    if (accessToken.token != null) {
      Payment payment = await sdk.createPayment(
        transaction(),
        accessToken.token!,
      );
      if (payment.status) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaypalWebview(
              approveUrl: payment.approvalUrl!,
              executeUrl: payment.executeUrl!,
              accessToken: accessToken.token!,
              sdk: sdk,
            ),
          ),
        );
      }
    }
  }

  transaction() {
    Map<String, dynamic> transactions = {
      "intent": "sale",
      "payer": {
        "payment_method": "paypal",
      },
      "redirect_urls": {
        "return_url": "/success",
        "cancel_url": "/cancel",
      },
      'transactions': [
        {
          "amount": {
            "currency": "USD",
            "total": "10",
          },
        }
      ],
    };

    return transactions;
  }
}
