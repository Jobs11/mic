import 'package:flutter/material.dart';
import 'package:mic/model/basic.dart';

class Weektap extends StatefulWidget {
  const Weektap({super.key, required this.b});

  final Basic b;

  @override
  State<Weektap> createState() => _WeektapState();
}

class _WeektapState extends State<Weektap> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [Text('주간 텝')]);
  }
}
