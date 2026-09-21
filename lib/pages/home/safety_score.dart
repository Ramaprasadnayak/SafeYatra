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
    if (status == "High") {
      return Colors.red;
    } else if (status == "Moderate") {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }
  String getSafetyLevel() {
    if (status == "High") {
      return "Unsafe";
    } else if (status == "Moderate") {
      return "Moderate";
    } else {
      return "Safe";
    }
  }
  @override
  Widget build(BuildContext context) {
    final statusColor = getStatusColor();
    final safetyLevel = getSafetyLevel();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            Row(
              children: [
                Card(
                  shape: const CircleBorder(),
                  child: const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Icon(Icons.auto_awesome_outlined),
                  ),
                ),
                const SizedBox(width: 10),
                const Text("AI Safety Score"),
              ],
            ),
            Row(
              children: [
                RiskGauge(
                  riskScore: widget.score,
                ),
              ],
            ),
            Text(
              status ?? "Prediction in progress...",
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Safety Level: ",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontSize: 17),
                        ),
                        Text(
                          safetyLevel,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),
                  ],
                ),

                const VerticalDivider(
                  color: Colors.white24,
                  thickness: 1,
                  width: 20,
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Row(
                      children: [
                        Icon(
                          Icons.circle,
                          color: Colors.green,
                          size: 10,
                        ),
                        SizedBox(width: 5),
                        Text("Safe"),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.circle,
                          color: Colors.orange,
                          size: 10,
                        ),
                        SizedBox(width: 5),
                        Text("Moderate"),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.circle,
                          color: Colors.red,
                          size: 10,
                        ),
                        SizedBox(width: 5),
                        Text("Unsafe"),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}