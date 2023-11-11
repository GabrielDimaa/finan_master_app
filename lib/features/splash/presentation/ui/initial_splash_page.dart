import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:finan_master_app/shared/presentation/ui/app.dart';
import 'package:finan_master_app/shared/presentation/ui/components/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InitialSplashPage extends StatefulWidget {
  const InitialSplashPage({Key? key}) : super(key: key);

  @override
  State<InitialSplashPage> createState() => _InitialSplashPageState();
}

class _InitialSplashPageState extends State<InitialSplashPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor, brightness: Brightness.dark),
      ),
      home: const _SplashPage(),
    );
  }
}


class _SplashPage extends StatefulWidget {
  const _SplashPage({Key? key}) : super(key: key);

  @override
  State<_SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<_SplashPage> with ThemeContext {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/images/logo.svg', width: 80),
              const Spacing.y(4),
              Text(appName, style: textTheme.headlineLarge),
            ],
          ),
        ),
      ),
    );
  }
}
