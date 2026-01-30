import 'dart:async';
import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/configuration/color_constants.dart';
import '../../../shared/models/todo_model.dart';
import '../providers/todo_provider.dart';

class PickerWheelScreen extends ConsumerStatefulWidget {
  const PickerWheelScreen({super.key});

  @override
  ConsumerState<PickerWheelScreen> createState() => _PickerWheelScreenState();
}

class _PickerWheelScreenState extends ConsumerState<PickerWheelScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late ConfettiController _confettiController;
  
  double _currentRotation = 0;
  bool _isSpinning = false;
  Todo? _selectedTodo;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  double _getEffectiveWeight(Todo todo) {
    final weight = todo.weight.toDouble();
    return weight > 0 ? weight : 1.0;
  }

  double _getTotalWeight(List<Todo> todos) {
    return todos.fold(0.0, (sum, todo) => sum + _getEffectiveWeight(todo));
  }

  double _getSegmentAngle(Todo todo, double totalWeight) {
    return (_getEffectiveWeight(todo) / totalWeight) * 2 * pi;
  }

  int _selectWeightedTodo(List<Todo> todos) {
    final totalWeight = _getTotalWeight(todos);
    final randomValue = _random.nextDouble() * totalWeight;
    
    double cumulative = 0;
    for (int i = 0; i < todos.length; i++) {
      cumulative += _getEffectiveWeight(todos[i]);
      if (randomValue <= cumulative) {
        return i;
      }
    }
    return todos.length - 1;
  }

  void _spin(List<Todo> todos) {
    if (_isSpinning || todos.isEmpty) return;

    setState(() {
      _isSpinning = true;
      _selectedTodo = null;
    });

    final selectedIndex = _selectWeightedTodo(todos);
    final totalWeight = _getTotalWeight(todos);

    // Calculate the start angle of the selected segment
    double segmentStartAngle = 0;
    for (int i = 0; i < selectedIndex; i++) {
      segmentStartAngle += _getSegmentAngle(todos[i], totalWeight);
    }

    final segmentAngle = _getSegmentAngle(todos[selectedIndex], totalWeight);
    final segmentCenterAngle = segmentStartAngle + (segmentAngle / 2);

    // Add randomness within the segment (stay within 70% of center)
    final randomOffset = (_random.nextDouble() - 0.5) * segmentAngle * 0.7;
    final targetAngle = segmentCenterAngle + randomOffset;

    // Calculate the absolute rotation needed for the segment to land at the top
    // When wheel rotation = R, segment at targetAngle appears at (-pi/2 + targetAngle + R)
    // We want it at -pi/2 (top), so: R = -targetAngle (mod 2pi) = 2pi - targetAngle
    final targetAbsoluteRotation = (2 * pi - targetAngle) % (2 * pi);
    
    // Calculate how much more we need to rotate from current position
    final currentNormalized = _currentRotation % (2 * pi);
    var delta = targetAbsoluteRotation - currentNormalized;
    if (delta < 0) delta += 2 * pi; // ensure we always rotate forward
    
    final baseSpins = 5 + _random.nextInt(3); // 5-7 full rotations
    final finalRotation = _currentRotation + (baseSpins * 2 * pi) + delta;

    _animation = Tween<double>(
      begin: _currentRotation,
      end: finalRotation,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _animation.addListener(() {
      setState(() {
        _currentRotation = _animation.value;
      });
    });

    _controller.forward(from: 0).then((_) {
      setState(() {
        _isSpinning = false;
        _selectedTodo = todos[selectedIndex];
        _currentRotation = finalRotation % (2 * pi);
      });
      _confettiController.play();
      _showResultDialog(todos[selectedIndex]);
    });
  }

  void _showResultDialog(Todo todo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Selected Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle,
              color: Theme.of(context).colorScheme.primary,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              todo.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final todosAsync = ref.watch(todosProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Wheel'),
      ),
      body: todosAsync.when(
        data: (todos) {
          final incompleteTodos = todos.where((t) => !t.isCompleted).toList();
          
          if (incompleteTodos.isEmpty) {
            return const Center(
              child: Text('No incomplete tasks available'),
            );
          }

          return _buildWheelContent(incompleteTodos);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildWheelContent(List<Todo> todos) {
    return Stack(
      children: [
        Column(
          children: [
            // Wheel section - expands to fill available space
            Expanded(
              flex: 3,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final availableSize = min(
                    constraints.maxWidth,
                    constraints.maxHeight,
                  );
                  final wheelSize = availableSize * 0.85;

                  return Center(
                    child: _buildWheel(todos, wheelSize),
                  );
                },
              ),
            ),
            // Legend section
            Expanded(
              flex: 2,
              child: _buildLegend(todos),
            ),
          ],
        ),
        // Confetti
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirection: pi / 2,
            maxBlastForce: 5,
            minBlastForce: 2,
            emissionFrequency: 0.05,
            numberOfParticles: 20,
            gravity: 0.1,
          ),
        ),
      ],
    );
  }

  Widget _buildWheel(List<Todo> todos, double size) {
    final centerButtonSize = size * 0.23;
    final pointerSize = size * 0.12;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer glow
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: ColorConstants.accentLight.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
          ),
          // The wheel
          Transform.rotate(
            angle: _currentRotation,
            child: CustomPaint(
              size: Size(size, size),
              painter: WheelPainter(
                todos: todos,
                getSegmentAngle: _getSegmentAngle,
                getTotalWeight: _getTotalWeight,
              ),
            ),
          ),
          // Pointer at top
          Positioned(
            top: 0,
            child: CustomPaint(
              size: Size(pointerSize, pointerSize * 1.3),
              painter: PointerPainter(),
            ),
          ),
          // Center button
          GestureDetector(
            onTap: () => _spin(todos),
            child: Container(
              width: centerButtonSize,
              height: centerButtonSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    ColorConstants.accentLight,
                    ColorConstants.accentLight.withOpacity(0.7),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  _isSpinning ? '...' : 'SPIN',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: centerButtonSize * 0.25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(List<Todo> todos) {
    final totalWeight = _getTotalWeight(todos);
    final colors = _generateColors(todos.length);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tasks',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];
                final weight = _getEffectiveWeight(todo);
                final percentage = (weight / totalWeight * 100).toStringAsFixed(1);

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: colors[index],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          todo.title,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: _selectedTodo?.id == todo.id
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                      Text(
                        '$percentage%',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Color> _generateColors(int count) {
    final colors = <Color>[];
    for (int i = 0; i < count; i++) {
      final hue = (i * 360 / count) % 360;
      colors.add(HSLColor.fromAHSL(1, hue, 0.7, 0.5).toColor());
    }
    return colors;
  }
}

class WheelPainter extends CustomPainter {
  final List<Todo> todos;
  final double Function(Todo, double) getSegmentAngle;
  final double Function(List<Todo>) getTotalWeight;

  WheelPainter({
    required this.todos,
    required this.getSegmentAngle,
    required this.getTotalWeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final totalWeight = getTotalWeight(todos);

    // Start from top (-pi/2)
    double currentAngle = -pi / 2;

    for (int i = 0; i < todos.length; i++) {
      final sweepAngle = getSegmentAngle(todos[i], totalWeight);
      final color = HSLColor.fromAHSL(1, (i * 360 / todos.length) % 360, 0.7, 0.5).toColor();

      // Draw segment
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        currentAngle,
        sweepAngle,
        true,
        paint,
      );

      // Draw border
      final borderPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        currentAngle,
        sweepAngle,
        true,
        borderPaint,
      );

      // Draw number in segment
      final midAngle = currentAngle + sweepAngle / 2;
      final textRadius = radius * 0.7;
      final textX = center.dx + textRadius * cos(midAngle);
      final textY = center.dy + textRadius * sin(midAngle);

      final textPainter = TextPainter(
        text: TextSpan(
          text: '${i + 1}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: Colors.black54,
                blurRadius: 2,
                offset: Offset(1, 1),
              ),
            ],
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(textX - textPainter.width / 2, textY - textPainter.height / 2),
      );

      currentAngle += sweepAngle;
    }

    // Draw outer ring
    final ringPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    canvas.drawCircle(center, radius, ringPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class PointerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    final path = Path()
      ..moveTo(size.width / 2, size.height)
      ..lineTo(0, 0)
      ..lineTo(size.width, 0)
      ..close();

    // Draw shadow
    canvas.drawPath(path.shift(const Offset(2, 2)), shadowPaint);
    // Draw pointer
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
