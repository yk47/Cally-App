// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import '../../core/repositories/call_list_repository.dart';
import '../widgets/sidemenu.dart';

class TestListScreen extends StatefulWidget {
  const TestListScreen({super.key});

  @override
  State<TestListScreen> createState() => _TestListScreenState();
}

class _TestListScreenState extends State<TestListScreen>
    with TickerProviderStateMixin {
  final CallListRepository _callListRepository = CallListRepository();
  Map<String, dynamic>? callData;
  bool isLoading = true;
  String? errorMessage;
  String? selectedSection; // Track which section is selected

  AnimationController? _animationController;
  Animation<double>? _scaleAnimation;
  Animation<double>? _rotationAnimation;

  // Using the list ID from the API documentation
  final String listId = '68626fb697757cb741f449b9';

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadCallData();
    // Set default selected section to the smallest one
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setSmallestSectionSelected();
    });
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _animationController!, curve: Curves.elasticOut),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 0.02).animate(
      CurvedAnimation(parent: _animationController!, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  Future<void> _loadCallData() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final data = await _callListRepository.getCallList(listId);

      if (mounted) {
        setState(() {
          callData = data;
          isLoading = false;
        });
        // Set default selected section after data is loaded
        _setSmallestSectionSelected();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = e.toString();
          isLoading = false;
        });
      }
    }
  }

  void _setSmallestSectionSelected() {
    if (callData == null) return;
    final pending = callData?['pending'] ?? 0;
    final schedule = callData?['schedule'] ?? 0;
    final done = callData?['done'] ?? 0;

    String? smallest;
    int minValue = pending;
    smallest = 'pending';
    if (schedule < minValue) {
      minValue = schedule;
      smallest = 'schedule';
    }
    if (done < minValue) {
      minValue = done;
      smallest = 'total';
    }
    setState(() {
      selectedSection = smallest;
      _animationController?.forward();
    });
  }

  void _handleChartTap(Offset localPosition) {
    final center = Offset(100, 100); // Center of 200x200 container
    final radius = 80.0;

    final distance = (localPosition - center).distance;
    if (distance > radius) return;

    // Add haptic feedback
    HapticFeedback.lightImpact();

    final angle = (localPosition - center).direction;
    var normalizedAngle = angle < 0 ? angle + 2 * math.pi : angle;
    // Adjust for startAngle = -math.pi (left)
    normalizedAngle = (normalizedAngle + math.pi) % (2 * math.pi);

    final pending = callData?['pending'] ?? 0;
    final schedule = callData?['schedule'] ?? 0;
    final done = callData?['done'] ?? 0;
    final total = pending + done + schedule;

    if (total == 0) return;

    final gapAngle = 0.12;
    final totalUsableAngle = (2 * math.pi) - (gapAngle * 3);

    final totalAngle = (done / total) * totalUsableAngle;
    final scheduleAngle = (schedule / total) * totalUsableAngle;
    final pendingAngle = (pending / total) * totalUsableAngle;

    double start = 0.0;
    String? tappedSection;

    // Blue (total/done) at left
    if (normalizedAngle >= start && normalizedAngle < start + totalAngle) {
      tappedSection = 'total';
    }
    start += totalAngle + gapAngle;

    // Purple (schedule) at bottom left
    if (tappedSection == null &&
        normalizedAngle >= start &&
        normalizedAngle < start + scheduleAngle) {
      tappedSection = 'schedule';
    }
    start += scheduleAngle + gapAngle;

    // Orange (pending) at right
    if (tappedSection == null &&
        normalizedAngle >= start &&
        normalizedAngle < start + pendingAngle) {
      tappedSection = 'pending';
    }

    setState(() {
      if (selectedSection == tappedSection) {
        selectedSection = null;
        _animationController?.reverse();
      } else if (tappedSection != null) {
        selectedSection = tappedSection;
        _animationController?.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      drawer: SideMenu(),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Builder(
                        builder:
                            (context) => IconButton(
                              icon: Icon(
                                Icons.menu,
                                size: 24,
                                color: Colors.black,
                              ),
                              onPressed:
                                  () => Scaffold.of(context).openDrawer(),
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                            ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Dashboard',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Image.asset(
                        'assets/icons/callhead.png',
                        width: 24,
                        height: 24,
                        fit: BoxFit.contain,
                        errorBuilder:
                            (context, error, stackTrace) => Icon(
                              Icons.person,
                              size: 24,
                              color: Colors.black,
                            ),
                      ),
                      SizedBox(width: 15),
                      Image.asset(
                        'assets/icons/notification.png',
                        width: 24,
                        height: 24,
                        fit: BoxFit.contain,
                        errorBuilder:
                            (context, error, stackTrace) => Icon(
                              Icons.notifications_outlined,
                              size: 24,
                              color: Colors.black,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    // Test List Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Test List',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Text(
                                      isLoading
                                          ? '--'
                                          : '${callData?['total'] ?? 0}',
                                      style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF2563EB),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'CALLS',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Color(0xFF2563EB),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child:
                                  isLoading
                                      ? SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                        ),
                                      )
                                      : Text(
                                        'S',
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Chart Container
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Error message or chart
                            Expanded(
                              child:
                                  errorMessage != null
                                      ? Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.error_outline,
                                            size: 48,
                                            color: Colors.red,
                                          ),
                                          SizedBox(height: 16),
                                          Text(
                                            'Failed to load data',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            errorMessage!,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                          SizedBox(height: 16),
                                          ElevatedButton(
                                            onPressed: _loadCallData,
                                            child: Text('Retry'),
                                          ),
                                        ],
                                      )
                                      : GestureDetector(
                                        onTapDown: (details) {
                                          _handleChartTap(
                                            details.localPosition,
                                          );
                                        },
                                        child:
                                            _animationController != null
                                                ? AnimatedBuilder(
                                                  animation:
                                                      _animationController!,
                                                  builder: (context, child) {
                                                    return Transform.scale(
                                                      scale:
                                                          selectedSection !=
                                                                      null &&
                                                                  _scaleAnimation !=
                                                                      null
                                                              ? _scaleAnimation!
                                                                  .value
                                                              : 1.0,
                                                      child: Transform.rotate(
                                                        angle:
                                                            selectedSection !=
                                                                        null &&
                                                                    _rotationAnimation !=
                                                                        null
                                                                ? _rotationAnimation!
                                                                    .value
                                                                : 0.0,
                                                        child: SizedBox(
                                                          width: 200,
                                                          height: 200,
                                                          child: CustomPaint(
                                                            painter: InteractivePieChartPainter(
                                                              pending:
                                                                  callData?['pending'] ??
                                                                  0,
                                                              done:
                                                                  callData?['done'] ??
                                                                  0,
                                                              schedule:
                                                                  callData?['schedule'] ??
                                                                  0,
                                                              selectedSection:
                                                                  selectedSection,
                                                              animationValue:
                                                                  _animationController
                                                                      ?.value ??
                                                                  0.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                )
                                                : Container(
                                                  width: 200,
                                                  height: 200,
                                                  child: CustomPaint(
                                                    painter: InteractivePieChartPainter(
                                                      pending:
                                                          callData?['pending'] ??
                                                          0,
                                                      done:
                                                          callData?['done'] ??
                                                          0,
                                                      schedule:
                                                          callData?['schedule'] ??
                                                          0,
                                                      selectedSection:
                                                          selectedSection,
                                                      animationValue: 0.0,
                                                    ),
                                                  ),
                                                ),
                                      ),
                            ),

                            const SizedBox(height: 20),

                            // Statistics Cards
                            Row(
                              children: [
                                Expanded(
                                  child: _buildStatCard(
                                    'Pending',
                                    isLoading
                                        ? '--'
                                        : '${callData?['pending'] ?? 0}',
                                    'Calls',
                                    Color(0xFFF59E0B),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: _buildStatCard(
                                    'Done',
                                    isLoading
                                        ? '--'
                                        : '${callData?['done'] ?? 0}',
                                    'Calls',
                                    Color(0xFF10B981),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: _buildStatCard(
                                    'Schedule',
                                    isLoading
                                        ? '--'
                                        : '${callData?['schedule'] ?? 0}',
                                    'Calls',
                                    Color(0xFF8B5CF6),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // Start Calling Button
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: isLoading ? null : () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2563EB),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 0,
                                  disabledBackgroundColor: Colors.grey[300],
                                ),
                                child:
                                    isLoading
                                        ? SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Colors.white,
                                                ),
                                          ),
                                        )
                                        : const Text(
                                          'Start Calling Now',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String count,
    String subtitle,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: color, width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 4),
          Row(
            children: [
              Text(
                count,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class InteractivePieChartPainter extends CustomPainter {
  final int pending;
  final int done;
  final int schedule;
  final String? selectedSection;
  final double animationValue;

  InteractivePieChartPainter({
    required this.pending,
    required this.done,
    required this.schedule,
    this.selectedSection,
    this.animationValue = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final baseRadius = size.width / 2 - 16;

    final total = pending + done + schedule;

    if (total == 0) return;

    final paint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 25.0
          ..strokeCap = StrokeCap.butt;

    final gapAngle = 0.12; // ~7.5 degrees
    final totalUsableAngle = (2 * math.pi) - (gapAngle * 3);

    final totalAngle = (done / total) * totalUsableAngle;
    final scheduleAngle = (schedule / total) * totalUsableAngle;
    final pendingAngle = (pending / total) * totalUsableAngle;

    // Start at -pi (left), so blue (total) is at left, purple (schedule) at bottom left, orange (pending) at right
    double startAngle = -math.pi;

    void drawSection(
      String sectionName,
      Color color,
      double angle,
      double currentStartAngle,
    ) {
      if (angle <= 0) return;

      final isSelected = selectedSection == sectionName;
      final radius = baseRadius;
      final strokeWidth =
          isSelected ? 44.0 * (1 + 0.15 * animationValue) : 28.0;

      paint
        ..color = color
        ..strokeWidth = strokeWidth;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        currentStartAngle,
        angle,
        false,
        paint,
      );

      if (isSelected && animationValue > 0) {
        final shadowPaint =
            Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = strokeWidth
              ..strokeCap = StrokeCap.butt
              ..color = Colors.black.withOpacity(0.10 * animationValue)
              ..maskFilter = MaskFilter.blur(
                BlurStyle.normal,
                8 * animationValue,
              );
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius + 2),
          currentStartAngle,
          angle,
          false,
          shadowPaint,
        );
      }
    }

    // Draw sections in the requested order:
    // Blue (total/done) at left, purple (schedule) at bottom left, orange (pending) at right
    if (totalAngle > 0) {
      drawSection('total', Color(0xFF2563EB), totalAngle, startAngle);
      startAngle += totalAngle + gapAngle;
    }
    if (schedule > 0) {
      drawSection('schedule', Color(0xFF8B5CF6), scheduleAngle, startAngle);
      startAngle += scheduleAngle + gapAngle;
    }
    if (pending > 0) {
      drawSection('pending', Color(0xFFF59E0B), pendingAngle, startAngle);
      // startAngle += pendingAngle + gapAngle; // not needed after last section
    }

    // --- REMOVE middle section (donut) ---
    // (Do not draw the center circle or center text)
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
