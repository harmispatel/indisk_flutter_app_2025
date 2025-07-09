import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:indisk_app/app_ui/common_widget/common_appbar.dart';
import 'package:indisk_app/app_ui/screens/staff/staff_home/select_product/staff_select_product_view_model.dart';
import 'package:provider/provider.dart';

class VivaPaymentScreen extends StatefulWidget {
  final String checkoutUrl;

  const VivaPaymentScreen({super.key, required this.checkoutUrl});

  @override
  _VivaPaymentScreenState createState() => _VivaPaymentScreenState();
}

class _VivaPaymentScreenState extends State<VivaPaymentScreen> {
  InAppWebViewController? _webViewController;
  late StaffSelectProductViewModel mViewModel;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      mViewModel =
          Provider.of<StaffSelectProductViewModel>(context, listen: false);
    });
  }

  String? _getTransactionIdFromUrl(String url) {
    try {
      final uri = Uri.parse(url);
      // Check for different possible parameter names
      return uri.queryParameters['transaction_id'] ??
          uri.queryParameters['orderId'] ??
          uri.queryParameters['payment_id'] ??
          uri.queryParameters['id'];
    } catch (e) {
      print('Error parsing URL: $e');
      return null;
    }
  }

  bool _isPaymentSuccess(String url) {
    final urlString = url.toLowerCase();
    return urlString.contains('success') ||
        urlString.contains('completed') ||
        urlString.contains('transaction_id') ||
        urlString.contains('orderid') ||
        urlString.contains('payment_id');
  }

  bool _isPaymentError(String url) {
    final urlString = url.toLowerCase();
    return urlString.contains('error') ||
        urlString.contains('failed') ||
        urlString.contains('cancel') ||
        urlString.contains('payment-error');
  }

  @override
  Widget build(BuildContext context) {
    mViewModel = Provider.of<StaffSelectProductViewModel>(context);

    return Scaffold(
      appBar: CommonAppbar(
        title: 'Viva Payment',
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
        ],
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri(widget.checkoutUrl)),
            initialOptions: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(
                javaScriptEnabled: true,
                useShouldOverrideUrlLoading: true,
                mediaPlaybackRequiresUserGesture: false,
              ),
            ),
            onWebViewCreated: (controller) {
              _webViewController = controller;
            },
            onLoadStart: (controller, url) {
              setState(() {
                _isLoading = true;
                _errorMessage = null;
              });
            },
            onLoadStop: (controller, url) {
              setState(() {
                _isLoading = false;
              });

              if (url != null) {
                final urlString = url.toString();
                print('Payment URL: $urlString');

                if (_isPaymentSuccess(urlString)) {
                  final transactionId = _getTransactionIdFromUrl(urlString);
                  if (transactionId != null) {
                    print('Payment successful! Transaction ID: $transactionId');
                    mViewModel.stripePaymentId = transactionId;
                    mViewModel.handlePaymentCompletion(transactionId);
                    Navigator.pop(context, {
                      'success': true,
                      'transactionId': transactionId,
                    });
                  } else {
                    print('Payment successful but no transaction ID found');
                    Navigator.pop(context, {
                      'success': true,
                      'transactionId': null,
                    });
                  }
                } else if (_isPaymentError(urlString)) {
                  print('Payment failed or cancelled');
                  mViewModel
                      .handlePaymentFailure('Payment was cancelled or failed');
                  Navigator.pop(context, {
                    'success': false,
                    'error': 'Payment was cancelled or failed',
                  });
                }
              }
            },
            onLoadError: (controller, url, code, message) {
              setState(() {
                _isLoading = false;
                _errorMessage = 'Error loading payment page: $message';
              });
              print('WebView error: $code - $message');
            },
            onLoadHttpError: (controller, url, statusCode, description) {
              setState(() {
                _isLoading = false;
                _errorMessage = 'HTTP Error $statusCode: $description';
              });
              print('HTTP Error: $statusCode - $description');
            },
          ),
          if (_errorMessage != null)
            Container(
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 64,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Payment Error',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        _errorMessage!,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _errorMessage = null;
                        });
                        _webViewController?.reload();
                      },
                      child: const Text('Retry'),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, {
                          'success': false,
                          'error': _errorMessage,
                        });
                      },
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
