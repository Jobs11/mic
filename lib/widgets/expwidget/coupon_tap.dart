import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mic/function/datas.dart';
import 'package:mic/function/expdata/coupon_contents.dart';
import 'package:mic/api/model/basic.dart';
import 'package:mic/function/expdata/exp_contents.dart';

class CouponTap extends StatefulWidget {
  const CouponTap({super.key, required this.b});

  final Basic b;

  @override
  State<CouponTap> createState() => _CoupontapState();
}

class _CoupontapState extends State<CouponTap> {
  late Map<String, TextEditingController> usecontrollers;
  late Map<String, TextEditingController> timecontrollers;

  late final Map<String, bool> useIf = {
    "EXP": (200 <= widget.b.characterlevel && widget.b.characterlevel <= 259),
    "상급 EXP": 260 <= widget.b.characterlevel,
    "궁극의 유니온 성장의 비약": true,
    "극한 성장의 비약": 250 <= widget.b.characterlevel,
    "초월 성장의 비약": 270 <= widget.b.characterlevel,
  };

  @override
  void initState() {
    super.initState();
    usecontrollers = {
      for (var entry in usecoupon.entries)
        entry.key: TextEditingController(text: entry.value.toString()),
    };

    timecontrollers = {
      for (var entry in timecoupon.entries)
        entry.key: TextEditingController(text: entry.value.toString()),
    };
  }

  @override
  void dispose() {
    for (final c in usecontrollers.values) {
      c.dispose();
    }

    for (final c in timecontrollers.values) {
      c.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        expTitle('쿠폰 컨텐츠'),
        SizedBox(height: 10.h),
        useitems(),
        SizedBox(height: 10.h),
        timeitems(),
      ],
    );
  }

  // 사용아이템 목록
  Container useitems() {
    return Container(
      width: double.infinity,
      height: 200.h,
      decoration: BoxDecoration(
        color: Typicalcolor.bg,
        border: Border.all(color: Typicalcolor.border, width: 3.w),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: 30.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Typicalcolor.title, Typicalcolor.border],
              ),
              borderRadius: BorderRadius.circular(9),
            ),
            child: twoTitle('소비 아이템', 15),
          ),
          SizedBox(height: 10.h),

          Expanded(
            child: ListView.builder(
              itemCount: usecoupon.length,
              itemBuilder: (context, index) {
                String useitem = usecoupon.keys.elementAt(index);
                return usewidget(
                  index,
                  useitem,
                  useitemLevel[useitem]!,
                  useIf[useitem]!,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // 사용아이템 설정 구간
  Widget usewidget(int index, String useitem, String level, bool isLv) {
    return Padding(
      padding: EdgeInsets.only(left: 8.w),
      child: Row(
        children: [
          Image.asset(couponimg[useitem]!, width: 30.w, height: 30.h),

          SizedBox(width: 10.w),

          Expanded(child: twoText("$useitem$level", 14)),
          SizedBox(width: 10.w),

          Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: Container(
              width: 60.w,
              height: 24.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFF6a4423)),
                color: Color(0xFFfdecbe),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: (isLv)
                  ? TextField(
                      controller: usecontrollers[useitem],
                      maxLength: 4,
                      keyboardType: TextInputType.number, // 숫자 키패드
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly, // 숫자만 허용
                      ],
                      textAlign: TextAlign.center, // 👈 중앙 정렬
                      style: TextStyle(
                        fontSize: 14.sp, // 글자 크기 (원하는 크기로 조정)
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none, // 테두리 제거 (컨테이너 테두리만 보이게)
                        isCollapsed: true, // 안쪽 패딩 최소화
                        contentPadding: EdgeInsets.zero, // 여백 제거 → 진짜 중앙정렬 느낌
                        counterText: '',
                      ),
                      onChanged: (v) {
                        if (v.isNotEmpty) {
                          usecoupon[useitem] = int.parse(v);
                        } else {
                          usecoupon[useitem] = 0;
                        }
                      },
                    )
                  : Text(
                      "레벨 제한",
                      style: TextStyle(
                        fontSize: 12.sp, // 글자 크기 (원하는 크기로 조정)
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // 기간아이템 목록
  Container timeitems() {
    return Container(
      width: double.infinity,
      height: 120.h,
      decoration: BoxDecoration(
        color: Typicalcolor.bg,
        border: Border.all(color: Typicalcolor.border, width: 3.w),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: 30.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Typicalcolor.title, Typicalcolor.border],
              ),
              borderRadius: BorderRadius.circular(9),
            ),
            child: twoTitle('기간 아이템', 15),
          ),
          SizedBox(height: 10.h),

          Expanded(
            child: ListView.builder(
              itemCount: timecoupon.length,
              itemBuilder: (context, index) {
                String timeitem = timecoupon.keys.elementAt(index);
                return timewidget(index, timeitem);
              },
            ),
          ),
        ],
      ),
    );
  }

  // 기간아이템 설정 구간
  Widget timewidget(int index, String timeitem) {
    return Padding(
      padding: EdgeInsets.only(left: 8.w),
      child: Row(
        children: [
          Image.asset(couponimg[timeitem]!, width: 30.w, height: 30.h),

          SizedBox(width: 10.w),

          Expanded(child: twoText(timeitem, 14)),
          SizedBox(width: 10.w),

          Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: Container(
              width: 60.w,
              height: 24.h,

              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFF6a4423)),
                color: Color(0xFFfdecbe),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: TextField(
                controller: timecontrollers[timeitem],
                maxLength: 5,
                keyboardType: TextInputType.number, // 숫자 키패드
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                textAlign: TextAlign.center, // 👈 중앙 정렬
                style: TextStyle(
                  fontSize: 14.sp, // 글자 크기 (원하는 크기로 조정)
                  fontWeight: FontWeight.bold,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none, // 테두리 제거 (컨테이너 테두리만 보이게)
                  isCollapsed: true, // 안쪽 패딩 최소화
                  contentPadding: EdgeInsets.zero, // 여백 제거 → 진짜 중앙정렬 느낌
                  counterText: '',
                ),
                onChanged: (v) {
                  if (v.isNotEmpty) {
                    timecoupon[timeitem] = double.parse(v);
                  } else {
                    timecoupon[timeitem] = 0.0;
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
