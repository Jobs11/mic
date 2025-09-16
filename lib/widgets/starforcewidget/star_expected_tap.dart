import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mic/function/currentuser.dart';
import 'package:mic/function/datas.dart';
import 'package:mic/function/starforce_expected_fn.dart';
import 'package:mic/widgets/starforcewidget/starforce_bar_chart.dart';

class StarExpectedTap extends StatefulWidget {
  const StarExpectedTap({super.key});

  @override
  State<StarExpectedTap> createState() => _StarExpectedTapState();
}

class _StarExpectedTapState extends State<StarExpectedTap> {
  double _value = 0; // 시작 스타포스 성
  final goalController = TextEditingController(); // 목표 스타포스 성
  bool isDestroy = false; // 파괴방지 여부
  bool eventOn = false; // 이벤트 여부 체크
  bool reduceDestroy30 = false;
  bool starCatch = false;

  double mvpDiscount = 0.0;
  double pcDiscount = 0.0;
  double starforceDiscount = 0.0;

  int totalTry = 0;
  int totalMeso = 0;
  String totalDestroy = "0.0";

  int avgTry = 0;
  int avgMeso = 0;
  String avgDestroy = "0.0";

  @override
  void initState() {
    super.initState();
    goalController.text = "1";
  }

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
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Typicalcolor.subborder, // 위쪽: 어두운 차콜
                Typicalcolor.border, // 아래쪽: 연한 금색
              ],
            ),
            border: Border.all(color: Typicalcolor.font),
            borderRadius: BorderRadius.circular(12),
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
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Typicalcolor.title, Typicalcolor.border],
                    ),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: twoTitle('스타포스 기댓값', 18),
                ),
                SizedBox(height: 5.h),
                SizedBox(
                  height: 430.h,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        startStage(),
                        SizedBox(height: 5.h),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  avgtimes('시도 횟수', "$totalTry회", 14),
                                  avgtimes(
                                    '시도 메소',
                                    '${formatPower(totalMeso)} 메소',
                                    9,
                                  ),
                                  destroytime('파괴확률', '$totalDestroy%', 12),
                                  eventbtn(),
                                ],
                              ),
                              SizedBox(height: 5.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  avgtimes('평균 횟수', "$avgTry회", 14),
                                  avgtimes(
                                    '평균 메소',
                                    '${formatPower(avgMeso)} 메소',
                                    9,
                                  ),
                                  destroytime('평균파괴', '$avgDestroy%', 12),
                                  eventbtn(),
                                ],
                              ),
                              SizedBox(height: 5.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  starTable(),
                                  StarforceBarChart(rows: rows),
                                ],
                              ),
                              SizedBox(height: 7.h),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                resultbtn(),
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
          color: Typicalcolor.subborder,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Color(0xFF000000)),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Typicalcolor.title, // 위쪽: 어두운 차콜
                Typicalcolor.subtitle, // 아래쪽: 연한 금색
              ],
            ),
            borderRadius: BorderRadius.circular(9.r),
            border: Border.all(color: Color(0xFF000000)),
          ),
          child: Row(
            children: [
              twoText('시작★', 14),
              SizedBox(width: 5.w),
              Container(
                width: 2.w,
                height: 30.h,
                decoration: BoxDecoration(color: Typicalcolor.subfont),
              ),
              SizedBox(width: 5.w),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: Colors.white,
                    inactiveTrackColor: Colors.blueGrey,
                    trackHeight: 2,

                    // 🔵 슬라이더 동그라미 색상
                    thumbColor: Typicalcolor.font,

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
              twoText(_value.toInt().toString(), 14),
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
        color: Typicalcolor.subborder,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Color(0xFF000000)),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Typicalcolor.title, // 위쪽: 어두운 차콜
              Typicalcolor.subtitle, // 아래쪽: 연한 금색
            ],
          ),
          borderRadius: BorderRadius.circular(9.r),
          border: Border.all(color: Color(0xFF000000)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                twoText("목표★", 14),

                SizedBox(width: 5.w),
                Container(
                  width: 2.w,
                  height: 30.h,
                  decoration: BoxDecoration(color: Typicalcolor.subfont),
                ),
              ],
            ),

            Container(
              width: 50.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.r),
                color: Typicalcolor.bg,
                border: Border.all(color: Typicalcolor.subborder, width: 2.w),
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
                  color: Typicalcolor.subfont,
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
        color: Typicalcolor.subborder,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Color(0xFF000000)),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Typicalcolor.title, // 위쪽: 어두운 차콜
              Typicalcolor.subtitle, // 아래쪽: 연한 금색
            ],
          ),
          borderRadius: BorderRadius.circular(9.r),
          border: Border.all(color: Color(0xFF000000)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                twoText('파괴방지', 14),
                SizedBox(width: 5.w),
                Container(
                  width: 2.w,
                  height: 30.h,
                  decoration: BoxDecoration(color: Typicalcolor.subfont),
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
                  return Typicalcolor.bg;
                }
                if (states.contains(WidgetState.selected)) {
                  return Typicalcolor.title; // 선택 시
                }
                return Typicalcolor.bg; // 평소
              }),
              side: BorderSide(
                // 테두리 색
                color: Typicalcolor.subborder,
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
        color: Typicalcolor.subborder,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Typicalcolor.font),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Typicalcolor.title, // 위쪽: 어두운 차콜
              Typicalcolor.subtitle, // 아래쪽: 연한 금색
            ],
          ),
          borderRadius: BorderRadius.circular(9.r),
          border: Border.all(color: Typicalcolor.font),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [twoText(title, 13), twoText(data, size)],
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
        color: Typicalcolor.subborder,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Typicalcolor.font),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Typicalcolor.title, // 위쪽: 어두운 차콜
              Typicalcolor.subtitle, // 아래쪽: 연한 금색
            ],
          ),
          borderRadius: BorderRadius.circular(9.r),
          border: Border.all(color: Typicalcolor.font),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [twoText(title, 14), twoText(data, size)],
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
        color: Typicalcolor.subborder,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Typicalcolor.font),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Typicalcolor.title, // 위쪽: 어두운 차콜
              Typicalcolor.subtitle, // 아래쪽: 연한 금색
            ],
          ),
          borderRadius: BorderRadius.circular(9.r),
          border: Border.all(color: Typicalcolor.font),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            twoText('이벤트', 9),
            // 토글 캡슐 + 노란 점
            GestureDetector(
              onTap: () {
                setState(() {
                  eventOn = !eventOn;
                  if (eventOn) {
                    starCatch = true;
                    reduceDestroy30 = true;
                    mvpDiscount = 0.1;
                    pcDiscount = 0.05;
                    starforceDiscount = 0.3;
                  } else {
                    starCatch = false;
                    reduceDestroy30 = false;
                    mvpDiscount = 0.0;
                    pcDiscount = 0.0;
                    starforceDiscount = 0.0;
                  }
                });
              },
              child: Container(
                width: 45,
                height: 18,
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                decoration: BoxDecoration(
                  color: Typicalcolor.bg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Typicalcolor.subborder),
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
                      color: Typicalcolor.font,
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
              children: [twoText('ON', 9), twoText('OFF', 9)],
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
        color: Typicalcolor.subborder,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Typicalcolor.font),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Typicalcolor.title, // 위쪽: 어두운 차콜
              Typicalcolor.subtitle, // 아래쪽: 연한 금색
            ],
          ),
          borderRadius: BorderRadius.circular(9.r),
          border: Border.all(color: Typicalcolor.font),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Table(
            columnWidths: const {
              0: FixedColumnWidth(40), // 성
              1: FlexColumnWidth(1), // 성공률
              2: FlexColumnWidth(1.3), // 기대 메소
            },
            border: TableBorder(
              horizontalInside: BorderSide(
                color: Typicalcolor.subborder,
                width: 1,
              ),
              verticalInside: BorderSide(
                color: Typicalcolor.subborder,
                width: 1,
              ),
              // 바깥 테두리는 Container로 처리했으니 여기선 inside만
            ),
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              // 헤더
              TableRow(
                decoration: BoxDecoration(color: Typicalcolor.title),
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.h),
                    child: Align(
                      alignment: Alignment.center,
                      child: twoText('성', 10),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.h),
                    child: Align(
                      alignment: Alignment.center,
                      child: twoText('성공률', 10),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.h),
                    child: Align(
                      alignment: Alignment.center,
                      child: twoText('기대 메소', 10),
                    ),
                  ),
                ],
              ),
              // 데이터
              ...rows.map(
                (r) => TableRow(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Typicalcolor.bg, // 위쪽: 어두운 차콜
                        Typicalcolor.subbg, // 아래쪽: 연한 금색
                      ],
                    ),
                  ),
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.h),
                      child: Align(
                        alignment: Alignment.center,
                        child: twoText(r[0], 10),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.h),
                      child: Align(
                        alignment: Alignment.center,
                        child: twoText(r[1], 10),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 5.h,
                        horizontal: 2.w,
                      ),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: twoText(r[2].toString(), 10),
                      ),
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

  Widget resultbtn() {
    return GestureDetector(
      onTap: () async {
        final prob = StarforceProbTable();
        final meso = StarforceMesoTable();
        await prob.load('assets/datas/starforce_probabilities.json');
        await meso.load('assets/datas/starforce_meso.json');

        final sim = StarforceSimulator(prob, meso);

        final cfg = EventConfig(
          eventOn: eventOn,
          starCatch: starCatch,
          reduceDestroy30: reduceDestroy30,
          safeguard: isDestroy,
          mvpDiscount: mvpDiscount,
          pcDiscount: pcDiscount,
          starforceDiscount: starforceDiscount,
        );

        final target = int.parse(goalController.text.trim());

        final once = await sim.simulateOnce(
          equipLevel: 250,
          start: _value.toInt(),
          target: target,
          cfg: cfg,
        );

        final stats = await sim.simulateMany(
          equipLevel: 250,
          start: _value.toInt(),
          target: target,
          cfg: cfg,
          runs: 1000,
        );
        setState(() {
          totalTry = once.tries;
          totalMeso = once.totalMeso;
          totalDestroy = (once.destroyCount / once.tries).toStringAsFixed(2);

          totalTry = stats['tries']['avg'];
          totalMeso = stats['meso']['avg'];
          totalDestroy = stats['destroy']['avg'];
        });
      },
      child: Container(
        width: 135.w,
        padding: EdgeInsets.all(3), // border 두께
        decoration: BoxDecoration(
          color: Typicalcolor.subborder,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Typicalcolor.font),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Typicalcolor.title, // 위쪽: 어두운 차콜
                Typicalcolor.subtitle, // 아래쪽: 연한 금색
              ],
            ),
            borderRadius: BorderRadius.circular(9.r),
            border: Border.all(color: Typicalcolor.font),
          ),
          child: twoText('결과 확인', 20),
        ),
      ),
    );
  }
}
