import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:flutter/material.dart';

class HomeCardMonthlyBalance extends StatefulWidget {
  const HomeCardMonthlyBalance({super.key});

  @override
  State<HomeCardMonthlyBalance> createState() => _HomeCardMonthlyBalanceState();
}

class _HomeCardMonthlyBalanceState extends State<HomeCardMonthlyBalance> with ThemeContext {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: colorScheme.surfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Column(
        children: [

        ],
      ),
    );
  }
}
