import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mic/bar/mic_appbarone.dart';
import 'package:mic/bar/mic_underbar.dart';
import 'package:mic/function/datas.dart';
import 'package:mic/screens/boss_screen.dart';
import 'package:mic/screens/cube_screen.dart';
import 'package:mic/screens/exp_screen.dart';
import 'package:mic/screens/mainhome_screen.dart';
import 'package:mic/widgets/pillwidget/starforce_pill_two.dart';
import 'package:mic/widgets/starforcewidget/enhance_tap.dart';
import 'package:mic/widgets/starforcewidget/star_expected_tap.dart';

class StarScreen extends StatefulWidget {
  const StarScreen({super.key});

  @override
  State<StarScreen> createState() => _StarScreenState();
}

class _StarScreenState extends State<StarScreen> {
  bool isChecked = false;
  int _index = 4;

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
        title: "스타포스 비용",
        scolor: Color(0xFFe28224),
        ecolor: Color(0xFFf0aa3b),
        barimg: 'assets/images/icons/starbar.png',
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
                    child: Column(
                      children: [
                        StarforcePillTwo(
                          value: isChecked
                              ? SimTab.starexpected
                              : SimTab.enhance,
                          onChanged: (v) {
                            setState(() {
                              if (v == SimTab.starexpected) {
                                isChecked = true;
                              } else {
                                isChecked = false;
                              }
                            });
                          },
                        ),

                        SizedBox(height: 10.h),
                        (isChecked) ? StarExpectedTap() : EnhanceTap(),
                      ],
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
