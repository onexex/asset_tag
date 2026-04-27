import 'package:flutter/material.dart';
import 'app_view.dart';

void main() {
  // Sinisiguro nito na initialized ang lahat ng native bindings
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AssetWebViewApp());
}

class AssetWebViewApp extends StatelessWidget {
  const AssetWebViewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Asset Web Portal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        // Bagay ang Deep Purple o Blue kung industrial/tech ang vibe
        colorSchemeSeed: Colors.blueAccent, 
      ),
      home: const AppView(),
    );
  }
}