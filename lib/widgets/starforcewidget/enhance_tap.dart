import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mic/function/datas.dart';

class EnhanceTap extends StatefulWidget {
  const EnhanceTap({super.key});

  @override
  State<EnhanceTap> createState() => _EnhanceTapState();
}

class _EnhanceTapState extends State<EnhanceTap> {
  int equipindex = 0;
  String equipvalues = forcetype.first;

  int levelindex = 0;
  String levelvalues = equiplevel.first;

  bool isChance = false;
  bool isPay = false;
  bool isDestroy = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 520.h,
          padding: EdgeInsets.all(3), // border 두께
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xFFf4ba50), // 위쪽: 어두운 차콜
                Color(0xFFb4802b), // 아래쪽: 연한 금색
              ],
            ),
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF081525), // 위쪽: 어두운 차콜
                  Color(0xFF13406d), // 아래쪽: 연한 금색
                ],
              ),
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: 30.h,
                  decoration: BoxDecoration(
                    color: Color(0xFF15304a),

                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    '스타포스 강화 시뮬레이터',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFf4e7c5),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 80.w,
                        height: 20.h,
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
                          child: Center(
                            // 1) 드롭다운 버튼 자체를 부모 안에서 중앙 배치
                            child: SizedBox(
                              width: 160.w, // 원하는 너비로 세팅 (없으면 꽉 참)
                              child: DropdownButton<String>(
                                value: levelvalues,
                                isExpanded: true, // 가로로 꽉 채우기
                                alignment:
                                    Alignment.center, // 2) 버튼 안의 선택 텍스트 중앙 정렬
                                hint: const Center(
                                  // 힌트도 중앙 정렬
                                  child: Text(
                                    '아이템 설정',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                items: equiplevel.map((d) {
                                  return DropdownMenuItem<String>(
                                    value: d,
                                    alignment:
                                        Alignment.center, // 3) 메뉴 아이템 중앙 정렬
                                    child: Center(
                                      child: Text(
                                        '$d 레벨',
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  );
                                }).toList(),

                                // 선택된 아이템이 버튼에 표시될 때도 확실히 중앙 정렬시키고 싶다면:
                                selectedItemBuilder: (context) =>
                                    equiplevel.map((d) {
                                      return Center(
                                        child: Text(
                                          '$d 레벨',
                                          textAlign: TextAlign.center,
                                        ),
                                      );
                                    }).toList(),

                                onChanged: (value) {
                                  setState(() {
                                    levelindex = equiplevel.indexOf(value!);
                                    levelvalues = value;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 5.w),
                      Container(
                        width: 80.w,
                        height: 20.h,
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
                          child: Center(
                            // 1) 드롭다운 버튼 자체를 부모 안에서 중앙 배치
                            child: SizedBox(
                              width: 160.w, // 원하는 너비로 세팅 (없으면 꽉 참)
                              child: DropdownButton<String>(
                                value: equipvalues,
                                isExpanded: true, // 가로로 꽉 채우기
                                alignment:
                                    Alignment.center, // 2) 버튼 안의 선택 텍스트 중앙 정렬
                                hint: const Center(
                                  // 힌트도 중앙 정렬
                                  child: Text(
                                    '아이템 설정',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                items: forcetype.map((d) {
                                  return DropdownMenuItem<String>(
                                    value: d,
                                    alignment:
                                        Alignment.center, // 3) 메뉴 아이템 중앙 정렬
                                    child: Center(
                                      child: Text(
                                        d,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  );
                                }).toList(),

                                // 선택된 아이템이 버튼에 표시될 때도 확실히 중앙 정렬시키고 싶다면:
                                selectedItemBuilder: (context) =>
                                    forcetype.map((d) {
                                      return Center(
                                        child: Text(
                                          d,
                                          textAlign: TextAlign.center,
                                        ),
                                      );
                                    }).toList(),

                                onChanged: (value) {
                                  setState(() {
                                    equipindex = forcetype.indexOf(value!);
                                    equipvalues = value;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 10.h),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            'assets/images/icons/starforce.png',
                            width: 150.w,
                            height: 150.h,
                          ),

                          Image.asset(
                            equipimg[equipindex],
                            width: 70.w,
                            height: 70.h,
                            fit: BoxFit.fill,
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      checkEvent(),

                      isimgText(
                        '현재 단계:',
                        'assets/images/icons/starstage.png',
                        '21',
                      ),
                      onlyText('성공 확률:', '15%'),
                      onlyText('파괴 확률:', '10.8%'),
                      isimgText(
                        '강화 비용:',
                        'assets/images/icons/coin.png',
                        '578,000,000',
                      ),
                      isimgText(
                        '총 비용:',
                        'assets/images/icons/coin.png',
                        '23,700,000,000',
                      ),
                      SizedBox(height: 20.h),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          btntype(
                            '강화',
                            Color(0xFF000000),
                            Color(0xFF153d59),
                            Color(0xFFf9d771),
                            Color(0xFF1d4e72),
                          ),
                          SizedBox(width: 15.w),
                          btntype(
                            '초기화',
                            Color(0xFF000000),
                            Color(0xFF16354f),
                            Color(0xFF62b3cb),
                            Color(0xFF1a4b6f),
                          ),
                        ],
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

  Widget checkEvent() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          pieceEvent(
            '파괴확률 감소',
            isChance,
            (v) => setState(() {
              // 콜백으로 부모 상태 업데이트
              isChance = v ?? false;
            }),
          ),

          pieceEvent(
            '강화비용 감소',
            isPay,
            (v) => setState(() {
              // 콜백으로 부모 상태 업데이트
              isPay = v ?? false;
            }),
          ),

          pieceEvent(
            '강화파괴 방지',
            isDestroy,
            (v) => setState(() {
              // 콜백으로 부모 상태 업데이트
              isDestroy = v ?? false;
            }),
          ),
        ],
      ),
    );
  }

  Widget pieceEvent(String title, bool value, ValueChanged<bool?> onChanged) {
    return Container(
      width: 80.w,
      alignment: Alignment.center,
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: Color(0xFFeddec1),
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
            ),
          ),

          Checkbox(
            value: value,
            onChanged: onChanged,
            shape: RoundedRectangleBorder(
              // 모양 변경
              borderRadius: BorderRadius.circular(18),
            ),

            checkColor: Colors.white, // 체크 표시 색
            // 선택/비활성 등 상태별 채움색
            fillColor: WidgetStateProperty.resolveWith<Color?>((states) {
              if (states.contains(WidgetState.disabled)) {
                return const Color(0xFF13334d);
              }
              if (states.contains(WidgetState.selected)) {
                return const Color(0xFF217098); // 선택 시
              }
              return const Color(0xFF13334d); // 평소
            }),
            side: const BorderSide(
              // 테두리 색
              color: Color(0xFF889192),
              width: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget isimgText(String title, String img, String data) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              color: Color(0xFFeddec1),
              fontWeight: FontWeight.bold,
            ),
          ),

          Row(
            children: [
              Image.asset(img, width: 25.w, height: 25.h),

              Text(
                data,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Color(0xFFeddec1),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget onlyText(String title, String data) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              color: Color(0xFFeddec1),
              fontWeight: FontWeight.bold,
            ),
          ),

          Text(
            data,
            style: TextStyle(
              fontSize: 16.sp,
              color: Color(0xFFeddec1),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget btntype(
    String title,
    Color border1,
    Color border2,
    Color back1,
    Color back2,
  ) {
    return Container(
      width: 120.w,
      padding: EdgeInsets.all(3), // border 두께
      decoration: BoxDecoration(
        color: back1,
        border: Border.all(color: border1, width: 2.w),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: back2,
          border: Border.all(color: border2, width: 2.w),
          borderRadius: BorderRadius.circular(9),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Color(0xFFfdebc6),
          ),
        ),
      ),
    );
  }
}
