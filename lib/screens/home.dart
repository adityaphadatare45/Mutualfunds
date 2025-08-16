import 'package:flutter/material.dart';
import 'package:mobileOs/screens/Welcomescreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomePage extends StatefulWidget {
  final String token;

  const HomePage({super.key, required this.token});

  @override
  State<HomePage> createState() => _HomePageState();
}   

class _HomePageState extends State<HomePage> {
  late final WebViewController _controller;

  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.setBool('isSignedIn', false);

    Navigator.pushReplacement(
      // ignore: use_build_context_synchronously
      context,
      MaterialPageRoute(builder: (context) => const WelcomeScreen()),
    );
  }

 @override
void initState() {
  super.initState();
  _controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setNavigationDelegate(
      NavigationDelegate(
        onPageStarted: (url) {
          debugPrint('Loading started: $url');
        },
        onPageFinished: (url) {
          debugPrint('Page finished loading: $url');
        },
        
        onWebResourceError: (error) {
          debugPrint('Web resource error: ${error.description}');
        },
      ),
    )
    ..loadRequest(Uri.parse('https://secure.quantumamc.com/?id=${widget.token}'));

  debugPrint('WebView initialized with token: ${widget.token}');
}

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AnantSoft WebView'),
        backgroundColor: Colors.blue[50],
        leading: Image.asset('assets/icon/AS1.png'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => logout(context),
          )
        ],
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}

 
  
 