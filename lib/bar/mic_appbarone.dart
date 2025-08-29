import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MicAppbarone extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color scolor;
  final Color ecolor;
  final String barimg;

  const MicAppbarone({
    super.key,
    required this.title,
    required this.scolor,
    required this.ecolor,
    required this.barimg,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [scolor, ecolor], // 오렌지 → 크림색
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
      centerTitle: true,
      automaticallyImplyLeading: false,
      elevation: 3,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(barimg, width: 60.w, height: 60.h),
          SizedBox(width: 10.w),
          Stack(
            alignment: Alignment.center,
            children: [
              // 1) 살짝 큰 윤곽(테두리) 레이어
              Image.asset(
                'assets/images/icons/titlebar.png',
                width: 190.w,
                height: 50.h,
                fit: BoxFit.fill,
              ),

              Text(
                title,
                style: TextStyle(
                  fontFamily: 'MaplestoryOTFBOLD', // 메이플 전용 폰트 가능
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF545454),
                ),
              ),
            ],
          ),
          SizedBox(width: 3.w),
          Image.asset(
            'assets/images/icons/leaf.png',
            width: 62.w,
            height: 62.h,
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
