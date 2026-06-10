import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class MetricCard extends StatelessWidget {
  final String titulo;
  final String valor;
  final IconData icone;

  const MetricCard({
    super.key,
    required this.titulo,
    required this.valor,
    required this.icone,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: isDark ? AppColors.darkBorder : AppColors.grayLight,
          width: 0.5,
        ),
      ),
      color: isDark ? AppColors.darkCard : AppColors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icone,
                  color: AppColors.gray,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    titulo.toUpperCase(),
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontSize: 9,
                          letterSpacing: 0.6,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              valor,
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: AppColors.coral,
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
