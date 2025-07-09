import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:indisk_app/app_ui/screens/staff/staff_dashboard/staff_dasboard_view.dart';
import '../../../../../common_widget/common_appbar.dart';

class StripePaymentScreen extends StatefulWidget {
  final String checkoutUrl;

  const StripePaymentScreen({super.key, required this.checkoutUrl});

  @override
  _StripePaymentScreenState createState() => _StripePaymentScreenState();
}

class _StripePaymentScreenState extends State<StripePaymentScreen> {
  InAppWebViewController? webViewController;
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppbar(title: 'Viva Payment'),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri(widget.checkoutUrl)),
            initialOptions: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(
                javaScriptEnabled: true,
              ),
            ),
            onWebViewCreated: (controller) {
              webViewController = controller;
            },
            onLoadStart: (controller, url) {
              setState(() {
                _isLoading = true;
              });
            },
            onLoadStop: (controller, url) {
              setState(() {
                _isLoading = false;
              });

              if (url != null) {
                final urlString = url.toString();
                if (urlString.contains('/success') &&
                    urlString.contains('t=')) {
                  print('Payment Success URL Detected: $urlString');
                  final uri = Uri.parse(urlString);
                  final transactionId = uri.queryParameters['t'];
                  if (transactionId != null) {
                    print('Extracted Transaction ID: $transactionId');
                  }
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => StaffDashboardView()),
                    (Route<dynamic> route) => false,
                  );
                } else if (urlString.contains('/fail') ||
                    urlString.contains('payment-error') ||
                    urlString.contains('/error')) {
                  print('Payment Failed URL Detected: $urlString');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text("Payment failed. Returning to dashboard.")),
                  );
                  Future.delayed(Duration(seconds: 2), () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => StaffDashboardView()),
                      (Route<dynamic> route) => false,
                    );
                  });
                }
              }
            },
            // onLoadStop: (controller, url) {
            //   setState(() {
            //     _isLoading = false;
            //   });
            //   if (url != null) {
            //     final urlString = url.toString();
            //     // Detect success page by path or query params
            //     if (urlString.contains('/success') &&
            //         urlString.contains('t=')) {
            //       print('Payment Success URL Detected: $urlString');
            //       // Optionally extract session or transaction id
            //       final uri = Uri.parse(urlString);
            //       final transactionId = uri.queryParameters['t'];
            //       if (transactionId != null) {
            //         print('Extracted Transaction ID: $transactionId');
            //       }
            //       Navigator.pushAndRemoveUntil(
            //         context,
            //         MaterialPageRoute(
            //             builder: (context) => StaffDashboardView()),
            //         (Route<dynamic> route) => false,
            //       );
            //     } else if (urlString.contains('payment-error') ||
            //         urlString.contains('/error')) {
            //       print('Payment error detected in URL');
            //       Navigator.pop(context, false);
            //     }
            //   }
            // },

            // onLoadStop: (controller, url) {
            //   setState(() {
            //     _isLoading = false;
            //   });
            //
            //   if (url != null) {
            //     final urlString = url.toString();
            //     if (urlString.contains('transaction_id')) {
            //       final sessionId = _getSessionIdFromUrl(urlString);
            //       if (sessionId != null) {
            //         Navigator.pop(context, sessionId);
            //       } else {
            //         Navigator.pop(context, false);
            //       }
            //     } else if (urlString.contains('payment-error')) {
            //       Navigator.pop(context, false);
            //     }
            //   }
            // },
            onLoadError: (controller, url, code, message) {
              setState(() {
                _isLoading = false;
              });
              print("Webview load error: $message");
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Failed to load payment page")),
              );
            },
          ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
