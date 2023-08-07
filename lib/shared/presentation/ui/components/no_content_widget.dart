import 'package:flutter/material.dart';

class NoContentWidget extends StatelessWidget {
  final Widget child;

  const NoContentWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final Orientation orientation = MediaQuery.orientationOf(context);

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/no_content.png', width: orientation == Orientation.portrait ? size.width * 0.8 : size.height / 1.5),
          child,
        ],
      ),
    );
  }
}
