import 'package:flutter/material.dart';

class XStrike extends StatefulWidget {
  final double size;
  final Color color;
  final double strokeWidth;
  final Duration drawDuration;
  final Duration fadeDuration;
  const XStrike({
    super.key,
    this.size = 64,
    this.color = const Color(0xFF8b8b89),
    this.strokeWidth = 6,
    this.drawDuration = const Duration(milliseconds: 350),
    this.fadeDuration = const Duration(milliseconds: 250),
  });

  @override
  State<XStrike> createState() => XStrikeState();
}

class XStrikeState extends State<XStrike> with TickerProviderStateMixin {
  late final AnimationController _draw;
  late final AnimationController _fade;

  /// 외부에서 호출해 애니메이션 재생
  void play() async {
    _fade.value = 0; // 불투명
    await _draw.forward(from: 0); // 그리기
    await Future.delayed(const Duration(milliseconds: 120));
    await _fade.forward(from: 0); // 페이드아웃
  }

  @override
  void initState() {
    super.initState();
    _draw = AnimationController(vsync: this, duration: widget.drawDuration);
    _fade = AnimationController(vsync: this, duration: widget.fadeDuration);
  }

  @override
  void dispose() {
    _draw.dispose();
    _fade.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: FadeTransition(
        opacity: Tween<double>(begin: 1, end: 0).animate(_fade),
        child: AnimatedBuilder(
          animation: _draw,
          builder: (_, __) => CustomPaint(
            painter: _XPainter(
              progress: _draw.value,
              color: widget.color,
              strokeWidth: widget.strokeWidth,
            ),
          ),
        ),
      ),
    );
  }
}

class _XPainter extends CustomPainter {
  final double progress; // 0~1
  final Color color;
  final double strokeWidth;

  _XPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    // progress 0~0.5: 첫 대각선, 0.5~1.0: 두 번째 대각선
    final half = 0.5;
    final p1Start = const Offset(0, 0);
    final p1End = Offset(size.width, size.height);
    final p2Start = Offset(size.width, 0);
    final p2End = Offset(0, size.height);

    if (progress <= half) {
      final t = progress / half; // 0~1
      final current = Offset.lerp(p1Start, p1End, t)!;
      canvas.drawLine(p1Start, current, paint);
    } else {
      // 첫 선은 완성
      canvas.drawLine(p1Start, p1End, paint);
      final t = (progress - half) / half; // 0~1
      final current = Offset.lerp(p2Start, p2End, t)!;
      canvas.drawLine(p2Start, current, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _XPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.color != color ||
      oldDelegate.strokeWidth != strokeWidth;
}
