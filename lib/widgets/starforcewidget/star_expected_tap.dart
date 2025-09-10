import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StarExpectedTap extends StatefulWidget {
  const StarExpectedTap({super.key});

  @override
  State<StarExpectedTap> createState() => _StarExpectedTapState();
}

class _StarExpectedTapState extends State<StarExpectedTap> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [expectedSet()]);
  }

  Container expectedSet() {
    return Container(
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
                '스타포스 기댓값',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFf4e7c5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
