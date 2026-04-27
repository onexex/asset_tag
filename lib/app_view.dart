import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() => _isLoading = true);
          },
          onPageFinished: (url) {
            setState(() => _isLoading = false);
          },
        ),
      )
      ..loadRequest(Uri.parse('https://ad0d-126-209-8-34.ngrok-free.app/Capstone-System/login.php'));  
  }
 
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Tinanggal ang AppBar para Full Screen look
      body: SafeArea(
        // Ang SafeArea ang bahala para hindi matakpan ng notch ang web app mo
        child: Stack(
          children: [
            WebViewWidget(controller: _controller),
            
            // Loading indicator na minimal
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}