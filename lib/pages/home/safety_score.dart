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
  @override
  void initState() {
    super.initState();
    getSafetyLabel();
  }
  Future<void> getSafetyLabel() async {
    final prefs = await SharedPreferences.getInstance();
    final safetyLabel = prefs.getString("safety_label");
    if (!mounted) return;
    setState(() {
      status = safetyLabel;
    });
  }
  Color getStatusColor() {
    switch (status) {
      case "High":return Colors.red;
      case "Moderate":return Colors.orange;
      case "Low":return Colors.green;
      default:return Colors.grey;
    }
  }
  String getSafetyLevel() {
    switch (status) {
      case "High":return "Unsafe";
      case "Moderate":return "Moderate";
      case "Low":return "Safe";
      default:return "";
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
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Card(
                  shape: const CircleBorder(),
                  child: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Icon(
                      Icons.auto_awesome_outlined,
                    ),
                  ),
                ),
                const Text(
                  "AI Safety Score",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Center(
              child: RiskGauge(
                riskScore: widget.score,
              ),
            ),
            const SizedBox(height: 10),
            if (status != null && safetyLevel.isNotEmpty)
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        "Safety Level",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 6),
                      if (status != null && safetyLevel.isNotEmpty)
                        Text(
                          safetyLevel,
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
                  height: 65,
                  width: 1,
                  color: Colors.white24,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Row(
                        children: [
                          SizedBox(width:20),
                          Icon(
                            Icons.circle,
                            color: Colors.green,
                            size: 10,
                          ),
                          SizedBox(width: 6),
                          Text("Safe"),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          SizedBox(width:20),
                          Icon(
                            Icons.circle,
                            color: Colors.orange,
                            size: 10,
                          ),
                          SizedBox(width: 6),
                          Text("Moderate"),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          SizedBox(width:20),
                          Icon(
                            Icons.circle,
                            color: Colors.red,
                            size: 10,
                          ),
                          SizedBox(width: 6),
                          Text("Unsafe"),
                        ],
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
}