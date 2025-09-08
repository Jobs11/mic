import 'package:flutter/material.dart';
import 'package:mic/model/basic.dart';

class Coupontap extends StatefulWidget {
  const Coupontap({super.key, required this.b});

  final Basic b;

  @override
  State<Coupontap> createState() => _CoupontapState();
}

class _CoupontapState extends State<Coupontap> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [Text('쿠폰 텝')]);
  }
}
