import 'package:flutter/material.dart';
import 'package:mobileOs/screens/Welcomescreen.dart';
import 'package:webview_flutter/webview_flutter.dart';
// import 'package:url_launcher/url_launcher.dart';

class IdentityPage extends StatefulWidget {
  const IdentityPage({super.key});

  @override
  State<IdentityPage> createState() => _IdentityPageState();
}

class _IdentityPageState extends State<IdentityPage> {
  late final WebViewController _controller;

  final String allowedUrl = 'https://secure.quantumamc.com/newpurchase/newpurchase';

  Future<void> logout(BuildContext context) async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const WelcomeScreen()),
    );
  }
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    try {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onNavigationRequest: (request) {
              try {
               return NavigationDecision.navigate;
              } catch (e) {
                debugPrint('Navigation error: $e');
                _showErrorSnackBar('Navigation failed.');
                return NavigationDecision.prevent;
              }
            },
            onPageStarted: (url) {
              debugPrint('Page started loading: $url');
            },
            onPageFinished: (url) {
              debugPrint('Page finished loading: $url');
            },
            onWebResourceError: (error) {
              debugPrint('Web resource error: ${error.description}');
              //_showErrorSnackBar('Failed to load page. Please check your connection.');
            },
          ),
        )
       ..loadRequest(Uri.parse(allowedUrl));
    } catch (e) {
      debugPrint('WebView initialization error: $e');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showErrorSnackBar('Failed to initialize WebView.');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WebViewWidget(controller: _controller),
      ),
    );
  }
}
