import 'package:flutter/material.dart';

/// Represents a stroke drawn on the canvas.
class DrawingStroke {
  final List<Offset> points;
  final Color color;
  final double strokeWidth;
  final bool isEraser;

  DrawingStroke({
    required this.points,
    required this.color,
    required this.strokeWidth,
    this.isEraser = false,
  });

  Map<String, dynamic> toJson() => {
    'points': points.map((p) => {'x': p.dx, 'y': p.dy}).toList(),
    'color': color.value,
    'strokeWidth': strokeWidth,
    'isEraser': isEraser,
  };

  factory DrawingStroke.fromJson(Map<String, dynamic> json) {
    final pointsData = (json['points'] as List).cast<Map<String, dynamic>>();
    return DrawingStroke(
      points: pointsData
          .map((p) => Offset(p['x'] as double, p['y'] as double))
          .toList(),
      color: Color(json['color'] as int),
      strokeWidth: (json['strokeWidth'] as num).toDouble(),
      isEraser: json['isEraser'] as bool? ?? false,
    );
  }
}

/// Custom painter for drawing strokes.
class DrawingPainter extends CustomPainter {
  final List<DrawingStroke> strokes;

  DrawingPainter(this.strokes);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = Colors.white,
    );

    for (final stroke in strokes) {
      final paint = Paint()
        ..color = stroke.isEraser ? Colors.white : stroke.color
        ..strokeWidth = stroke.strokeWidth
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..blendMode = stroke.isEraser ? BlendMode.clear : BlendMode.srcOver;

      for (int i = 0; i < stroke.points.length - 1; i++) {
        canvas.drawLine(stroke.points[i], stroke.points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) {
    return oldDelegate.strokes.length != strokes.length;
  }
}

/// Drawing canvas widget for creating drawings in notes.
class DrawingCanvas extends StatefulWidget {
  final List<DrawingStroke> initialStrokes;
  final ValueChanged<List<DrawingStroke>>? onStrokesChanged;

  const DrawingCanvas({
    super.key,
    this.initialStrokes = const [],
    this.onStrokesChanged,
  });

  @override
  State<DrawingCanvas> createState() => _DrawingCanvasState();
}

class _DrawingCanvasState extends State<DrawingCanvas> {
  late List<DrawingStroke> _strokes;
  Color _selectedColor = Colors.black;
  double _strokeWidth = 2.0;
  bool _isEraser = false;
  List<Offset> _currentPoints = [];

  @override
  void initState() {
    super.initState();
    _strokes = List.from(widget.initialStrokes);
  }

  void _addStroke() {
    if (_currentPoints.isNotEmpty) {
      setState(() {
        _strokes.add(
          DrawingStroke(
            points: List.from(_currentPoints),
            color: _selectedColor,
            strokeWidth: _strokeWidth,
            isEraser: _isEraser,
          ),
        );
        _currentPoints.clear();
      });
      widget.onStrokesChanged?.call(_strokes);
    }
  }

  void _undo() {
    if (_strokes.isNotEmpty) {
      setState(() {
        _strokes.removeLast();
      });
      widget.onStrokesChanged?.call(_strokes);
    }
  }

  void _clear() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear Drawing'),
        content: const Text(
          'Are you sure you want to clear the entire drawing?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _strokes.clear();
                _currentPoints.clear();
              });
              widget.onStrokesChanged?.call(_strokes);
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Drawing canvas
        Expanded(
          child: GestureDetector(
            onPanStart: (details) {
              setState(() {
                _currentPoints = [details.localPosition];
              });
            },
            onPanUpdate: (details) {
              setState(() {
                _currentPoints.add(details.localPosition);
              });
            },
            onPanEnd: (details) {
              _addStroke();
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: CustomPaint(
                painter: DrawingPainter(_strokes),
                child: Container(),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Drawing tools
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                // Color picker
                Container(
                  decoration: BoxDecoration(
                    color: _isEraser ? Colors.grey.shade100 : _selectedColor,
                    border: Border.all(
                      color: _isEraser ? Colors.grey : _selectedColor,
                      width: 2,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: PopupMenuButton(
                    enabled: !_isEraser,
                    onSelected: (Color color) {
                      setState(() => _selectedColor = color);
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: Colors.black,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      PopupMenuItem(
                        value: Colors.red,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      PopupMenuItem(
                        value: Colors.blue,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      PopupMenuItem(
                        value: Colors.green,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      PopupMenuItem(
                        value: Colors.purple,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.purple,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      PopupMenuItem(
                        value: Colors.orange,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                    child: SizedBox(width: 50, height: 50),
                  ),
                ),
                const SizedBox(width: 12),
                // Stroke width slider
                SizedBox(
                  width: 120,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Size: ${_strokeWidth.toStringAsFixed(1)}',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      Slider(
                        value: _strokeWidth,
                        min: 1,
                        max: 10,
                        onChanged: (value) {
                          setState(() => _strokeWidth = value);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Pen button
                FilledButton.icon(
                  onPressed: _isEraser
                      ? () => setState(() => _isEraser = false)
                      : null,
                  icon: const Icon(Icons.edit),
                  label: const Text('Pen'),
                  style: FilledButton.styleFrom(
                    backgroundColor: !_isEraser
                        ? Colors.blue
                        : Colors.grey.shade300,
                  ),
                ),
                const SizedBox(width: 8),
                // Eraser button
                FilledButton.icon(
                  onPressed: !_isEraser
                      ? () => setState(() => _isEraser = true)
                      : null,
                  icon: const Icon(Icons.cleaning_services),
                  label: const Text('Eraser'),
                  style: FilledButton.styleFrom(
                    backgroundColor: _isEraser
                        ? Colors.grey
                        : Colors.grey.shade300,
                  ),
                ),
                const SizedBox(width: 8),
                // Undo button
                IconButton(
                  onPressed: _strokes.isNotEmpty ? _undo : null,
                  icon: const Icon(Icons.undo),
                  tooltip: 'Undo',
                ),
                const SizedBox(width: 8),
                // Clear button
                IconButton(
                  onPressed: _strokes.isNotEmpty ? _clear : null,
                  icon: const Icon(Icons.delete_outline),
                  tooltip: 'Clear',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
