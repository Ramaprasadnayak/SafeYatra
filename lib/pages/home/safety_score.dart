import 'package:flutter/material.dart';
import 'package:safeyatra/widgets/graph.dart';

class SafetyScore extends StatefulWidget {
  final double score;
  const SafetyScore({super.key, required this.score});

  @override
  State<SafetyScore> createState() => _SafetyScoreState();
}

class _SafetyScoreState extends State<SafetyScore> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            Row(
              children: [
                Card(
                  shape: const CircleBorder(),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Icon(Icons.auto_awesome_outlined),
                  ),
                ),
                Text("AI Safety Score"),
              ],
            ),
            Row(children: [RiskGauge(riskScore: widget.score)]),
            if (widget.score < 50)
              Text(
                "Unsafe",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              )
            else if (widget.score < 80)
              Text(
                "Moderately Safe",
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              )
            else
              Text(
                "Safe",
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            SizedBox(height: 20),
            const Divider(),
            SizedBox(height: 20),
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
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(fontSize: 17),
                        ),
                        if (widget.score < 50)
                          Text(
                            "Unsafe",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        else if (widget.score < 80)
                          Text(
                            "Moderate",
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        else
                          Text(
                            "Safe",
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 10),
                    // OutlinedButton(onPressed: () {}, child: Text("View Details")),
                  ],
                ),
                const VerticalDivider(
                  color: Colors.white24,
                  thickness: 1,
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.circle, color: Colors.green, size: 10),
                        Text(" 80 - 100  Safe"),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.circle, color: Colors.orange, size: 10),
                        Text(" 50 - 79  Moderate"),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.circle, color: Colors.red, size: 10),
                        Text(" 0 - 49  Unsafe"),
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
