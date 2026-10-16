import 'package:flutter/material.dart';

/// Matches the `<main>` padding in `src/components/PhoneFrame.tsx`:
/// `px-5 pb-36 pt-4` plus a hidden scrollbar, so every screen's content
/// clears the floating bottom nav by the same margin.
class ScreenScroll extends StatelessWidget {
  const ScreenScroll({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: const _NoScrollbarBehavior(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 144),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: children),
      ),
    );
  }
}

class _NoScrollbarBehavior extends ScrollBehavior {
  const _NoScrollbarBehavior();

  @override
  Widget buildScrollbar(BuildContext context, Widget child, ScrollableDetails details) => child;
}
