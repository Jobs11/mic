import 'package:flutter/material.dart';

class ExprateBar extends StatelessWidget {
  const ExprateBar({
    super.key,
    required this.value, // 0.0 ~ 1.0
    this.height = 32,
  });

  final double value;
  final double height;

  @override
  Widget build(BuildContext context) {
    final v = value.clamp(0.0, 1.0);

    return SizedBox(
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(height * 0.4),
        child: Stack(
          children: [
            // 바깥 배경(어두운 파랑 그라데이션)
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: const [
                    Color(0xFF114E7A), // 위
                    Color(0xFF0A3C62), // 아래
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),

            // 안쪽 패딩 느낌의 트랙(좀 더 밝은 파랑)
            Padding(
              padding: EdgeInsets.all(height * 0.12), // 모서리 둥근 패딩
              child: ClipRRect(
                borderRadius: BorderRadius.circular(height * 0.32),
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF09588f), Color(0xFF094d7f)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
            ),

            // 진행 채움
            Padding(
              padding: EdgeInsets.all(height * 0.12),
              child: LayoutBuilder(
                builder: (context, c) {
                  final w = c.maxWidth * v;
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(height * 0.32),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeOutCubic,
                        width: w,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF2A8AC8), // 왼쪽 밝은 파랑
                              Color(0xFF3BA7ED), // 오른쪽
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // 광택(상단 라운드 하이라이트)
            IgnorePointer(
              child: Padding(
                padding: EdgeInsets.all(height * 0.12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(height * 0.32),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: FractionallySizedBox(
                      alignment: Alignment.topCenter,
                      widthFactor: 1,
                      heightFactor: 0.65,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.white.withValues(alpha: 0.30),
                              Colors.white.withValues(alpha: 0.00),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // 퍼센트 텍스트 (오른쪽 정렬)
            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: height * 0.35),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '${(v * 100).round()} %',
                    style: TextStyle(
                      fontSize: height * 0.55,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFFFBE9C9), // 살짝 크림톤
                      shadows: const [
                        Shadow(
                          blurRadius: 2,
                          color: Colors.black45,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // 바깥 테두리(얇은 어두운 라인)
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF08314E), width: 2),
                borderRadius: BorderRadius.circular(height * 0.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
