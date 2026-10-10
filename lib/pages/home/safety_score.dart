import 'package:flutter/material.dart';
import 'package:safeyatra/widgets/graph.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SafetyScore extends StatefulWidget {
  final double score;

  const SafetyScore({
    super.key,
    required this.score,
  });

  @override
  State<SafetyScore> createState() => _SafetyScoreState();
}

class _SafetyScoreState extends State<SafetyScore> {
  String? status;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getSafetyLabel();
  }

  @override
  void didUpdateWidget(covariant SafetyScore oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.score != widget.score) {
      getSafetyLabel();
    }
  }

  Future<void> getSafetyLabel() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final safetyLabel = prefs.getString('safety_label');

      if (!mounted) return;

      setState(() {
        status = safetyLabel;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        status = null;
        isLoading = false;
      });

      debugPrint('Error loading safety label: $e');
    }
  }

  Color getStatusColor() {
    switch (status) {
      case 'High':
        return Colors.red;
      case 'Moderate':
        return Colors.orange;
      case 'Low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String getSafetyLevel() {
    switch (status) {
      case 'High':
        return 'Unsafe';
      case 'Moderate':
        return 'Moderate';
      case 'Low':
        return 'Safe';
      default:
        return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = getStatusColor();
    final safetyLevel = getSafetyLevel();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Header
            Row(
              children: [
                Card(
                  shape: const CircleBorder(),
                  child: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Icon(Icons.auto_awesome_outlined),
                  ),
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'AI Safety Score',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: getSafetyLabel,
                  tooltip: 'Refresh safety label',
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Safety gauge
            Center(
              child: RiskGauge(
                riskScore: widget.score,
              ),
            ),

            const SizedBox(height: 10),

            // Main safety status
            if (isLoading)
              const CircularProgressIndicator()
            else
              Text(
                safetyLevel,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: statusColor,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),

            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 20),

            // Safety level and legend
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        'Safety Level',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        isLoading ? 'Loading...' : safetyLevel,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  height: 75,
                  width: 1,
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  color: Colors.white24,
                ),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLegendItem(
                        color: Colors.green,
                        label: 'Safe',
                      ),
                      const SizedBox(height: 8),
                      _buildLegendItem(
                        color: Colors.orange,
                        label: 'Moderate',
                      ),
                      const SizedBox(height: 8),
                      _buildLegendItem(
                        color: Colors.red,
                        label: 'Unsafe',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem({
    required Color color,
    required String label,
  }) {
    return Row(
      children: [
        Icon(
          Icons.circle,
          color: color,
          size: 10,
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(label),
        ),
      ],
    );
  }
}