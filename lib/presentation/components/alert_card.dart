import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/alerta_model.dart';
import 'risk_badge.dart';

class AlertCard extends StatelessWidget {
  final AlertaModel alerta;
  final VoidCallback onTap;

  const AlertCard({
    super.key,
    required this.alerta,
    required this.onTap,
  });

  Color _getRiskColor() {
    switch (alerta.classificacao.toUpperCase()) {
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

  IconData _getIcon() {
    switch (alerta.tipo.toLowerCase()) {
      case 'queimada':
        return Icons.local_fire_department_rounded;
      case 'enchente':
        return Icons.water_drop_rounded;
      case 'deslizamento':
        return Icons.landslide_rounded;
      case 'tempestade':
        return Icons.thunderstorm_rounded;
      default:
        return Icons.warning_amber_rounded;
    }
  }

  String _formatHorario(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inMinutes < 60 && difference.inMinutes >= 0) {
      return 'Há ${difference.inMinutes} min';
    } else if (difference.inHours < 24 && difference.inHours >= 0) {
      return 'Há ${difference.inHours} h';
    } else {
      final day = dateTime.day.toString().padLeft(2, '0');
      final month = dateTime.month.toString().padLeft(2, '0');
      final hour = dateTime.hour.toString().padLeft(2, '0');
      final minute = dateTime.minute.toString().padLeft(2, '0');
      return '$day/$month às $hour:$minute';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final riskColor = _getRiskColor();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: isDark ? AppColors.darkBorder : AppColors.grayLight,
          width: 0.5,
        ),
      ),
      color: isDark ? AppColors.darkCard : AppColors.white,
      child: InkWell(
        onTap: onTap,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              Container(
                width: 6,
                color: riskColor,
              ),
              const SizedBox(width: 14),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _getIcon(),
                            color: riskColor,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              alerta.tipo.toUpperCase(),
                              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                    color: isDark ? AppColors.darkText : AppColors.charcoal,
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                          ),
                          RiskBadge(classificacao: alerta.classificacao),
                          const SizedBox(width: 12),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        alerta.localizacao,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 13,
                            color: AppColors.gray,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatHorario(alerta.horario),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            Icons.source_rounded,
                            size: 13,
                            color: AppColors.gray,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            alerta.fonte,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const Spacer(),
                          if (alerta.lido)
                            Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.check_circle_outline_rounded,
                                    size: 14,
                                    color: AppColors.gray,
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    'Lido',
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
