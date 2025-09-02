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
    final icons = [
      'assets/images/icons/mainhome.png',
      'assets/images/icons/boss.png',
      'assets/images/icons/exp.png',
      'assets/images/icons/dice.png',
      'assets/images/icons/star.png',
    ];
    final labels = ["메인화면", "보스결정석", "경험치", "잠재능력", "스타포스"];

    List<Widget> items = [];
    for (int i = 0; i < 5; i++) {
      items.add(
        Expanded(
          child: InkWell(
            onTap: () => onTap(i),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 8.h), // 위쪽 여백(조금 줄임)
                Image.asset(
                  icons[i],
                  width: 24.w,
                  height: 24.h,
                  color: currentIndex == i ? Color(0xFFE9742B) : null,
                ),
                SizedBox(height: 2.h),
                Text(
                  labels[i],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: currentIndex == i ? 12.sp : 11.sp,
                    fontWeight: currentIndex == i
                        ? FontWeight.w700
                        : FontWeight.w600,
                    color: currentIndex == i
                        ? Color(0xFFE9742B)
                        : Color(0xFF4C2B1A),
                    height: 1.2.h,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      // 마지막 아이템 뒤에는 막대 추가하지 않음
      if (i != 4) {
        items.add(
          Container(
            margin: EdgeInsets.only(top: 16.h), // 막대도 위로 맞춤
            width: 1.5.w,
            height: 28.h, // 높이도 70에 맞게 조정
            color: Color(0xFF000000),
          ),
        );
      }
    }

    return Container(
      decoration: BoxDecoration(color: const Color(0xFFF9F4ED)),
      height: 70.h,
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: items),
    );
  }
}
