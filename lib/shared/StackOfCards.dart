import 'package:flutter/material.dart';

class StackOfCards extends StatelessWidget {
  final int num;
  final Widget child;
  final double offset;

  const StackOfCards({Key? key, int num = 1, required this.child, this.offset = 10.0})
      : num = num > 0 ? num : 1,
        super(key: key);

  @override
  Widget build(BuildContext context) => Stack(
    children: List<Widget>.generate(
        num - 1,
            (val) => Positioned(
            bottom: val * offset,
            left: val * offset,
            top: (num - val - 0.5) * offset,
            right: (num - val - 0.5) * offset,
            child: Card(child: Container()))).toList()
      ..add(
        Padding(
          padding: EdgeInsets.only(bottom: (num - 0.5) * offset, left: (num - 0.5) * offset),
          child: Card(child: child),
        ),
      ),
  );
}