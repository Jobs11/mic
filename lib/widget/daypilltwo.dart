import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum SimTab { arcane, grandis }

class Daypilltwo extends StatelessWidget {
  const Daypilltwo({
    super.key,
    required this.value,
    required this.onChanged,
    this.height = 40,
  });

  final SimTab value;
  final ValueChanged<SimTab> onChanged;
  final double height;

  // 테마 컬러 (이미지 톤과 매칭)
  static const _cream = Color(0xFFF3DFAC); // 내부 배경
  static const _creamHover = Color(0xFFF9E8BF); // 선택 시 약간 진하게
  static const _brown = Color(0xFF6E4A2B); // 외곽/구분선
  static const _brownSoft = Color(0xFF8B5E3C); // 살짝 밝은 브라운

  @override
  Widget build(BuildContext context) {
    final isLeft = value == SimTab.arcane;
    final isRight = value == SimTab.grandis;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: _brown, width: 2),
        boxShadow: const [
          // 상단 박스와 비슷한 살짝의 입체감
          BoxShadow(offset: Offset(0, 1), blurRadius: 0, color: _brownSoft),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(7.r),
        child: Row(
          children: [
            // 왼쪽
            Expanded(
              child: InkWell(
                onTap: () => onChanged(SimTab.arcane),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 120),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isLeft ? _creamHover : _cream,
                  ),
                  child: Text(
                    '아케인 리버',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            // 가운데 구분선
            Container(width: 1.5, color: _brown),
            // 오른쪽
            Expanded(
              child: InkWell(
                onTap: () => onChanged(SimTab.grandis),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 120),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isRight ? _creamHover : _cream,
                  ),
                  child: Text(
                    '그란디스',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
