import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class RiskBadge extends StatelessWidget {
  final String classificacao;
  final bool isLarge;

  const RiskBadge({
    super.key,
    required this.classificacao,
    this.isLarge = false,
  });

  Color _getColor() {
    switch (classificacao.toUpperCase()) {
      case 'CRÍTICO':
        return AppColors.riskCritical;
      case 'ALTO':
        return AppColors.riskHigh;
      case 'MÉDIO':
        return AppColors.riskMedium;
      case 'BAIXO':
      default:
        return AppColors.riskLow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor();
    final String label = classificacao.toUpperCase();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isLarge ? 12 : 8,
        vertical: isLarge ? 6 : 4,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.24), width: 0.5),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: isLarge ? 11 : 9,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
