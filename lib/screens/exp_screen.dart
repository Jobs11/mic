import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mic/bar/mic_appbarone.dart';
import 'package:mic/bar/mic_underbar.dart';
import 'package:mic/function/currentuser.dart';
import 'package:mic/function/datas.dart';
import 'package:mic/model/basic.dart';
import 'package:mic/screens/boss_screen.dart';
import 'package:mic/screens/cube_screen.dart';
import 'package:mic/screens/mainhome_screen.dart';
import 'package:mic/screens/star_screen.dart';
import 'package:mic/service/basicservice.dart';
import 'package:mic/widget/daypilltwo.dart';
import 'package:mic/widget/expratebar.dart';

import 'package:mic/widget/pillsegmentedfour.dart';

class ExpScreen extends StatefulWidget {
  const ExpScreen({super.key});

  @override
  State<ExpScreen> createState() => _ExpScreenState();
}

class _ExpScreenState extends State<ExpScreen> {
  int _index = 2;
  int selected = 0;
  bool isChecked = false;
  late Future<Basic> basic;
  final goalcontroller = TextEditingController();

  final List<Widget> _pages = const [
    MainhomeScreen(),
    BossScreen(),
    ExpScreen(),
    CubeScreen(),
    StarScreen(),
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
    List<Widget> tapWidgets(Basic b) => [
      calculTap(b),
      dayTap(b),
      weekTap(b),
      couponTap(b),
    ];

    return Scaffold(
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

  Column calculTap(Basic b) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 200.h,
          decoration: BoxDecoration(
            color: Color(0xFF1a8cbd),
            border: Border.all(color: Color(0xFF0e2e51), width: 3.w),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: 30.h,
                    decoration: BoxDecoration(
                      color: Color(0xFF0e6ca2),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Stack(
                      children: [
                        // 테두리
                        Text(
                          '경험치 계산기',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 3
                              ..color = Color(0xFF102441),
                          ),
                        ),
                        // 안쪽 채우기
                        Text(
                          '경험치 계산기',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFfdac28),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 5.h,
                    right: 55.w,
                    child: Row(
                      children: [
                        Transform.rotate(
                          angle: -0.2,
                          child: Image.asset(
                            'assets/images/icons/book.png',
                            width: 50.w,
                            height: 50.h,
                          ),
                        ),
                        SizedBox(width: 80.w),
                        Transform.rotate(
                          angle: 0.4,
                          child: Image.asset(
                            'assets/images/icons/exppotion.png',
                            width: 50.w,
                            height: 50.h,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    Stack(
                      children: [
                        // 테두리
                        Text(
                          '현재 레벨:',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 3
                              ..color = Color(0xFF102441),
                          ),
                        ),
                        // 안쪽 채우기
                        Text(
                          '현재 레벨:',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFfbe9c2),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 80.w,
                      height: 30.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Color(0xFFfbe9c2),
                        border: Border.all(
                          color: Color(0xFF0e2e51),
                          width: 2.w,
                        ),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        b.characterlevel.toString(),
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0e2e51),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Stack(
                      children: [
                        // 테두리
                        Text(
                          '목표 레벨:',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 3
                              ..color = Color(0xFF102441),
                          ),
                        ),
                        // 안쪽 채우기
                        Text(
                          '목표 레벨:',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFfbe9c2),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 80.w,
                      height: 30.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Color(0xFFfbe9c2),
                        border: Border.all(
                          color: Color(0xFF0e2e51),
                          width: 2.w,
                        ),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: TextFormField(
                        controller: goalcontroller,
                        maxLength: 3,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          counterText: '',
                          border:
                              InputBorder.none, // 테두리 제거 (BoxDecoration에서 그림)
                          hintText: '목표 레벨', // 플레이스홀더
                          hintStyle: TextStyle(
                            fontSize: 14.sp,
                            color: Color(0xFF7f622a),
                            fontWeight: FontWeight.bold,
                            fontFamily: 'MaplestoryOTFBOLD',
                          ),
                        ),

                        style: TextStyle(fontSize: 18.sp),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Stack(
                      children: [
                        // 테두리
                        Text(
                          '현재 경험치:',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 3
                              ..color = Color(0xFF102441),
                          ),
                        ),
                        // 안쪽 채우기
                        Text(
                          '현재 경험치:',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFfbe9c2),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Expratebar(
                  value: double.parse(b.characterexprate) / 100,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Column dayTap(Basic b) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 40.h,
          decoration: BoxDecoration(
            color: Color(0xFFf3d090),
            border: Border.all(color: Color(0xFF6a4423), width: 3.w),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 20.w,
                    height: 2.h,
                    decoration: BoxDecoration(color: Color(0xFF6a4423)),
                  ),
                  SizedBox(height: 15.h),
                  Container(
                    width: 10.w,
                    height: 2.h,
                    decoration: BoxDecoration(color: Color(0xFF6a4423)),
                  ),
                ],
              ),

              Text(
                '일일 컨텐츠 [아케인/그란디스]',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4b3f32),
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 8.h),
                  Container(
                    width: 20.w,
                    height: 2.h,
                    decoration: BoxDecoration(color: Color(0xFF6a4423)),
                  ),
                  SizedBox(height: 15.h),
                  Container(
                    width: 10.w,
                    height: 2.h,
                    decoration: BoxDecoration(color: Color(0xFF6a4423)),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 10.h),
        Container(
          width: double.infinity,
          height: 200.h,
          decoration: BoxDecoration(
            color: Color(0xFFfdecbe),
            border: Border.all(color: Color(0xFF6a4423), width: 3.w),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            children: [
              Daypilltwo(
                value: isChecked ? SimTab.arcane : SimTab.grandis,
                onChanged: (v) =>
                    setState(() => isChecked = (v == SimTab.grandis)),
                height: 38, // 상단 여백/비율에 맞춰 조절
              ),
            ],
          ),
        ),
      ],
    );
  }

  Column weekTap(Basic b) {
    return Column(children: [Text('주간 텝')]);
  }

  Column couponTap(Basic b) {
    return Column(children: [Text('쿠폰 텝')]);
  }
}
