import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mic/api/model/basic.dart';
import 'package:mic/function/exp_contents.dart';
import 'package:mic/widgets/pillwidget/exprate_bar.dart';

class CalculTap extends StatefulWidget {
  const CalculTap({super.key, required this.b});

  final Basic b;

  @override
  State<CalculTap> createState() => _CalcultapState();
}

class _CalcultapState extends State<CalculTap> {
  final goalcontroller = TextEditingController();

  double arcaneindex = eventrate.indexOf(eventtitle["아케인리버"]!).toDouble();
  double grandisindex = eventrate.indexOf(eventtitle["그란디스"]!).toDouble();
  double monsterindex = eventrate.indexOf(eventtitle["몬스터파크"]!).toDouble();
  double epicindex = epicrate.indexOf(eventtitle["에픽던전"]!).toDouble();

  @override
  Widget build(BuildContext context) {
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
                        widget.b.characterlevel.toString(),
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
                child: ExprateBar(
                  value: double.parse(widget.b.characterexprate) / 100,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 4.h),

        Container(
          width: double.infinity,
          height: 220.h,
          decoration: BoxDecoration(
            color: Color(0xFF1a8cbd),
            border: Border.all(color: Color(0xFF0e2e51), width: 3.w),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
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
                      '이벤트 및 더보기',
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
                      '이벤트 및 더보기',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFfdac28),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 4.h),
              eventtype('아케인리버', arcaneindex, (v) {
                setState(() {
                  arcaneindex = v;
                  eventtitle["아케인리버"] = eventrate[v.toInt()];
                });
              }, eventrate),

              SizedBox(height: 4.h),
              eventtype('그란디스', grandisindex, (v) {
                setState(() {
                  grandisindex = v;
                  eventtitle["그란디스"] = eventrate[v.toInt()];
                });
              }, eventrate),

              SizedBox(height: 4.h),
              eventtype('몬스터파크', monsterindex, (v) {
                setState(() {
                  monsterindex = v;
                  eventtitle["몬스터파크"] = eventrate[v.toInt()];
                });
              }, eventrate),
              SizedBox(height: 4.h),
              eventtype('에픽던전', epicindex, (v) {
                setState(() {
                  epicindex = v;
                  eventtitle["에픽던전"] = epicrate[v.toInt()];
                });
              }, epicrate),
            ],
          ),
        ),
      ],
    );
  }

  Widget eventtype(
    String title,
    double index,
    ValueChanged<double>? onChanged,
    List<int> rate,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
        width: double.infinity,
        height: 40.h,
        decoration: BoxDecoration(
          color: Color(0xFF3e9cd8),
          border: Border.all(color: Color(0xFFfbe9c2), width: 3.w),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 70.w,
              child: Stack(
                children: [
                  // 테두리
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 3
                        ..color = Color(0xFF102441),
                    ),
                  ),
                  // 안쪽 채우기
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFfbe9c2),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 4.w),

            Expanded(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Colors.white,
                  inactiveTrackColor: Colors.blueGrey,
                  trackHeight: 2,
                  thumbColor: Color(0xFFfbe9c2),
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 6,
                  ),
                  overlayShape: SliderComponentShape.noOverlay,
                ),
                child: Slider(
                  value: index,
                  min: 0,
                  max: (rate.length - 1).toDouble(),
                  divisions: rate.length - 1,
                  label: "${rate[index.toInt()]}", // 선택된 값 보여주기
                  onChanged: onChanged,
                ),
              ),
            ),
            SizedBox(width: 15.w),

            Stack(
              children: [
                // 테두리
                Text(
                  (title == '에픽던전')
                      ? '${eventtitle[title].toString()}배'
                      : '${eventtitle[title].toString()}%',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 3
                      ..color = Color(0xFF102441),
                  ),
                ),
                // 안쪽 채우기
                Text(
                  (title == '에픽던전')
                      ? '${eventtitle[title].toString()}배'
                      : '${eventtitle[title].toString()}%',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFfbe9c2),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
