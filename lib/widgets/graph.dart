import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class RiskGauge extends StatelessWidget {
  final double riskScore;

  const RiskGauge({
    super.key,
    required this.riskScore,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      // width: double.infinity,
      child: SfRadialGauge(
        axes: [
          RadialAxis(
            minimum: 0,
            maximum: 100,

            ranges: [
              GaugeRange(
                startValue: 0,
                endValue: 49,
                color: Colors.red,
              ),
              GaugeRange(
                startValue: 50,
                endValue: 79,
                color: Colors.orange,
              ),
              GaugeRange(
                startValue: 80,
                endValue: 100,
                color: Colors.green,
              ),
            ],

            pointers: [
              NeedlePointer(
                value: riskScore,
                enableAnimation: true,
              ),
            ],

            annotations: [
              GaugeAnnotation(
                widget: Text(
                  '${riskScore.toInt()}%',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                angle: 90,
                positionFactor: 0.5,
              ),
            ],
          ),
        ],
      ),
    );
  }
}