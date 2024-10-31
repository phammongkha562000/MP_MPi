import 'package:flutter/material.dart';
import 'package:mpi_new/presentations/widgets/dot_line/dot_line_painter.dart';

class DottedLine extends StatelessWidget {
  final double dashWidth;
  final double dashSpace;
  final Color color;

  const DottedLine({
    super.key,
    required this.dashWidth,
    required this.dashSpace,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DottedLinePainter(
        dashWidth: dashWidth,
        dashSpace: dashSpace,
        color: color,
      ),
      child: const SizedBox(
        height: 1, // Chiều cao của đường kẻ
        width: double.infinity, // Chiều rộng của đường kẻ
      ),
    );
  }
}
