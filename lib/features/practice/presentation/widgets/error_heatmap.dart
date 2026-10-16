import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

const List<String> _rowLabels = ['Pitch', 'Rhythm', 'Tone', 'Dyn.'];

const List<List<double>> _heat = [
  [0.1, 0.3, 0.7, 0.2, 0.9, 0.4, 0.1, 0.5],
  [0.2, 0.1, 0.4, 0.8, 0.3, 0.2, 0.6, 0.1],
  [0.5, 0.6, 0.2, 0.3, 0.7, 0.9, 0.2, 0.3],
  [0.1, 0.2, 0.3, 0.1, 0.4, 0.2, 0.8, 0.6],
];

/// Port of the "Error heatmap · note × dimension" grid in
/// `src/routes/practice.tsx`: each cell interpolates between the card color
/// and clay by its error value, same as the CSS `color-mix()` there.
class ErrorHeatmap extends StatelessWidget {
  const ErrorHeatmap({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var row = 0; row < _heat.length; row++) ...[
          if (row != 0) const SizedBox(height: 6),
          Row(
            children: [
              SizedBox(
                width: 64,
                child: Text(
                  _rowLabels[row],
                  style: const TextStyle(fontSize: 11, color: AppColors.mutedForeground),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Row(
                  children: [
                    for (var col = 0; col < _heat[row].length; col++) ...[
                      if (col != 0) const SizedBox(width: 6),
                      Expanded(
                        child: Container(
                          height: 28,
                          decoration: BoxDecoration(
                            color: Color.lerp(AppColors.card, AppColors.clay, _heat[row][col]),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
