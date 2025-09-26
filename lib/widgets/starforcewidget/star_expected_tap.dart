import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mic/function/currentuser.dart';
import 'package:mic/function/datas.dart';
import 'package:mic/function/starforce_expected_fn.dart';
// import 'package:mic/widgets/starforcewidget/starforce_bar_chart.dart';

class StarExpectedTap extends StatefulWidget {
  const StarExpectedTap({super.key});

  @override
  State<StarExpectedTap> createState() => _StarExpectedTapState();
}

class _StarExpectedTapState extends State<StarExpectedTap> {
  double _value = 0; // 시작 스타포스 성
  final goalController = TextEditingController(); // 목표 스타포스 성
  final tryController = TextEditingController(); // 시뮬 횟수
  bool isDestroy = false; // 파괴방지 여부
  bool eventOn = false; // 이벤트 여부 체크
  bool reduceDestroy30 = false;
  bool starCatch = false;
  List<PerStarStat> rows = [];

  int equips = equiplevel.first;

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
    tryController.text = "1";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 460.h,
          padding: EdgeInsets.all(3), // border 두께
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Typicalcolor.border, Typicalcolor.subborder],
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
                colors: [Typicalcolor.bg, Typicalcolor.subbg],
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
                  height: 370.h,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        startStage(),
                        SizedBox(height: 5.h),
                        contentList(),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 2.5.h),
                resultbtn(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // 결과물 출력 목록
  Padding contentList() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Column(
        children: [
          Row(
            children: [
              inputwidget("목표★", goalController, 30),
              SizedBox(width: 4.w),
              destroywidget(),
            ],
          ),
          SizedBox(height: 5.h),
          Row(
            children: [
              inputwidget("횟수★", tryController, 10),
              SizedBox(width: 4.w),
              equipLevelwidget(),
            ],
          ),
          SizedBox(height: 5.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              avgtimes('시도 횟수', "$totalTry회", 14),
              avgtimes('시도 메소', '${formatPower(totalMeso)} 메소', 9),
              destroytime('파괴확률', '$totalDestroy%', 12),
              eventbtn(),
            ],
          ),

          SizedBox(height: 5.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              starTable(),
              // StarforceBarChart(rows: rows),
            ],
          ),
          SizedBox(height: 7.h),
        ],
      ),
    );
  }

  //시작 설정 슬라이드
  Container listData<T>(
    String title,
    T value,
    List<T> values,
    ValueChanged<T?> onChanged,
  ) {
    return Container(
      width: 45.w,
      height: 20.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Typicalcolor.bg, // ✅ 흰색 → 배경색
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Typicalcolor.subborder),
        boxShadow: [
          BoxShadow(
            color: Typicalcolor.subfont.withValues(alpha: 0.2), // ✅ 부드러운 그림자
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: Center(
          // 1) 드롭다운 버튼 자체를 부모 안에서 중앙 배치
          child: SizedBox(
            // 원하는 너비로 세팅 (없으면 꽉 참)
            child: DropdownButton<T>(
              value: value,
              isExpanded: true, // 가로로 꽉 채우기
              alignment: Alignment.center, // 2) 버튼 안의 선택 텍스트 중앙 정렬
              hint: Center(
                // 힌트도 중앙 정렬
                child: Text(title, textAlign: TextAlign.center),
              ),
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
                color: Typicalcolor.subfont,
              ),
              items: values.map((d) {
                return DropdownMenuItem<T>(
                  value: d,
                  alignment: Alignment.center, // 3) 메뉴 아이템 중앙 정렬
                  child: Center(
                    child: Text(d.toString(), textAlign: TextAlign.center),
                  ),
                );
              }).toList(),

              // 선택된 아이템이 버튼에 표시될 때도 확실히 중앙 정렬시키고 싶다면:
              selectedItemBuilder: (context) => values.map((d) {
                return Center(
                  child: Text(d.toString(), textAlign: TextAlign.center),
                );
              }).toList(),

              onChanged: onChanged,
            ),
          ),
        ),
      ),
    );
  }

  //스타포스 시작 성
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
              colors: [Typicalcolor.title, Typicalcolor.subtitle],
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
              twoText("${_value.toInt()}성", 14),
            ],
          ),
        ),
      ),
    );
  }

  //입력하는 위젯
  Widget inputwidget(String title, TextEditingController controller, int max) {
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
            colors: [Typicalcolor.title, Typicalcolor.subtitle],
          ),
          borderRadius: BorderRadius.circular(9.r),
          border: Border.all(color: Color(0xFF000000)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                twoText(title, 14),

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
                controller: controller,
                maxLength: 2,
                keyboardType: TextInputType.number, // 숫자 키패드
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // 숫자만 허용
                  RangeInputFormatter(max),
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

  //파괴방지 버튼
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
            colors: [Typicalcolor.title, Typicalcolor.subtitle],
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

  //장비 레벨 설정칸
  Container equipLevelwidget() {
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
            colors: [Typicalcolor.title, Typicalcolor.subtitle],
          ),
          borderRadius: BorderRadius.circular(9.r),
          border: Border.all(color: Color(0xFF000000)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                twoText('장비레벨', 14),
                SizedBox(width: 5.w),
                Container(
                  width: 2.w,
                  height: 30.h,
                  decoration: BoxDecoration(color: Typicalcolor.subfont),
                ),
                SizedBox(width: 5.w),
                listData<int>("레벨 설정", equips, equiplevel, (value) {
                  setState(() {
                    equips = value!;
                  });
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //평균 출력 위젯
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
            colors: [Typicalcolor.title, Typicalcolor.subtitle],
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

  //파괴 확률 위젯
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
            colors: [Typicalcolor.title, Typicalcolor.subtitle],
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

  //이벤트 여부 버튼
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
            colors: [Typicalcolor.title, Typicalcolor.subtitle],
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
              children: [twoText('OFF', 9), twoText('ON', 9)],
            ),
          ],
        ),
      ),
    );
  }

  //각 성마다 성공률&메소사용량
  Widget starTable() {
    return Container(
      width: 314,
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
            colors: [Typicalcolor.title, Typicalcolor.subtitle],
          ),
          borderRadius: BorderRadius.circular(9.r),
          border: Border.all(color: Typicalcolor.font),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Table(
            columnWidths: const {
              0: FixedColumnWidth(40), // 성
              1: FlexColumnWidth(0.5), // 성공률
              2: FlexColumnWidth(2), // 기대 메소
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
                      colors: [Typicalcolor.bg, Typicalcolor.subbg],
                    ),
                  ),
                  children: [
                    // 성 정보 (예: 1→2)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.h),
                      child: Align(
                        alignment: Alignment.center,
                        child: twoText("${r.star}→${r.star + 1}", 10),
                      ),
                    ),
                    // 시도 횟수
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.h),
                      child: Align(
                        alignment: Alignment.center,
                        child: twoText("${r.attempts}", 10),
                      ),
                    ),
                    // 총 메소 (오른쪽 정렬)
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 5.h,
                        horizontal: 2.w,
                      ),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: twoText('${formatPower(r.mesoSpent)} 메소', 10),
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

  //결과 버튼
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

        final target = (goalController.text.isEmpty)
            ? _value.toInt() + 1
            : (int.parse(goalController.text.trim()) <= _value.toInt())
            ? _value.toInt() + 1
            : int.parse(goalController.text.trim());

        final once = await sim.simulateOnce(
          equipLevel: equips,
          start: _value.toInt(),
          target: target,
          cfg: cfg,
          collectDetail: true,
        );

        List<PerStarStat> getOrderedPerStar(
          SimResult r, {
          required int start, // 보통 1
          required int target, // 예: 22면 1~21
        }) {
          final map = r.perStar ?? const {};
          final list = <PerStarStat>[];

          for (int k = start; k < target; k++) {
            // 방문하지 않은 성도 표에 보여주고 싶으면 빈 행 생성
            final s = map[k] ?? PerStarStat(k);
            list.add(s);
          }
          // 혹시 안전하게 정렬
          list.sort((a, b) => a.star.compareTo(b.star));
          return list;
        }

        final r = getOrderedPerStar(
          once,
          start: _value.toInt(),
          target: target,
        );

        setState(() {
          totalTry = once.tries;
          totalMeso = once.totalMeso;
          totalDestroy = (once.destroyCount / once.tries).toStringAsFixed(2);

          goalController.text = target.toString();
          rows = r;
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
              colors: [Typicalcolor.title, Typicalcolor.subtitle],
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
