import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mic/bar/mic_appbarone.dart';
import 'package:mic/bar/mic_underbar.dart';
import 'package:mic/function/currentuser.dart';
import 'package:mic/function/datas.dart';
import 'package:mic/model/basic.dart';
import 'package:mic/screens/boss_screen.dart';
import 'package:mic/screens/cube_screen.dart';
import 'package:mic/screens/exp_screen.dart';
import 'package:mic/screens/star_screen.dart';
import 'package:mic/service/basicservice.dart';
import 'package:mic/service/ocidservice.dart';

class MainhomeScreen extends StatefulWidget {
  const MainhomeScreen({super.key});

  @override
  State<MainhomeScreen> createState() => _MainhomeScreenState();
}

class _MainhomeScreenState extends State<MainhomeScreen> {
  int _index = 0;
  final nickController = TextEditingController();
  bool ischecked = false;
  late Future<Basic> basic;

  final List<Widget> _pages = const [
    MainhomeScreen(),
    BossScreen(),
    ExpScreen(),
    CubeScreen(),
    StarScreen(),
  ];

  @override
  void initState() {
    super.initState();
    if (CurrentUser.instance.ocid != null) {
      ischecked = true;
      basic = Basicservice.getOcidByCharacterName(
        CurrentUser.instance.ocid!.ocid,
      );
    }
  }

  Future<void> _login() async {
    final nick = nickController.text.trim();

    try {
      final ocid = await Ocidservice.getOcidByCharacterName(nick); // GET 요청

      // 로그인 성공 시 전역 상태나 Provider 등에 저장
      CurrentUser.instance.ocid = ocid;

      basic = Basicservice.getOcidByCharacterName(ocid.ocid);

      setState(() {
        ischecked = true;
      });

      Fluttertoast.showToast(
        msg: "닉네임($nick) 적용 확인되었습니다.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: const Color(0xAA000000),
        textColor: Colors.white,
        fontSize: 16.0.sp,
      );

      // 메인 페이지 이동
      if (!mounted) return;
    } catch (e) {
      Fluttertoast.showToast(
        msg: "닉네임 입력 실패! $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: const Color(0xAA000000),
        textColor: Colors.white,
        fontSize: 16.0.sp,
      );
    } finally {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MicAppbarone(
        title: "메이플 계산기",
        scolor: Color(0xFFf7e5c4),
        ecolor: Color(0xFFfffaf0),
        barimg: 'assets/images/icons/culbar.png',
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
                        // Stack(
                        //   clipBehavior: Clip.none,
                        //   alignment: Alignment.center,
                        //   children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset(
                              'assets/images/icons/rope.png',
                              width: 270.w,
                              height: 240.h,
                            ),
                            Positioned(
                              top: 160.h,
                              child: Stack(
                                children: [
                                  // 테두리용 (검정)
                                  Text(
                                    textAlign: TextAlign.center,
                                    "캐릭터 닉네임 \n입력",
                                    style: TextStyle(
                                      fontSize: 22.sp,
                                      fontWeight: FontWeight.bold,
                                      foreground: Paint()
                                        ..style = PaintingStyle.stroke
                                        ..strokeWidth = 6.w
                                        ..color = Color(0xFF462406),
                                    ),
                                  ),
                                  // 안쪽 텍스트 (흰색)
                                  Text(
                                    textAlign: TextAlign.center,
                                    "캐릭터 닉네임 \n입력",
                                    style: TextStyle(
                                      fontSize: 22.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFf2c568),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        // Positioned(
                        //   top: 200.h,
                        //   child:
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Transform.rotate(
                              angle: -0.02,
                              child: Image.asset(
                                'assets/images/icons/pane.png',
                                width: 270.w,
                                height: 270.h,
                              ),
                            ),

                            Positioned(
                              top: 65
                                  .h, // 원하는 위치 지정 (필수: top/left/right/bottom 중 최소 하나)
                              left: 0,
                              right: 0,
                              child: (ischecked) ? hasOcid() : nonOcid(),
                            ),
                          ],
                        ),
                        // ),
                      ],
                    ),
                    // ],
                  ),
                ),
                // ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: MicUnderbar(
        currentIndex: _index,
        onTap: (i) {
          (CurrentUser.instance.ocid != null)
              ? {
                  setState(() => _index = i),
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => _pages[_index]),
                  ),
                }
              : (Fluttertoast.showToast(
                  msg: "닉네임을 입력하고 넘어가주세요.",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: const Color(0xAA000000),
                  textColor: Colors.white,
                  fontSize: 16.0.sp,
                ));
        }, // ✅ 눌렀을 때 화면 전환
      ),
    );
  }

  Column hasOcid() {
    return Column(
      children: [
        FutureBuilder<Basic>(
          future: basic,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('오류 발생: ${snapshot.error}'));
            }
            if (!snapshot.hasData) {
              return const Center(child: Text('데이터 없음'));
            }

            final b = snapshot.data!;

            return Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color(0xFFe1bf77),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: Color(0xFF000000), width: 2.w),
              ),
              width: 160.w,
              height: 32.h,
              child: Text(
                b.charactername,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF000000),
                ),
              ),
            );
          },
        ),
        SizedBox(height: 11.h),
        GestureDetector(
          onTap: () {
            setState(() {
              CurrentUser.instance.ocid = null;
              ischecked = false;
            });
          },
          child: Container(
            alignment: Alignment.center,
            width: 100.w,
            height: 25.h,
            decoration: BoxDecoration(
              color: Color(0xFFb55809),
              border: Border.all(color: Color(0xFF000000), width: 2.w),
              borderRadius: BorderRadius.circular(17.r),
            ),
            child: Stack(
              children: [
                // 테두리용 (검정)
                Text(
                  textAlign: TextAlign.center,
                  "로그아웃",
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 6.w
                      ..color = Color(0xFF462406),
                  ),
                ),
                // 안쪽 텍스트 (흰색)
                Text(
                  textAlign: TextAlign.center,
                  "로그아웃",
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFeec66b),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Column nonOcid() {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Color(0xFFe1bf77),
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: Color(0xFF000000), width: 2.w),
          ),
          width: 160.w,
          height: 32.h,
          child: TextFormField(
            controller: nickController,

            decoration: InputDecoration(
              counterText: '',
              border: InputBorder.none, // 테두리 제거 (BoxDecoration에서 그림)
              hintText: '닉네임', // 플레이스홀더
              hintStyle: TextStyle(
                color: Color(0xFF7f622a),
                fontWeight: FontWeight.bold,
                fontFamily: 'MaplestoryOTFBOLD',
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return '값을 입력해주세요.';
              }
              return null; // 검증 통과
            },
            style: TextStyle(fontSize: 16.sp),
          ),
        ),
        SizedBox(height: 11.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 65.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  _login();
                },
                child: Container(
                  alignment: Alignment.center,
                  width: 60.w,
                  height: 25.h,
                  decoration: BoxDecoration(
                    color: Color(0xFFb55809),
                    border: Border.all(color: Color(0xFF000000), width: 2.w),
                    borderRadius: BorderRadius.circular(17.r),
                  ),
                  child: Stack(
                    children: [
                      // 테두리용 (검정)
                      Text(
                        textAlign: TextAlign.center,
                        "확인",
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 6.w
                            ..color = Color(0xFF462406),
                        ),
                      ),
                      // 안쪽 텍스트 (흰색)
                      Text(
                        textAlign: TextAlign.center,
                        "확인",
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFeec66b),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  nickController.clear();
                  Bossdata.bossList.clear();
                },
                child: Container(
                  alignment: Alignment.center,
                  width: 60.w,
                  height: 25.h,
                  decoration: BoxDecoration(
                    color: Color(0xFF72592d),
                    border: Border.all(color: Color(0xFF000000), width: 2.w),
                    borderRadius: BorderRadius.circular(17.r),
                  ),
                  child: Stack(
                    children: [
                      // 테두리용 (검정)
                      Text(
                        textAlign: TextAlign.center,
                        "리셋",
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 6.w
                            ..color = Color(0xFF462406),
                        ),
                      ),
                      // 안쪽 텍스트 (흰색)
                      Text(
                        textAlign: TextAlign.center,
                        "리셋",
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFeec66b),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
