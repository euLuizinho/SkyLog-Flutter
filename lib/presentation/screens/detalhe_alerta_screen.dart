import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/alerta_model.dart';
import '../../domain/viewmodels/alertas_viewmodel.dart';
import '../components/risk_badge.dart';

class DetalheAlertaScreen extends StatelessWidget {
  final String alertaId;

  const DetalheAlertaScreen({
    super.key,
    required this.alertaId,
  });

  Color _getRiskColor(String classification) {
    switch (classification.toUpperCase()) {
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

  String _getDynamicImpact(String tipo, int severidade) {
    switch (tipo.toLowerCase()) {
      case 'queimada':
        return 'Visibilidade reduzida devido à fumaça densa na pista. Risco de focos de incêndio nas faixas laterais. Recomenda-se velocidade reduzida e faróis acesos.';
      case 'enchente':
        return 'Alagamento parcial ou total da rodovia. Elevado risco de aquaplanagem e danos mecânicos na frota. Rotas alternativas devem ser acionadas imediatamente.';
      case 'deslizamento':
        return 'Queda de barreiras na pista com obstrução total ou parcial do fluxo de veículos. Tráfego interrompido para remoção dos destroços sem previsão de liberação.';
      case 'tempestade':
        return 'Chuvas torrenciais combinadas com ventos de alta velocidade. Risco iminente de queda de árvores, descargas elétricas e colisão. Aconselha-se parada em posto seguro.';
      default:
        return 'Impacto logístico sob avaliação operacional do painel central. Redobre os cuidados de segurança na área delimitada.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final alertasVm = context.read<AlertasViewModel>();

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('alertas').doc(alertaId).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: AppColors.coral),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data == null || !snapshot.data!.exists) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(
              child: Text('Alerta não encontrado ou já resolvido.'),
            ),
          );
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;
        final alerta = AlertaModel.fromFirestore(data, snapshot.data!.id);
        final riskColor = _getRiskColor(alerta.classificacao);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Detalhes do Evento'),
            scrolledUnderElevation: 0,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.radar_rounded,
                          color: riskColor,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          alerta.tipo.toUpperCase(),
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                      ],
                    ),
                    RiskBadge(
                      classificacao: alerta.classificacao,
                      isLarge: true,
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                Card(
                  elevation: 0,
                  color: isDark ? AppColors.darkCard : AppColors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        _buildDetailItem(
                          context,
                          icone: Icons.location_on_rounded,
                          label: 'Localização',
                          valor: alerta.localizacao,
                        ),
                        const Divider(height: 24, thickness: 0.5),

                        _buildDetailItem(
                          context,
                          icone: Icons.access_time_filled_rounded,
                          label: 'Horário do Alerta',
                          valor: '${alerta.horario.day.toString().padLeft(2, '0')}/${alerta.horario.month.toString().padLeft(2, '0')}/${alerta.horario.year} às ${alerta.horario.hour.toString().padLeft(2, '0')}:${alerta.horario.minute.toString().padLeft(2, '0')}',
                        ),
                        const Divider(height: 24, thickness: 0.5),

                        _buildDetailItem(
                          context,
                          icone: Icons.analytics_rounded,
                          label: 'Nível de Severidade',
                          valor: '${alerta.severidade} / 10',
                          valorColor: riskColor,
                        ),
                        const Divider(height: 24, thickness: 0.5),

                        _buildDetailItem(
                          context,
                          icone: Icons.source_rounded,
                          label: 'Fonte Emissora',
                          valor: alerta.fonte,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                Card(
                  elevation: 0,
                  color: isDark ? AppColors.darkCard : AppColors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.error_outline_rounded,
                              color: AppColors.coral,
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'IMPACTO ESTIMADO NAS ROTAS',
                              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                    color: AppColors.coral,
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _getDynamicImpact(alerta.tipo, alerta.severidade),
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontSize: 13,
                                height: 1.5,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: alerta.lido
                      ? OutlinedButton(
                          onPressed: null,
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: isDark ? AppColors.darkBorder : AppColors.grayLight,
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.check_circle_rounded,
                                color: AppColors.gray,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'LIDO ✓',
                                style: TextStyle(
                                  color: AppColors.gray,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ElevatedButton(
                          onPressed: () {
                            alertasVm.marcarComoLido(alerta.id);
                          },
                          child: const Text('MARCAR COMO LIDO'),
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailItem(
    BuildContext context, {
    required IconData icone,
    required String label,
    required String valor,
    Color? valorColor,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icone, color: AppColors.gray, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label.toUpperCase(),
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontSize: 9,
                      letterSpacing: 0.6,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                valor,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: valorColor ?? (isDark ? AppColors.darkText : AppColors.charcoal),
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
