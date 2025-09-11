import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mic/api/model/basic.dart';
import 'package:mic/function/datas.dart';
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
          padding: EdgeInsets.all(3),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Typicalcolor.subborder, // 위쪽: 어두운 차콜
                Typicalcolor.border, // 아래쪽: 연한 금색
              ],
            ),
            border: Border.all(color: Typicalcolor.font),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Typicalcolor.bg, // 위쪽: 어두운 차콜
                  Typicalcolor.subbg, // 아래쪽: 연한 금색
                ],
              ),
              border: Border.all(color: Typicalcolor.font),
              borderRadius: BorderRadius.circular(9),
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
                        color: Typicalcolor.title,
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: twoTitle('경험치 게산기', 18),
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
                      twoText('현재 레벨:', 18),
                      Container(
                        width: 80.w,
                        height: 30.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Color(0xFFfbe9c2),
                          border: Border.all(
                            color: Typicalcolor.subfont,
                            width: 2.w,
                          ),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          widget.b.characterlevel.toString(),
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Typicalcolor.font,
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
                      twoText('목표 레벨:', 18),
                      Container(
                        width: 80.w,
                        height: 30.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Color(0xFFfbe9c2),
                          border: Border.all(
                            color: Typicalcolor.subfont,
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
                    children: [twoText('현재 경험치:', 18)],
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
        ),

        SizedBox(height: 4.h),

        Container(
          width: double.infinity,
          height: 220.h,
          padding: EdgeInsets.all(3),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Typicalcolor.subborder, // 위쪽: 어두운 차콜
                Typicalcolor.border, // 아래쪽: 연한 금색
              ],
            ),
            border: Border.all(color: Typicalcolor.font),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Typicalcolor.bg, // 위쪽: 어두운 차콜
                  Typicalcolor.subbg, // 아래쪽: 연한 금색
                ],
              ),
              border: Border.all(color: Typicalcolor.font),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: 30.h,
                  decoration: BoxDecoration(
                    color: Typicalcolor.title,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: twoTitle('이벤트 및 더보기', 18),
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
          gradient: LinearGradient(
            colors: [
              Typicalcolor.title, // 왼쪽 밝은 파랑
              Typicalcolor.subtitle, // 오른쪽
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: Color(0xFFfbe9c2), width: 3.w),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            SizedBox(width: 70.w, child: twoText(title, 14)),
            SizedBox(width: 4.w),

            Expanded(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Colors.white,
                  inactiveTrackColor: Colors.blueGrey,
                  trackHeight: 2,
                  thumbColor: Typicalcolor.font,
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

            twoText(
              (title == '에픽던전')
                  ? '${eventtitle[title].toString()}배'
                  : '${eventtitle[title].toString()}%',
              16,
            ),
          ],
        ),
      ),
    );
  }
}
