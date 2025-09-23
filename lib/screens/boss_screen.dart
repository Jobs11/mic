import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:mic/bar/mic_appbarone.dart';
import 'package:mic/bar/mic_underbar.dart';
import 'package:mic/function/currentuser.dart';
import 'package:mic/function/datas.dart';
import 'package:mic/api/model/basic.dart';
import 'package:mic/api/model/stat.dart';
import 'package:mic/screens/cube_screen.dart';
import 'package:mic/screens/exp_screen.dart';
import 'package:mic/screens/mainhome_screen.dart';
import 'package:mic/screens/star_screen.dart';
import 'package:mic/api/service/basicservice.dart';
import 'package:mic/api/service/statservice.dart';

class BossScreen extends StatefulWidget {
  const BossScreen({super.key});

  @override
  State<BossScreen> createState() => _BossScreenState();
}

class _BossScreenState extends State<BossScreen> {
  int _index = 1;
  int sumprice = 0;

  late Future<Basic> basic;
  // late Future<List<Stat>> stat;
  late Future<Map<String, Stat>> statMap;

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
    basic = Basicservice.getOcidByCharacterName(
      CurrentUser.instance.ocid!.ocid,
    );
    statMap = Statservice.getStat(
      CurrentUser.instance.ocid!.ocid,
    ).then((list) => {for (var s in list) s.statName: s});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MicAppbarone(
        title: "보스 결정석",
        scolor: Color(0xFF141415),
        ecolor: Color(0xFF999998),
        barimg: 'assets/images/icons/bossbar.png',
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
                        characterInfo(),
                        SizedBox(height: 6.h),
                        Container(
                          width: 400.w,
                          height: 110.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(17.r),
                            border: Border.all(
                              color: Typicalcolor.border,
                              width: 2.w,
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter, // 시작점 (위쪽)
                              end: Alignment.bottomCenter, // 끝점 (아래쪽)
                              colors: [Typicalcolor.bg, Typicalcolor.subbg],
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  bossIcon(
                                    bossData[0]["이미지"],
                                    bossData[0]["이름"],
                                    bossData[0]["메소"],
                                    bossData[0]["난이도"],
                                    bossData[0]["인원수"],
                                  ),
                                ],
                              ),
                              SizedBox(height: 5.h), // 간격 주기
                              // 행 단위 보스 출력
                              ...buildBossRows(),
                            ],
                          ),
                        ),
                        SizedBox(height: 6.h),
                        SingleChildScrollView(
                          child: SizedBox(
                            height: 160.h,
                            width: double.infinity,

                            child: ListView.builder(
                              itemCount: Bossdata.bossList.length,
                              itemBuilder: (context, index) {
                                final item = Bossdata.bossList[index];

                                return bossbar(item);
                              },
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          height: 28.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(17.r),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter, // 시작점 (위쪽)
                              end: Alignment.bottomCenter, // 끝점 (아래쪽)
                              colors: [Typicalcolor.bg, Typicalcolor.subbg],
                            ),
                            border: Border.all(
                              color: Typicalcolor.border,
                              width: 4.w,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/icons/coin1.png',
                                width: 15.w,
                                height: 15.h,
                              ),
                              SizedBox(width: 5.w),
                              twoText('${formatNumber(sumprice)} 메소', 12),
                            ],
                          ),
                        ),
                        SizedBox(height: 9.h),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    sumprice = Bossdata.bossList.fold<int>(
                                      0, // 초기값
                                      (previousValue, element) {
                                        final value = element['sumP'];
                                        if (value is num) {
                                          return previousValue + value.toInt();
                                        }
                                        return previousValue;
                                      },
                                    );
                                  });
                                },
                                child: btncontainer('계산하기'),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    Bossdata.bossList.clear();
                                    sumprice = 0;
                                  });
                                },
                                child: btncontainer('리셋하기'),
                              ),
                            ],
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

  FutureBuilder<Basic> characterInfo() {
    return FutureBuilder<Basic>(
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
          width: double.infinity,
          height: 170.h,
          padding: EdgeInsets.all(3), // border 두께
          decoration: BoxDecoration(
            color: Typicalcolor.bg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Typicalcolor.bg,
              borderRadius: BorderRadius.circular(9),
              border: Border.all(color: Typicalcolor.border),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Image.network(
                      b.characterimage,
                      width: 120.w,
                      height: 120.h,
                      fit: BoxFit.cover,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        profileText('닉네임: ', b.charactername),
                        profileText('레벨: ', b.characterlevel.toString()),
                        profileText('직업: ', b.characterclass),
                        profileText('월드: ', b.worldname),
                      ],
                    ),
                  ],
                ),
                FutureBuilder<Map<String, Stat>>(
                  future: statMap,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text("에러: ${snapshot.error}");
                    }

                    final data = snapshot.data!;
                    final combat = data["전투력"];
                    return profileText(
                      '전투력: ',
                      formatPower(int.parse(combat!.statValueRaw)),
                      size: 250,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 보스 아이콘 행 생성 함수
  List<Widget> buildBossRows() {
    const int perRow = 9; // 한 줄에 보스 3개씩
    List<Widget> rows = [];

    // "검은마법사"를 제외한 리스트 만들기
    final filtered = bossData.where((boss) => boss["이름"] != "검은마법사").toList();

    for (int i = 0; i < filtered.length; i += perRow) {
      final chunk = filtered.skip(i).take(perRow).toList();

      rows.add(
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: chunk.map((boss) {
              return bossIcon(
                boss["이미지"],
                boss["이름"],
                boss["메소"],
                boss["난이도"],
                boss["인원수"],
              );
            }).toList(),
          ),
        ),
      );
    }
    return rows;
  }

  Container bossbar(Map<String, dynamic> item) {
    final List<int> priceOptions = List<int>.from(item["price"]);
    final List<String> diffOptions = List<String>.from(item["difficulty"]);
    final List<int> personOptions = List<int>.from(item["persons"]);

    return Container(
      height: 21.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(17.r),
        gradient: LinearGradient(
          begin: Alignment.topCenter, // 시작점 (위쪽)
          end: Alignment.bottomCenter, // 끝점 (아래쪽)
          colors: [Typicalcolor.bg, Typicalcolor.subbg],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  Bossdata.bossList.remove(item);
                });
              },
              child: Image.asset(
                'assets/images/icons/close.png',
                width: 15.w,
                height: 15.h,
              ),
            ),
            SizedBox(width: 4.w),
            Container(
              width: 15.w,
              height: 15.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color(0xFFf9f4ed),
                border: Border.all(color: Colors.black, width: 1.w),
              ),
              child: Image.asset(
                item['bossimg'],
                width: 14.w,
                height: 14.h,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 4.w),
            SizedBox(width: 40.w, child: twoText(item['bossname'], 8)),
            SizedBox(width: 4.w),
            SizedBox(
              width: 80.w,
              child: twoText('${formatNumber(item['sumP'])} 메소', 8),
            ),
            SizedBox(width: 4.w),

            SizedBox(
              width: 50.w,
              child: DropdownButton<String>(
                value: item['selD'],
                hint: const Text('난이도 선택'),
                isExpanded: true,
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                  color: Typicalcolor.font,
                ),
                items: diffOptions
                    .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    item["selD"] = value; // 이 아이템의 선택값만 갱신

                    // 선택된 난이도의 인덱스 찾기
                    final idx = diffOptions.indexOf(value!);

                    // 같은 인덱스의 가격을 selP에 저장
                    if (idx != -1 && idx < priceOptions.length) {
                      item["selP"] = priceOptions[idx];
                    }
                    item["sumP"] = (item['selP'] / item['selN']).round();
                  });
                },
              ),
            ),
            SizedBox(width: 4.w),
            SizedBox(
              width: 40.w,
              child: DropdownButton<int>(
                value: item['selN'],
                hint: const Text('파티 인원 선택'),
                isExpanded: true,
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                  color: Typicalcolor.font,
                ),
                items: personOptions
                    .map(
                      (d) =>
                          DropdownMenuItem(value: d, child: Text(d.toString())),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    item["selN"] = value; // 이 아이템의 선택값만 갱신
                    item["sumP"] = (item['selP'] / item['selN']).round();
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container btncontainer(String title) {
    return Container(
      alignment: Alignment.center,
      width: 70.w,
      height: 28.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(17.r),
        gradient: LinearGradient(
          begin: Alignment.centerLeft, // 시작점 (위쪽)
          end: Alignment.centerRight, // 끝점 (아래쪽)
          colors: [Typicalcolor.title, Typicalcolor.subtitle],
        ),
        border: Border.all(color: Typicalcolor.border, width: 4.w),
      ),
      child: twoText(title, 12),
    );
  }

  Widget bossIcon(
    String img,
    String name,
    List<int> price,
    List<String> difficulty,
    List<int> num, {
    int? selP,
    String? selD,
    int? selN,
  }) {
    final currentP = selP ?? (price.first);
    final currentD = selD ?? (difficulty.first);
    final currentN = selN ?? (num.first);

    return GestureDetector(
      onTap: () {
        // 중복 여부 체크
        setState(() {
          final exists = Bossdata.bossList.any(
            (boss) => boss["bossname"] == name,
          );

          if (!exists) {
            Bossdata.bossList.add({
              "bossimg": img,
              "bossname": name,
              "price": price,
              "difficulty": difficulty,
              "persons": num,
              "selP": currentP,
              "selD": currentD,
              "selN": currentN,
              "sumP": (currentP / currentN).round(),
            });

            Fluttertoast.showToast(
              msg: "보스를 추가하였습니다.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: const Color(0xAA000000),
              textColor: Colors.white,
              fontSize: 16.0.sp,
            );
          } else {
            Fluttertoast.showToast(
              msg: "이미 추가된 보스입니다.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: const Color(0xAA000000),
              textColor: Colors.white,
              fontSize: 16.0.sp,
            );
          }
        });
      },
      child: Container(
        alignment: Alignment.center,
        width: 20.w,
        height: 20.h,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2.w),
          gradient: LinearGradient(
            begin: Alignment.topCenter, // 시작점 (위쪽)
            end: Alignment.bottomCenter, // 끝점 (아래쪽)
            colors: [Color(0xFFffffff), Color(0xFFc5c5c5)],
          ),
        ),
        child: Image.asset(img, width: 19.w, height: 19.h, fit: BoxFit.cover),
      ),
    );
  }

  Widget profileText(String title, String b, {double? size}) {
    double sized = size ?? 150;
    return Padding(
      padding: EdgeInsets.only(top: 2.h),
      child: Container(
        width: sized.w,
        height: 28.h,
        padding: EdgeInsets.all(3), // border 두께
        decoration: BoxDecoration(
          color: Typicalcolor.subbg,
          border: Border.all(color: Typicalcolor.border),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft, // 시작점 (위쪽)
              end: Alignment.centerRight, // 끝점 (아래쪽)
              colors: [Typicalcolor.title, Typicalcolor.subtitle],
            ),
            border: Border.all(color: Typicalcolor.border),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              twoText(title, 11),
              SizedBox(width: 10.w),
              twoText(b, 11),
            ],
          ),
        ),
      ),
    );
  }
}
