import 'package:finan_master_app/features/splash/presentation/ui/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ConfigPage extends StatefulWidget {
  static const String route = 'config';

  const ConfigPage({Key? key}) : super(key: key);

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
        title: const Text('Configurações'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text('Configurações'),
            ),
            FilledButton(
              onPressed: () => context.goNamed('splash'),
              child: Text('Ir para SplashPage'),
            ),
          ],
        ),
      ),
    );
  }
}
