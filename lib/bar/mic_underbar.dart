import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MicUnderbar extends StatelessWidget implements PreferredSizeWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const MicUnderbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Size get preferredSize => Size.fromHeight(70.h);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9F4ED), // 크림색
        // border: Border.all(color: Color(0xFFB75A22), width: 2.w), // 오렌지 테두리
        // borderRadius: BorderRadius.only(
        //   topLeft: Radius.circular(20.r),
        //   topRight: Radius.circular(20.r),
        // ),
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        currentIndex: currentIndex, // ✅ 선택 인덱스
        onTap: onTap,
        // selectedItemColor: Color(0xFFE9742B),
        // unselectedItemColor: Color(0xFF4C2B1A),
        selectedIconTheme: IconThemeData(size: 40.sp),
        unselectedIconTheme: IconThemeData(size: 36.sp),
        selectedLabelStyle: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w700,
          height: 1.2.h,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
          height: 1.2.h,
        ),

        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/icons/mainhome.png',
              width: 24.w, // 아이콘 크기 지정
              height: 24.h,
            ),
            label: "메인화면\n  ",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/icons/boss.png',
              width: 24.w, // 아이콘 크기 지정
              height: 24.h,
            ),
            label: "보스결정석\n   계산기",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/icons/exp.png',
              width: 24.w, // 아이콘 크기 지정
              height: 24.h,
            ),
            label: "경험치\n계산기",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/icons/dice.png',
              width: 24.w, // 아이콘 크기 지정
              height: 24.h,
            ),
            label: "잠재능력 설정\n  비용 계산기",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/icons/star.png',
              width: 24.w, // 아이콘 크기 지정
              height: 24.h,
            ),
            label: "  스타포스\n비용 계산기",
          ),
        ],
      ),
    );
  }
}
