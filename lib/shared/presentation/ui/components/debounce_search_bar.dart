import 'dart:async';

import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:flutter/material.dart';

class DebounceSearchBar extends StatefulWidget {
  final Future<void> Function(String text) onChanged;
  final Widget Function(BuildContext context) builder;

  const DebounceSearchBar({super.key, required this.onChanged, required this.builder});

  @override
  State<DebounceSearchBar> createState() => _DebounceSearchBarState();
}

class _DebounceSearchBarState extends State<DebounceSearchBar> with ThemeContext {
  final TextEditingController controller = TextEditingController();
  final debouncer = Debouncer();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: TextField(
            controller: controller,
            autofocus: true,
            onChanged: (text) {
              debouncer(() => widget.onChanged(text));
            },
            decoration: InputDecoration(
              hintText: '${strings.search}...',
              prefixIcon: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              enabledBorder: const UnderlineInputBorder(),
              border: const UnderlineInputBorder(),
              focusedBorder: const UnderlineInputBorder(),
              disabledBorder: const UnderlineInputBorder(),
              errorBorder: const UnderlineInputBorder(),
              focusedErrorBorder: const UnderlineInputBorder(),
              suffixIcon: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  controller.clear();
                  widget.onChanged('');
                },
              ),
            ),
          ),
        ),
        Expanded(
          child: widget.builder(context),
        ),
      ],
    );
  }

  @override
  void dispose() {
    controller.dispose();
    debouncer.dispose();
    super.dispose();
  }
}

class Debouncer {
  Debouncer({this.delay = const Duration(milliseconds: 500)});

  final Duration delay;
  Timer? _timer;

  void call(VoidCallback action) {
    _timer?.cancel();

    _timer = Timer(delay, action);
  }

  void dispose() {
    _timer?.cancel();
  }
}
