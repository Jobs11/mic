import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mic/function/currentuser.dart';
import 'package:mic/function/datas.dart';
import 'package:mic/widgets/starforcewidget/starforce_bar_chart.dart';

class StarExpectedTap extends StatefulWidget {
  const StarExpectedTap({super.key});

  @override
  State<StarExpectedTap> createState() => _StarExpectedTapState();
}

class _StarExpectedTapState extends State<StarExpectedTap> {
  double _value = 0;
  final goalController = TextEditingController();
  bool isDestroy = false;
  bool eventOn = false;

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
                    '스타포스 기댓값',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFf4e7c5),
                    ),
                  ),
                ),
                SizedBox(height: 5.h),
                startStage(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          goalwidget(),
                          SizedBox(width: 4.w),
                          destroywidget(),
                        ],
                      ),
                      SizedBox(height: 5.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          avgtimes('평균 시도 \n횟수', '55.6', 14),
                          avgtimes('평균 시도 \n메소', formatPower(15800000000), 14),
                          destroytime('파괴확률', '41%', 14),
                          eventbtn(),
                        ],
                      ),
                      SizedBox(height: 5.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          starTable(),
                          StarforceBarChart(rows: rows),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      resultbtn(),
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

  Widget startStage() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Container(
        padding: EdgeInsets.all(3), // border 두께
        decoration: BoxDecoration(
          color: Color(0xFF020b17),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xFF083566), // 위쪽: 어두운 차콜
                Color(0xFF011a35), // 아래쪽: 연한 금색
              ],
            ),
            borderRadius: BorderRadius.circular(9.r),
            border: Border.all(color: Color(0xFF163e6c)),
          ),
          child: Row(
            children: [
              Text(
                "시작★",
                style: TextStyle(
                  color: Color(0xFFfdebc6),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 5.w),
              Container(
                width: 2.w,
                height: 30.h,
                decoration: BoxDecoration(color: Color(0xFF163e6c)),
              ),
              SizedBox(width: 5.w),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: Colors.white,
                    inactiveTrackColor: Colors.blueGrey,
                    trackHeight: 2,

                    // 🔵 슬라이더 동그라미 색상
                    thumbColor: Colors.amber,

                    // 🔵 동그라미 크기 조절
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 6,
                    ),
                    overlayShape: SliderComponentShape.noOverlay,
                  ),
                  child: Slider(
                    value: _value,
                    min: 0,
                    max: 25,
                    divisions: 25,
                    onChanged: (v) {
                      setState(() => _value = v);
                    },
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                _value.toInt().toString(),
                style: TextStyle(
                  color: Color(0xFFfdebc6),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget goalwidget() {
    return Container(
      width: 135.w,
      padding: EdgeInsets.all(3), // border 두께
      decoration: BoxDecoration(
        color: Color(0xFF020b17),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFF083566), // 위쪽: 어두운 차콜
              Color(0xFF002645), // 아래쪽: 연한 금색
            ],
          ),
          borderRadius: BorderRadius.circular(9.r),
          border: Border.all(color: Color(0xFF163e6c)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  "목표★",
                  style: TextStyle(
                    color: Color(0xFFfdebc6),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 5.w),
                Container(
                  width: 2.w,
                  height: 30.h,
                  decoration: BoxDecoration(color: Color(0xFF163e6c)),
                ),
              ],
            ),

            Container(
              width: 50.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.r),
                color: Color(0xFF001e36),
                border: Border.all(color: Color(0xFF001e36), width: 2.w),
              ),
              child: TextField(
                controller: goalController,
                maxLength: 2,
                keyboardType: TextInputType.number, // 숫자 키패드
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // 숫자만 허용
                ],
                textAlign: TextAlign.center, // 👈 중앙 정렬
                style: TextStyle(
                  fontSize: 14.sp, // 글자 크기 (원하는 크기로 조정)
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFfdebc6),
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none, // 테두리 제거 (컨테이너 테두리만 보이게)
                  isCollapsed: true, // 안쪽 패딩 최소화
                  contentPadding: EdgeInsets.zero, // 여백 제거 → 진짜 중앙정렬 느낌
                  counterText: '',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget destroywidget() {
    return Container(
      width: 135.w,
      padding: EdgeInsets.all(3), // border 두께
      decoration: BoxDecoration(
        color: Color(0xFF020b17),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFF083566), // 위쪽: 어두운 차콜
              Color(0xFF002645), // 아래쪽: 연한 금색
            ],
          ),
          borderRadius: BorderRadius.circular(9.r),
          border: Border.all(color: Color(0xFF163e6c)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  "파괴방지",
                  style: TextStyle(
                    color: Color(0xFFfdebc6),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 5.w),
                Container(
                  width: 2.w,
                  height: 30.h,
                  decoration: BoxDecoration(color: Color(0xFF163e6c)),
                ),
              ],
            ),

            Checkbox(
              materialTapTargetSize:
                  MaterialTapTargetSize.shrinkWrap, // 터치영역 최소화
              visualDensity: VisualDensity.compact, // 내부 여백 줄이기
              value: isDestroy,
              onChanged: (v) => setState(() {
                isDestroy = v ?? false;
              }),
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
      ),
    );
  }

  Widget avgtimes(String title, String data, double size) {
    return Container(
      width: 80.w,
      height: 80.h,
      padding: EdgeInsets.all(3), // border 두께
      decoration: BoxDecoration(
        color: Color(0xFF020b17),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFF083566), // 위쪽: 어두운 차콜
              Color(0xFF002645), // 아래쪽: 연한 금색
            ],
          ),
          borderRadius: BorderRadius.circular(9.r),
          border: Border.all(color: Color(0xFF163e6c)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: Color(0xFFfdebc6),
              ),
              textAlign: TextAlign.center,
            ),

            Text(
              data,
              style: TextStyle(
                fontSize: size.sp,
                fontWeight: FontWeight.bold,
                color: Color(0xFFfdebc6),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget destroytime(String title, String data, double size) {
    return Container(
      width: 60.w,
      height: 80.h,
      padding: EdgeInsets.all(3), // border 두께
      decoration: BoxDecoration(
        color: Color(0xFF020b17),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFF083566), // 위쪽: 어두운 차콜
              Color(0xFF002645), // 아래쪽: 연한 금색
            ],
          ),
          borderRadius: BorderRadius.circular(9.r),
          border: Border.all(color: Color(0xFF163e6c)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: Color(0xFFfdebc6),
              ),
              textAlign: TextAlign.center,
            ),

            Text(
              data,
              style: TextStyle(
                fontSize: size.sp,
                fontWeight: FontWeight.bold,
                color: Color(0xFFfdebc6),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget eventbtn() {
    return Container(
      width: 50.w,
      height: 80.h,
      padding: EdgeInsets.all(3), // border 두께
      decoration: BoxDecoration(
        color: Color(0xFF020b17),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFF083566), // 위쪽: 어두운 차콜
              Color(0xFF002645), // 아래쪽: 연한 금색
            ],
          ),
          borderRadius: BorderRadius.circular(9.r),
          border: Border.all(color: Color(0xFF163e6c)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '이벤트',
              style: TextStyle(
                fontSize: 9.sp,
                fontWeight: FontWeight.bold,
                color: Color(0xFFfdebc6),
              ),
              textAlign: TextAlign.center,
            ),
            // 토글 캡슐 + 노란 점
            GestureDetector(
              onTap: () => setState(() => eventOn = !eventOn),
              child: Container(
                width: 45,
                height: 18,
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                decoration: BoxDecoration(
                  color: Color(0xFF002646),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF00162b)),
                  boxShadow: const [
                    BoxShadow(
                      offset: Offset(0, 1),
                      blurRadius: 0.5,
                      color: Color(0xFF08202E),
                    ),
                  ],
                ),
                child: AnimatedAlign(
                  duration: const Duration(milliseconds: 200),
                  alignment: eventOn
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Color(0xFFe2b061),
                      shape: BoxShape.circle,
                      boxShadow: const [
                        BoxShadow(
                          offset: Offset(0, 1),
                          blurRadius: 0.5,
                          color: Colors.black26,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ON',
                  style: TextStyle(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFfdebc6),
                  ),
                  textAlign: TextAlign.center,
                ),

                Text(
                  'OFF',
                  style: TextStyle(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFfdebc6),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget starTable() {
    return Container(
      width: 160,
      padding: EdgeInsets.all(3), // border 두께
      decoration: BoxDecoration(
        color: Color(0xFF020b17),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFF083566), // 위쪽: 어두운 차콜
              Color(0xFF002645), // 아래쪽: 연한 금색
            ],
          ),
          borderRadius: BorderRadius.circular(9.r),
          border: Border.all(color: Color(0xFF163e6c)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Table(
            columnWidths: const {
              0: FixedColumnWidth(40), // 성
              1: FlexColumnWidth(1), // 성공률
              2: FlexColumnWidth(1.3), // 기대 메소
            },
            border: TableBorder(
              horizontalInside: BorderSide(color: Color(0xFF0A2837), width: 1),
              verticalInside: BorderSide(color: Color(0xFF0A2837), width: 1),
              // 바깥 테두리는 Container로 처리했으니 여기선 inside만
            ),
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              // 헤더
              TableRow(
                decoration: const BoxDecoration(color: Color(0xFF083566)),
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.h),
                    child: _cell('성', bold: true),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.h),
                    child: _cell('성공률', bold: true),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.h),
                    child: _cell('기대 메소', bold: true),
                  ),
                ],
              ),
              // 데이터
              ...rows.map(
                (r) => TableRow(
                  decoration: const BoxDecoration(color: Color(0xFF002645)),
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.h),
                      child: _cell(r[0]),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.h),
                      child: _cell(r[1]),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.h),
                      child: _cell(r[2].toString(), align: TextAlign.right),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Text _cell(
    String text, {
    bool bold = false,
    TextAlign align = TextAlign.center,
  }) {
    return Text(
      text,
      textAlign: align,
      style: TextStyle(
        fontSize: 10.sp,
        fontWeight: bold ? FontWeight.w800 : FontWeight.w700,
        color: Color(0xFFfdebc6),
      ),
    );
  }

  Widget resultbtn() {
    return Container(
      width: 135.w,
      padding: EdgeInsets.all(3), // border 두께
      decoration: BoxDecoration(
        color: Color(0xFF020b17),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFF083566), // 위쪽: 어두운 차콜
              Color(0xFF002645), // 아래쪽: 연한 금색
            ],
          ),
          borderRadius: BorderRadius.circular(9.r),
          border: Border.all(color: Color(0xFF163e6c)),
        ),
        child: Text(
          "결과 확인",
          style: TextStyle(
            color: Color(0xFFfdebc6),
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
