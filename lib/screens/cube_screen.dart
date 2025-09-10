import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mic/bar/mic_appbarone.dart';
import 'package:mic/bar/mic_underbar.dart';
import 'package:mic/function/datas.dart';
import 'package:mic/screens/boss_screen.dart';
import 'package:mic/screens/exp_screen.dart';
import 'package:mic/screens/mainhome_screen.dart';
import 'package:mic/screens/star_screen.dart';
import 'package:mic/widget/pillsegmentedtwo.dart';

class CubeScreen extends StatefulWidget {
  const CubeScreen({super.key});

  @override
  State<CubeScreen> createState() => _CubeScreenState();
}

class _CubeScreenState extends State<CubeScreen> {
  int _index = 3;
  bool isChecked = false;
  int equipindex = 0;
  String equipvalues = equiptype.first;

  final onecubecontroller = TextEditingController();
  final twocubecontroller = TextEditingController();
  final thrcubecontroller = TextEditingController();

  final List<Widget> _pages = const [
    MainhomeScreen(),
    BossScreen(),
    ExpScreen(),
    CubeScreen(),
    StarScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MicAppbarone(
        title: "잠재능력 비용",
        scolor: Color(0xFF336e3e),
        ecolor: Color(0xFF749e4d),
        barimg: 'assets/images/icons/dicebar.png',
      ),
      body: Stack(
        children: [
          // 배경 이미지 (맨 아래)
          Positioned.fill(
            child: Image.asset(
              backgroundsimg[Backgroundnum.bn],
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
                    padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
                    decoration: BoxDecoration(
                      color: Color(0x8CFFFFFF),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      children: [
                        Pillsegmentedtwo(
                          value: isChecked ? SimTab.expected : SimTab.simulator,
                          onChanged: (v) {
                            setState(() {
                              if (v == SimTab.expected) {
                                isChecked = true;
                              } else {
                                isChecked = false;
                              }
                            });
                          },
                        ),
                        SizedBox(height: 5.h),
                        isChecked ? expectedTap() : simulatorTap(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: MicUnderbar(
        currentIndex: _index,
        onTap: (i) {
          setState(() => _index = i);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => _pages[_index]),
          );
        }, // ✅ 눌렀을 때 화면 전환
      ),
    );
  }

  // 시뮬레이터 텝
  Column simulatorTap() {
    return Column(
      children: [
        Container(
          width: 200.w,
          height: 240.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter, // 시작점 (위쪽)
              end: Alignment.bottomCenter, // 끝점 (아래쪽)
              colors: [Color(0xFF141415), Color(0xFF999998)],
            ),
            border: Border.all(color: Color(0xFF999998), width: 2.w),
            borderRadius: BorderRadius.circular(17.r),
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
                    colors: [
                      Color(0xFF94590a), // 위쪽: 어두운 차콜
                      Color(0xFFe7b822), // 아래쪽: 연한 금색
                    ],
                  ),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Text(
                  '잠재능력 옵션',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF000000),
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  width: 100.w,
                  height: 24.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade400),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: DropdownButtonHideUnderline(
                    child: Padding(
                      padding: EdgeInsets.only(left: 8.w), // ← 전체 아이템에 적용
                      child: DropdownButton<String>(
                        value: equipvalues,
                        hint: const Text('아이템 설정'),
                        isExpanded: true,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        items: equiptype
                            .map(
                              (d) => DropdownMenuItem(value: d, child: Text(d)),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            equipindex = equiptype.indexOf(value!);
                            equipvalues = value;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),
              Image.asset(equipimg[equipindex], width: 70.w, height: 70.h),
              SizedBox(height: 5.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Container(
                  decoration: BoxDecoration(color: Color(0xFF000000)),
                  width: double.infinity,
                  height: 2.w,
                ),
              ),
              SizedBox(height: 5.h),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  cubeOption('레전드리', gradeColor['레전드리']!),
                  cubeOption('보스 공격시 데미지 40%', gradeColor['레전드리']!),
                  cubeOption('공격력 9%', gradeColor['유니크']!),
                  cubeOption('공격력 12%', gradeColor['레전드리']!),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 14.h),
        Container(
          width: 92.w,
          height: 92.h,
          padding: EdgeInsets.all(3), // border 두께
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Color(0xFF232323), // 위쪽: 어두운 차콜
                Color(0xFFFFE082), // 아래쪽: 연한 금색
              ],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF232323), // 위쪽: 어두운 차콜
                  Color(0xFFFFE082), // 아래쪽: 연한 금색
                ],
              ),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Column(
              children: [
                Image.asset(
                  'assets/images/items/blackcube.png',
                  width: 50.w,
                  height: 50.h,
                ),
                SizedBox(height: 10.h),
                Text(
                  '재설정',
                  style: TextStyle(
                    color: Color(0xFF232323),
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Color(0x80FFFFFF),
                        blurRadius: 2,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 10.h),
        Container(
          width: 110.w,
          height: 40.h,
          padding: EdgeInsets.all(3), // border 두께
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xFF232323), // 위쪽: 어두운 차콜
                Color(0xFFFFE082), // 아래쪽: 연한 금색
              ],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF3B3B3B), // 위쪽: 어두운 차콜
                  Color(0xFF000000), // 아래쪽: 연한 금색
                ],
              ),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/items/blackcube.png',
                  width: 25.w,
                  height: 25.h,
                ),
                SizedBox(width: 10.w),
                Text(
                  '+1024 개',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Color(0xFFFFFFFF),
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Color(0x80FFFFFF),
                        blurRadius: 2,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 10.h),
        Container(
          width: double.infinity,
          height: 40.h,
          padding: EdgeInsets.all(3), // border 두께
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xFF232323), // 위쪽: 어두운 차콜
                Color(0xFFFFE082), // 아래쪽: 연한 금색
              ],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF3B3B3B), // 위쪽: 어두운 차콜
                  Color(0xFF000000), // 아래쪽: 연한 금색
                ],
              ),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/icons/coin.png',
                  width: 36.w,
                  height: 36.w,
                ),

                SizedBox(width: 50.w),
                Text(
                  '4,000,000,000 메소',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFFFFF),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 10.h),
        Row(children: [btnChoice('계산하기'), btnChoice('초기화')]),
      ],
    );
  }

  Container btnChoice(String title) {
    return Container(
      width: 110.w,
      height: 40.h,
      padding: EdgeInsets.all(3), // border 두께
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFF232323), // 위쪽: 어두운 차콜
            Color(0xFFFFE082), // 아래쪽: 연한 금색
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF3B3B3B), // 위쪽: 어두운 차콜
              Color(0xFF000000), // 아래쪽: 연한 금색
            ],
          ),
          borderRadius: BorderRadius.circular(9),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 24.sp,
            color: Color(0xFFFFFFFF),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Text cubeOption(String title, Color colors) {
    return Text(
      title,
      style: TextStyle(color: colors, fontWeight: FontWeight.bold),
    );
  }

  // 기댓값 텝
  Column expectedTap() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 240.h,
          padding: EdgeInsets.all(3), // border 두께
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xFF232323), // 위쪽: 어두운 차콜
                Color(0xFFb06f0e), // 아래쪽: 연한 금색
              ],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF3B3B3B), // 위쪽: 어두운 차콜
                  Color(0xFF000000), // 아래쪽: 연한 금색
                ],
              ),
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
                      colors: [
                        Color(0xFF94590a), // 위쪽: 어두운 차콜
                        Color(0xFFe7b822), // 아래쪽: 연한 금색
                      ],
                    ),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Text(
                    '잠재능력 옵션 입력칸',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF000000),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center, // 가로축 가운데
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    chooseOption('레전드리'),
                    SizedBox(width: 10.w),
                    chooseOption('방어구'),
                  ],
                ),
                SizedBox(height: 10.h),

                inputOption('보스 공격시 데미지', onecubecontroller),
                SizedBox(height: 10.h),
                inputOption('보스 공격시 데미지', twocubecontroller),
                SizedBox(height: 10.h),
                inputOption('보스 공격시 데미지', thrcubecontroller),
                SizedBox(height: 10.h),
                Container(
                  width: 150.w,
                  height: 32.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF94590a), // 위쪽: 어두운 차콜
                        Color(0xFFe7b822), // 아래쪽: 연한 금색
                      ],
                    ),
                    borderRadius: BorderRadius.circular(9),
                    border: Border.all(color: Color(0XFFb06f0e), width: 2.w),
                  ),
                  child: Text(
                    '계산하기',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF000000),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 10.h),
        expectedList('명장의 큐브', 'assets/images/items/commandercube.png', '24 개'),
        SizedBox(height: 10.h),
        expectedList('블랙 큐브', 'assets/images/items/blackcube.png', '24 개'),
        SizedBox(height: 10.h),
        expectedList('메소 재설정', 'assets/images/icons/coin1.png', '24 개'),
      ],
    );
  }

  Container expectedList(String title, String img, String value) {
    return Container(
      width: double.infinity,
      height: 40.h,
      decoration: BoxDecoration(
        color: Color(0xFF393838),
        border: Border.all(color: Colors.black, width: 2.w),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(img, width: 20.w, height: 20.h),

            SizedBox(width: 10.w),
            Text(
              title,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFFFFF),
              ),
            ),
            SizedBox(width: 10.w),
            Text(
              value,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFFFFF),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container chooseOption(String title) {
    return Container(
      width: 90.w,
      height: 28.h,
      padding: EdgeInsets.all(3), // border 두께
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFF232323), // 위쪽: 어두운 차콜
            Color(0xFFb06f0e), // 아래쪽: 연한 금색
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Color(0xFFf9f4ed),
          borderRadius: BorderRadius.circular(9),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 12.sp,
                color: Color(0xFF000000),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 8.w),
            Image.asset(
              'assets/images/icons/down.png',
              width: 10.h,
              height: 10.h,
            ),
          ],
        ),
      ),
    );
  }

  Row inputOption(String title, TextEditingController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center, // 가로축 가운데
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 180.w,
          height: 28.h,
          padding: EdgeInsets.all(3), // border 두께
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xFF232323), // 위쪽: 어두운 차콜
                Color(0xFFb06f0e), // 아래쪽: 연한 금색
              ],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Color(0xFFf9f4ed),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 12.sp,
                color: Color(0xFF000000),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(width: 10.w),
        Container(
          width: 30.w,
          height: 20.h,

          decoration: BoxDecoration(
            color: Color(0xFFf9f4ed),
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: TextFormField(
            controller: controller,
            maxLength: 2,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              counterText: '',
              border: InputBorder.none, // 테두리 제거 (BoxDecoration에서 그림)
              hintText: '수치', // 플레이스홀더
              hintStyle: TextStyle(
                fontSize: 12.sp,
                color: Color(0xFF7f622a),
                fontWeight: FontWeight.bold,
                fontFamily: 'MaplestoryOTFBOLD',
              ),
            ),

            style: TextStyle(fontSize: 16.sp),
          ),
        ),
      ],
    );
  }
}
