import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:mic/bar/mic_appbarone.dart';
import 'package:mic/bar/mic_underbar.dart';
import 'package:mic/function/currentuser.dart';
import 'package:mic/function/datas.dart';
import 'package:mic/model/basic.dart';
import 'package:mic/model/stat.dart';
import 'package:mic/screens/cube_screen.dart';
import 'package:mic/screens/exp_screen.dart';
import 'package:mic/screens/mainhome_screen.dart';
import 'package:mic/screens/star_screen.dart';
import 'package:mic/service/basicservice.dart';
import 'package:mic/service/statservice.dart';

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
                        FutureBuilder<Basic>(
                          future: basic,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (snapshot.hasError) {
                              return Center(
                                child: Text('오류 발생: ${snapshot.error}'),
                              );
                            }
                            if (!snapshot.hasData) {
                              return const Center(child: Text('데이터 없음'));
                            }

                            final b = snapshot.data!;

                            return Row(
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
                                    profileText(
                                      '레벨: ',
                                      b.characterlevel.toString(),
                                    ),
                                    profileText('직업: ', b.characterclass),
                                    profileText('월드: ', b.worldname),

                                    FutureBuilder<Map<String, Stat>>(
                                      future: statMap,
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const CircularProgressIndicator();
                                        }
                                        if (snapshot.hasError) {
                                          return Text("에러: ${snapshot.error}");
                                        }

                                        final data = snapshot.data!;
                                        final combat = data["전투력"];
                                        return profileText(
                                          '전투력: ',
                                          combat!.statValueRaw,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                        Container(
                          width: 400.w,
                          height: 110.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(17.r),
                            border: Border.all(color: Colors.black, width: 2.w),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter, // 시작점 (위쪽)
                              end: Alignment.bottomCenter, // 끝점 (아래쪽)
                              colors: [Color(0xFFfffcf5), Color(0xFFd8d5ca)],
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  bossIcon(
                                    bossimg[0],

                                    '검은마법사',
                                    [1000000000, 9200000000],
                                    ['하드', '익스트림'],
                                    [1, 2, 3, 4, 5, 6],
                                  ), // 검은마법사
                                ],
                              ),
                              SizedBox(height: 5.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  bossIcon(
                                    bossimg[1],

                                    '발드릭스',
                                    [1200000000, 2160000000],
                                    ['노말', '하드'],
                                    [1, 2, 3],
                                  ), // 발드릭스
                                  SizedBox(width: 2.w),
                                  bossIcon(
                                    bossimg[2],

                                    '림보',
                                    [900000000, 1930000000],
                                    ['노말', '하드'],
                                    [1, 2, 3],
                                  ), // 림보
                                  SizedBox(width: 2.w),
                                  bossIcon(
                                    bossimg[3],

                                    '카링',
                                    [
                                      381000000,
                                      595000000,
                                      1310000000,
                                      3150000000,
                                    ],
                                    ['이지', '노말', '하드', '익스트림'],
                                    [1, 2, 3, 4, 5, 6],
                                  ), // 카링
                                  SizedBox(width: 2.w),
                                  bossIcon(
                                    bossimg[5],

                                    '칼로스',
                                    [
                                      345000000,
                                      510000000,
                                      1120000000,
                                      2700000000,
                                    ],
                                    ['이지', '노말', '하드', '익스트림'],
                                    [1, 2, 3, 4, 5, 6],
                                  ), // 칼로스
                                  SizedBox(width: 2.w),
                                  bossIcon(
                                    bossimg[6],

                                    '세렌',
                                    [295000000, 440000000, 2420000000],
                                    ['노말', '하드', '익스트림'],
                                    [1, 2, 3, 4, 5, 6],
                                  ), // 세렌
                                  SizedBox(width: 2.w),
                                  bossIcon(
                                    bossimg[7],

                                    '스우',
                                    [22000000, 77400000, 549000000],
                                    ['노말', '하드', '익스트림'],
                                    [1, 2, 3, 4, 5, 6],
                                  ), // 스우
                                  SizedBox(width: 2.w),
                                  bossIcon(
                                    bossimg[8],

                                    '진힐라',
                                    [107000000, 160000000],
                                    ['노말', '하드'],
                                    [1, 2, 3, 4, 5, 6],
                                  ), // 진힐라
                                  SizedBox(width: 2.w),
                                  bossIcon(
                                    bossimg[9],

                                    '듄켈',
                                    [62500000, 142000000],
                                    ['노말', '하드'],
                                    [1, 2, 3, 4, 5, 6],
                                  ), // 듄켈
                                  SizedBox(width: 2.w),
                                  bossIcon(
                                    bossimg[10],

                                    '가디언엔젤슬라임',
                                    [33500000, 113000000],
                                    ['노말', '하드'],
                                    [1, 2, 3, 4, 5, 6],
                                  ), // 가디언 엔젤 슬라임
                                  SizedBox(width: 2.w),
                                  bossIcon(
                                    bossimg[11],

                                    '더스크',
                                    [57900000, 105000000],
                                    ['노말', '카오스'],
                                    [1, 2, 3, 4, 5, 6],
                                  ), // 더스크
                                  SizedBox(width: 2.w),
                                  bossIcon(
                                    bossimg[12],

                                    '윌',
                                    [42500000, 54100000, 116000000],
                                    ['이지', '노말', '하드'],
                                    [1, 2, 3, 4, 5, 6],
                                  ), // 윌
                                  SizedBox(width: 2.w),
                                  bossIcon(
                                    bossimg[13],

                                    '루시드',
                                    [39200000, 46900000, 94500000],
                                    ['이지', '노말', '하드'],
                                    [1, 2, 3, 4, 5, 6],
                                  ), // 루시드
                                  SizedBox(width: 2.w),
                                  bossIcon(
                                    bossimg[14],

                                    '데미안',
                                    [23000000, 73500000],
                                    ['노말', '하드'],
                                    [1, 2, 3, 4, 5, 6],
                                  ), // 데미안
                                  SizedBox(width: 2.w),
                                ],
                              ),

                              SizedBox(height: 5.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  bossIcon(
                                    bossimg[15],

                                    '파풀라투스',
                                    [390000, 1520000, 17300000],
                                    ['이지', '노말', '카오스'],
                                    [1, 2, 3, 4, 5, 6],
                                  ), // 파풀라투스
                                  SizedBox(width: 2.w),
                                  bossIcon(
                                    bossimg[16],

                                    '벨룸',
                                    [551000, 9280000],
                                    ['노말', '카오스'],
                                    [1, 2, 3, 4, 5, 6],
                                  ), // 벨룸
                                  SizedBox(width: 2.w),
                                  bossIcon(
                                    bossimg[17],

                                    '블러드퀸',
                                    [551000, 8140000],
                                    ['노말', '카오스'],
                                    [1, 2, 3, 4, 5, 6],
                                  ), // 블러드퀸
                                  SizedBox(width: 2.w),
                                  bossIcon(
                                    bossimg[18],

                                    '피에르',
                                    [551000, 8170000],
                                    ['노말', '카오스'],
                                    [1, 2, 3, 4, 5, 6],
                                  ), // 피에르
                                  SizedBox(width: 2.w),
                                  bossIcon(
                                    bossimg[19],

                                    '반반',
                                    [551000, 8150000],
                                    ['노말', '카오스'],
                                    [1, 2, 3, 4, 5, 6],
                                  ), // 반반
                                  SizedBox(width: 2.w),
                                  bossIcon(
                                    bossimg[20],

                                    '매그너스',
                                    [411000, 1480000, 8560000],
                                    ['이지', '노말', '카오스'],
                                    [1, 2, 3, 4, 5, 6],
                                  ), // 매그너스
                                  SizedBox(width: 2.w),
                                  bossIcon(
                                    bossimg[21],

                                    '시그너스',
                                    [4550000, 7500000],
                                    ['이지', '노말'],
                                    [1, 2, 3, 4, 5, 6],
                                  ), // 시그너스
                                  SizedBox(width: 2.w),
                                  bossIcon(
                                    bossimg[22],

                                    '핑크빈',
                                    [799000, 6580000],
                                    ['노말', '카오스'],
                                    [1, 2, 3, 4, 5, 6],
                                  ), // 핑크빈
                                  SizedBox(width: 2.w),
                                  bossIcon(
                                    bossimg[23],

                                    '힐라',
                                    [455000, 5750000],
                                    ['노말', '하드'],
                                    [1, 2, 3, 4, 5, 6],
                                  ), // 힐라
                                  SizedBox(width: 2.w),
                                  bossIcon(
                                    bossimg[24],

                                    '자쿰',
                                    [114000, 349000, 8080000],
                                    ['이지', '노말', '카오스'],
                                    [1, 2, 3, 4, 5, 6],
                                  ), // 자쿰
                                  SizedBox(width: 2.w),
                                  bossIcon(
                                    bossimg[25],

                                    '아카이럼',
                                    [656000, 1430000],
                                    ['이지', '노말'],
                                    [1, 2, 3, 4, 5, 6],
                                  ), // 아카이럼
                                  SizedBox(width: 2.w),
                                  bossIcon(
                                    bossimg[26],

                                    '반레온',
                                    [602000, 830000, 1390000],
                                    ['이지', '노말', '하드'],
                                    [1, 2, 3, 4, 5, 6],
                                  ), // 반레온
                                  SizedBox(width: 2.w),
                                  bossIcon(
                                    bossimg[27],

                                    '혼테일',
                                    [502000, 576000, 770000],
                                    ['이지', '노말', '카오스'],
                                    [1, 2, 3, 4, 5, 6],
                                  ), // 혼테일
                                  SizedBox(width: 2.w),
                                ],
                              ),
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
                              colors: [Color(0xFFfffcf5), Color(0xFFd8d5ca)],
                            ),
                            border: Border.all(color: Colors.black, width: 4.w),
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
                              Text(
                                '${formatNumber(sumprice)} 메소',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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
          colors: [Color(0xFFfffcf5), Color(0xFFd8d5ca)],
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
              child: Image.network(
                item['bossimg'],
                width: 14.w,
                height: 14.h,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 4.w),
            SizedBox(
              width: 40.w,
              child: Text(item['bossname'], style: TextStyle(fontSize: 8.sp)),
            ),
            SizedBox(width: 4.w),
            SizedBox(
              width: 80.w,
              child: Text(
                '${formatNumber(item['sumP'])} 메소',
                style: TextStyle(fontSize: 8.sp),
              ),
            ),
            SizedBox(width: 4.w),

            SizedBox(
              width: 50.w,
              child: DropdownButton<String>(
                value: item['selD'],
                hint: const Text('난이도 선택'),
                isExpanded: true,
                style: const TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
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
                style: const TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
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
          begin: Alignment.topCenter, // 시작점 (위쪽)
          end: Alignment.bottomCenter, // 끝점 (아래쪽)
          colors: [Color(0xFF6a8aff), Color(0xFFb2fbff)],
        ),
        border: Border.all(color: Colors.black, width: 4.w),
      ),
      child: Text(
        title,
        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
      ),
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
        child: Image.network(img, width: 19.w, height: 19.h, fit: BoxFit.cover),
      ),
    );
  }

  Row profileText(String title, String b) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(width: 10.w),
        Text(
          b,
          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
