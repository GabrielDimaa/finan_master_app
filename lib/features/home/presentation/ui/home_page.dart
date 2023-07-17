import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static const String route = 'home';

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
        title: const Text('Início'),
        centerTitle: true,
      ),
      body: const SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text('Home'),
            ),
          ],
        ),
      ),
    );
  }
}
