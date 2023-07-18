import 'package:finan_master_app/shared/presentation/mixins/theme_page.dart';
import 'package:flutter/material.dart';

class ConfigPage extends StatefulWidget {
  static const String route = 'config';

  const ConfigPage({Key? key}) : super(key: key);

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> with ThemePage {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
        title: Text(strings.settings),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(strings.settings),
          ],
        ),
      ),
    );
  }
}
