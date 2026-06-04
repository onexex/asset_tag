import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
// 1. I-import ang permission handler
import 'package:permission_handler/permission_handler.dart';

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _hasCameraPermission = false;

  @override
  void initState() {
    super.initState();
    _initWebViewSettings();
    _checkAndRequestPermissions(); // 2. Tawagin ang permission request sa simula
  }

  void _initWebViewSettings() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) => setState(() => _isLoading = true),
          onPageFinished: (url) => setState(() => _isLoading = false),
        ),
      );

    if (_controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (_controller.platform as AndroidWebViewController).setOnPlatformPermissionRequest(
        (PlatformWebViewPermissionRequest request) {
          request.grant();
        },
      );
    }
  }

  Future<void> _checkAndRequestPermissions() async {
    // Hihingi ng permiso para sa Camera at Mikropono sabay na
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.microphone,
    ].request();

    if (statuses[Permission.camera]!.isGranted) {
      setState(() {
        _hasCameraPermission = true;
      });
      
      _controller.loadRequest(Uri.parse('https://inspiro.infinityfreeapp.com/'));
    } else {
       
      debugPrint("Camera permission denied ng user.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
             
            if (_hasCameraPermission)
              WebViewWidget(controller: _controller)
            else
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  key: ValueKey('permission_error'),
                  child: Text(
                    'Kailangan ng app na ito ang Camera Permission para gumana ang feature na ito. Paki-allow po.',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              
            if (_isLoading && _hasCameraPermission)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingMenu(),
    );
  }

  Widget _buildFloatingMenu() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // FloatingActionButton.small(
        //   heroTag: 'btnBack',
        //   onPressed: () async {
        //     if (await _controller.canGoBack()) {
        //       await _controller.goBack();
        //     }
        //   },
        //   child: const Icon(Icons.arrow_back),
        // ),
        const SizedBox(width: 8),
        FloatingActionButton.small(
          heroTag: 'btnRefresh',
          onPressed: () => _controller.reload(),
          child: const Icon(Icons.refresh),
        ),
        const SizedBox(width: 8),
        // FloatingActionButton(
        //   heroTag: 'btnHome',
        //   onPressed: () {
        //     if (_hasCameraPermission) {
        //       _controller.loadRequest(Uri.parse('https://inspiro.infinityfreeapp.com/'));
        //     }
        //   },
        //   child: const Icon(Icons.home),
        // ),
      ],
    );
  }
}