import 'package:flutter/material.dart';

class CustomTabBar extends StatelessWidget {
  final List<String> tabImages;

  const CustomTabBar({
    super.key,
    required this.tabImages,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            color: Colors.orange.shade200,
            width: 1,
          ),
        ),
      ),
      child: RotatedBox(
        quarterTurns: -1,
        child: TabBar(
          indicator: BoxDecoration(
            color: Colors.orange.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          labelPadding: const EdgeInsets.all(8),
          isScrollable: false,
          indicatorColor: Colors.orange.shade800,
          labelColor: Colors.orange.shade800,
          unselectedLabelColor: Colors.grey,
          tabs: tabImages
              .map((image) => RotatedBox(
                    quarterTurns: 1,
                    child: Tab(icon: Image.asset(image, width: 50)),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
