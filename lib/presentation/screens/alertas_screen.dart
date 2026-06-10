import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/viewmodels/auth_viewmodel.dart';
import '../../domain/viewmodels/alertas_viewmodel.dart';
import '../components/alert_card.dart';

class AlertasScreen extends StatefulWidget {
  const AlertasScreen({super.key});

  @override
  State<AlertasScreen> createState() => _AlertasScreenState();
}

class _AlertasScreenState extends State<AlertasScreen> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authVm = context.read<AuthViewModel>();
      final limiar = authVm.userProfile?.limiarAlerta ?? 'BAIXO';
      context.read<AlertasViewModel>().init(limiar);
    });
  }

  Widget _buildFilterChip(String value, AlertasViewModel alertasVm, BuildContext context) {
    final isSelected = alertasVm.filtroAtivo.toUpperCase() == value.toUpperCase();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        showCheckmark: false,
        label: Text(value),
        selected: isSelected,
        onSelected: (selected) {
          if (selected) {
            alertasVm.setFiltro(value);
          }
        },
        selectedColor: AppColors.coral,
        backgroundColor: isDark ? AppColors.darkCard : AppColors.white,
        side: BorderSide(
          color: isSelected 
              ? AppColors.coral 
              : (isDark ? AppColors.darkBorder : AppColors.grayLight),
          width: 0.5,
        ),
        labelStyle: TextStyle(
          color: isSelected 
              ? Colors.white 
              : (isDark ? AppColors.darkText : AppColors.charcoal),
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          fontSize: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authVm = context.watch<AuthViewModel>();
    final alertasVm = context.watch<AlertasViewModel>();
    final limiar = authVm.userProfile?.limiarAlerta ?? 'BAIXO';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Painel de Alertas'),
        scrolledUnderElevation: 0,
      ),
      body: Column(
        children: [

          Container(
            height: 52,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildFilterChip('TODOS', alertasVm, context),
                _buildFilterChip('CRÍTICO', alertasVm, context),
                _buildFilterChip('ALTO', alertasVm, context),
                _buildFilterChip('MÉDIO', alertasVm, context),
                _buildFilterChip('BAIXO', alertasVm, context),
              ],
            ),
          ),

          const SizedBox(height: 4),

          Expanded(
            child: Builder(
              builder: (context) {
                if (alertasVm.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.coral),
                  );
                }

                if (alertasVm.errorMessage != null) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline_rounded,
                            color: AppColors.riskCritical,
                            size: 48,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            alertasVm.errorMessage!,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Verifique sua conexão e tente novamente.',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () => alertasVm.refresh(limiar),
                            child: const Text('TENTAR NOVAMENTE'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (alertasVm.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: () => alertasVm.refresh(limiar),
                    color: AppColors.coral,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.5,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off_rounded,
                              color: AppColors.gray,
                              size: 48,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Nenhum alerta encontrado',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tente alterar o filtro ou limiar de alerta.',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => alertasVm.refresh(limiar),
                  color: AppColors.coral,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    itemCount: alertasVm.alertasFiltrados.length,
                    itemBuilder: (context, index) {
                      final alerta = alertasVm.alertasFiltrados[index];
                      return AlertCard(
                        alerta: alerta,
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            '/alerta',
                            arguments: alerta.id,
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
