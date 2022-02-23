import 'dart:async';

import 'package:example/success.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal_sdk/flutter_paypal_sdk.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaypalWebview extends StatefulWidget {
  final String approveUrl;
  final String executeUrl;
  final String accessToken;
  final FlutterPaypalSDK sdk;

  const PaypalWebview({
    Key? key,
    required this.approveUrl,
    required this.executeUrl,
    required this.accessToken,
    required this.sdk,
  }) : super(key: key);

  @override
  State<PaypalWebview> createState() => _PaypalWebviewState();
}

class _PaypalWebviewState extends State<PaypalWebview> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  int progress = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pay With Paypal'),
      ),
      body: Builder(builder: (context) {
        return Stack(
          children: [
            buildProgressBar(context),
            WebView(
              initialUrl: widget.approveUrl,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
              },
              onProgress: (int _progress) {
                setState(() {
                  progress = _progress;
                });
              },
              navigationDelegate: (NavigationRequest request) {
                return NavigationDecision.navigate;
              },
              onPageStarted: (String url) async {
                // Check base on return_url from transaction params;
                if (url.contains('/success')) {
                  final uri = Uri.parse(url);
                  final payerId = uri.queryParameters['PayerID'];
                  await widget.sdk.executePayment(
                    widget.executeUrl,
                    payerId!,
                    widget.accessToken,
                  );
                  // Handle After success
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Success(),
                    ),
                  );
                }
              },
              gestureNavigationEnabled: true,
              backgroundColor: const Color(0x00000000),
            ),
          ],
        );
      }),
    );
  }

  SafeArea buildProgressBar(
    BuildContext context,
  ) {
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Align(
        alignment: Alignment.topLeft,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 350),
          opacity: 1 - progress / 100,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 350),
            width: progress * width / 100,
            color: Theme.of(context).colorScheme.secondary,
            height: 3.0,
          ),
        ),
      ),
    );
  }
}
