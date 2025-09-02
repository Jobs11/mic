import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mic/bar/mic_appbarone.dart';
import 'package:mic/bar/mic_underbar.dart';
import 'package:mic/function/datas.dart';
import 'package:mic/screens/boss_screen.dart';
import 'package:mic/screens/exp_screen.dart';
import 'package:mic/screens/mainhome_screen.dart';
import 'package:mic/screens/star_screen.dart';

class CubeScreen extends StatefulWidget {
  const CubeScreen({super.key});

  @override
  State<CubeScreen> createState() => _CubeScreenState();
}

class _CubeScreenState extends State<CubeScreen> {
  int _index = 3;

  final List<Widget> _pages = const [
    MainhomeScreen(),
    BossScreen(),
    ExpScreen(),
    CubeScreen(),
    StarScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MicAppbarone(
        title: "잠재능력 비용",
        scolor: Color(0xFF336e3e),
        ecolor: Color(0xFF749e4d),
        barimg: 'assets/images/icons/dicebar.png',
      ),
      body: Stack(
        children: [
          // 배경 이미지 (맨 아래)
          Positioned.fill(
            child: Image.asset(
              backgroundsimg[Backgroundnum.bn],
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
                    padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
                    decoration: BoxDecoration(
                      color: Color(0x8CFFFFFF),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: MicUnderbar(
        currentIndex: _index,
        onTap: (i) {
          setState(() => _index = i);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => _pages[_index]),
          );
        }, // ✅ 눌렀을 때 화면 전환
      ),
    );
  }
}
