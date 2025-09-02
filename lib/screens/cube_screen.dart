import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mic/bar/mic_appbarone.dart';
import 'package:mic/bar/mic_underbar.dart';
import 'package:mic/function/datas.dart';
import 'package:mic/screens/boss_screen.dart';
import 'package:mic/screens/exp_screen.dart';
import 'package:mic/screens/mainhome_screen.dart';
import 'package:mic/screens/star_screen.dart';
import 'package:mic/widget/pillsegmentedtwo.dart';

class CubeScreen extends StatefulWidget {
  const CubeScreen({super.key});

  @override
  State<CubeScreen> createState() => _CubeScreenState();
}

class _CubeScreenState extends State<CubeScreen> {
  int _index = 3;
  bool isChecked = false;
  int equipindex = 0;
  String equipvalues = equiptype.first;

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
                    child: Column(
                      children: [
                        Pillsegmentedtwo(
                          value: isChecked ? SimTab.expected : SimTab.simulator,
                          onChanged: (v) {
                            setState(() {
                              if (v == SimTab.expected) {
                                isChecked = true;
                              } else {
                                isChecked = false;
                              }
                            });
                          },
                        ),
                        SizedBox(height: 5.h),
                        isChecked ? expectedTap() : simulatorTap(),
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

  Column simulatorTap() {
    return Column(
      children: [
        Container(
          width: 200.w,
          height: 200.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter, // 시작점 (위쪽)
              end: Alignment.bottomCenter, // 끝점 (아래쪽)
              colors: [Color(0xFF141415), Color(0xFF999998)],
            ),
            border: Border.all(color: Color(0xFF999998), width: 2.w),
            borderRadius: BorderRadius.circular(17.r),
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  width: 100.w,
                  height: 24.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade400),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: DropdownButtonHideUnderline(
                    child: Padding(
                      padding: EdgeInsets.only(left: 8.w), // ← 전체 아이템에 적용
                      child: DropdownButton<String>(
                        value: equipvalues,
                        hint: const Text('아이템 설정'),
                        isExpanded: true,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        items: equiptype
                            .map(
                              (d) => DropdownMenuItem(value: d, child: Text(d)),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            equipindex = equiptype.indexOf(value!);
                            equipvalues = value;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),
              Image.network(equipimg[equipindex], width: 70.w, height: 70.h),
              SizedBox(height: 5.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Container(
                  decoration: BoxDecoration(color: Color(0xFF000000)),
                  width: double.infinity,
                  height: 2.w,
                ),
              ),
              SizedBox(height: 5.h),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '레전드리',
                    style: TextStyle(
                      color: gradeColor['레전드리'],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '보스 공격시 데미지 40%',
                    style: TextStyle(
                      color: gradeColor['레전드리'],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '공격력 9%',
                    style: TextStyle(
                      color: gradeColor['유니크'],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '공격력 12%',
                    style: TextStyle(
                      color: gradeColor['레전드리'],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 14.h),
        Container(
          width: 92.w,
          height: 92.h,
          padding: EdgeInsets.all(3), // border 두께
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Color(0xFF232323), // 위쪽: 어두운 차콜
                Color(0xFFFFE082), // 아래쪽: 연한 금색
              ],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF232323), // 위쪽: 어두운 차콜
                  Color(0xFFFFE082), // 아래쪽: 연한 금색
                ],
              ),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Column(
              children: [
                Image.network(
                  'https://i.namu.wiki/i/Waig8xp1A2c1AIAriu70I43kz-FhcJhaPruwz-QkoeihwgpjysxM_-B1nOtqjZYdbPR6U7pPFVsKVMkuIx7-wA.webp',
                  width: 50.w,
                  height: 50.h,
                  fit: BoxFit.fill,
                ),
                SizedBox(height: 10.h),
                Text(
                  '재설정',
                  style: TextStyle(
                    color: Color(0xFF232323),
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Color(0x80FFFFFF),
                        blurRadius: 2,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Column expectedTap() {
    return Column(children: [Text('기댓값')]);
  }
}
