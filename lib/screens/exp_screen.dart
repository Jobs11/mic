import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mic/bar/mic_appbarone.dart';
import 'package:mic/bar/mic_underbar.dart';
import 'package:mic/expwidget/calcultap.dart';
import 'package:mic/expwidget/coupontap.dart';
import 'package:mic/expwidget/daytap.dart';
import 'package:mic/expwidget/weektap.dart';
import 'package:mic/function/currentuser.dart';
import 'package:mic/function/datas.dart';
import 'package:mic/model/basic.dart';
import 'package:mic/screens/boss_screen.dart';
import 'package:mic/screens/cube_screen.dart';
import 'package:mic/screens/mainhome_screen.dart';
import 'package:mic/screens/star_screen.dart';
import 'package:mic/service/basicservice.dart';

import 'package:mic/widget/pillsegmentedfour.dart';

class ExpScreen extends StatefulWidget {
  const ExpScreen({super.key});

  @override
  State<ExpScreen> createState() => _ExpScreenState();
}

class _ExpScreenState extends State<ExpScreen> {
  int _index = 2;
  int selected = 0;

  late Future<Basic> basic;

  final List<Widget> _pages = const [
    MainhomeScreen(),
    BossScreen(),
    ExpScreen(),
    CubeScreen(),
    StarScreen(),
  ];

  List<Widget> tapWidgets(Basic b) => [
    Calcultap(b: b),
    Daytap(b: b),
    Weektap(b: b),
    Coupontap(b: b),
  ];

  @override
  void initState() {
    super.initState();
    basic = Basicservice.getOcidByCharacterName(
      CurrentUser.instance.ocid!.ocid,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: MicAppbarone(
        title: "경험치 계산기",
        scolor: Color(0xFF2f88b1),
        ecolor: Color(0xFF71c6c6),
        barimg: 'assets/images/icons/expbar.png',
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
                        Pillsegmentedfour(
                          value: selected,
                          onChanged: (i) => setState(() => selected = i),
                          labels: ["계산기", "일일", "주간", "쿠폰"],
                        ),

                        SizedBox(height: 30.h),
                        FutureBuilder<Basic>(
                          future: basic,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (snapshot.hasError) {
                              return Center(
                                child: Text('오류 발생: ${snapshot.error}'),
                              );
                            }
                            if (!snapshot.hasData) {
                              return const Center(child: Text('데이터 없음'));
                            }

                            final b = snapshot.data!;
                            final taps = tapWidgets(b);

                            return taps[selected];
                          },
                        ),
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
