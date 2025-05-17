import 'package:finan_master_app/di/dependency_injection.dart';
import 'package:finan_master_app/features/ad/domain/use_cases/i_ad.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdPage extends StatefulWidget {
  static const route = 'ad';

  const AdPage({super.key});

  @override
  State<AdPage> createState() => _AdPageState();
}

class _AdPageState extends State<AdPage> {
  final IAd ad = DI.get<IAd>();

  @override
  void initState() {
    super.initState();

    ad.showInterstitialAd(onClose: context.pop);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
