import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mic/function/coupon_contents.dart';
import 'package:mic/model/basic.dart';

class Coupontap extends StatefulWidget {
  const Coupontap({super.key, required this.b});

  final Basic b;

  @override
  State<Coupontap> createState() => _CoupontapState();
}

class _CoupontapState extends State<Coupontap> {
  late List<TextEditingController> usecontrollers;
  late List<TextEditingController> timecontrollers;

  @override
  void initState() {
    super.initState();
    usecontrollers = List.generate(
      usecoupon.length,
      (i) => TextEditingController(
        text: usecoupon.values.elementAt(i).toString(),
      ), // 초기값 세팅도 가능
    );

    timecontrollers = List.generate(
      timecoupon.length,
      (i) => TextEditingController(
        text: timecoupon.values.elementAt(i).toString(),
      ), // 초기값 세팅도 가능
    );
  }

  @override
  void dispose() {
    // 메모리 누수 방지 → 꼭 dispose
    for (final c in usecontrollers) {
      c.dispose();
    }

    for (final c in timecontrollers) {
      c.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                '쿠폰 컨텐츠',
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
        useitems(),
        SizedBox(height: 10.h),
        timeitems(),
      ],
    );
  }

  Container useitems() {
    return Container(
      width: double.infinity,
      height: 200.h,
      decoration: BoxDecoration(
        color: Color(0xFFfdecbe),
        border: Border.all(color: Color(0xFF6a4423), width: 3.w),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: 30.h,
            decoration: BoxDecoration(
              color: Color(0xFFfdecbe),
              border: Border.all(color: Color(0xFF6a4423), width: 3.w),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              '소비 아이템',
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10.h),

          Expanded(
            child: ListView.builder(
              itemCount: usecoupon.length,
              itemBuilder: (context, index) {
                String useitem = usecoupon.keys.elementAt(index);
                return usewidget(index, useitem);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget usewidget(int index, String useitem) {
    return Padding(
      padding: EdgeInsets.only(left: 8.w),
      child: Row(
        children: [
          Image.asset(couponimg[index], width: 30.w, height: 30.h),

          SizedBox(width: 10.w),

          Expanded(
            child: Text(
              useitem,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
            ),
          ),
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
                controller: usecontrollers[index],
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
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container timeitems() {
    return Container(
      width: double.infinity,
      height: 120.h,
      decoration: BoxDecoration(
        color: Color(0xFFfdecbe),
        border: Border.all(color: Color(0xFF6a4423), width: 3.w),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: 30.h,
            decoration: BoxDecoration(
              color: Color(0xFFfdecbe),
              border: Border.all(color: Color(0xFF6a4423), width: 3.w),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              '기간 아이템',
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
            ),
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

  Widget timewidget(int index, String timeitem) {
    return Padding(
      padding: EdgeInsets.only(left: 8.w),
      child: Row(
        children: [
          Image.asset(couponimg[index + 5], width: 30.w, height: 30.h),

          SizedBox(width: 10.w),

          Expanded(
            child: Text(
              timeitem,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
            ),
          ),
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
                controller: timecontrollers[index],
                maxLength: 5,
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
                    timecoupon[timeitem] = double.parse(v);
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
