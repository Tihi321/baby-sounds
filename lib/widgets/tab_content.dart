import 'package:flutter/material.dart';

class TabContent extends StatelessWidget {
  final String title;
  final Widget child;

  const TabContent({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.orange.shade800,
              ),
            ),
          ),
        ),
        Expanded(child: child),
      ],
    );
  }
}
