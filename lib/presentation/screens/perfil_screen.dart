import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/viewmodels/auth_viewmodel.dart';
import '../../domain/viewmodels/home_viewmodel.dart';
import '../../domain/viewmodels/alertas_viewmodel.dart';
import '../../domain/viewmodels/perfil_viewmodel.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authVm = context.watch<AuthViewModel>();
    final perfilVm = context.watch<PerfilViewModel>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final user = authVm.userProfile;
    final String nome = user?.nome ?? 'Gestor de Frota';
    final String empresa = user?.empresa ?? 'Logística Integrada';
    final String limiar = user?.limiarAlerta ?? 'BAIXO';
    final String tema = user?.tema ?? 'claro';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações do Painel'),
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 12),

            CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.coral.withOpacity(0.1),
              child: const Icon(
                Icons.person_rounded,
                color: AppColors.coral,
                size: 44,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              nome,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              empresa,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 32),

            Card(
              elevation: 0,
              color: isDark ? AppColors.darkCard : AppColors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PREFERÊNCIAS',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                          ),
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        const Icon(Icons.tune_rounded, color: AppColors.gray),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Limiar de Alerta',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ),
                        SizedBox(
                          width: 120,
                          height: 42,
                          child: DropdownButtonFormField<String>(
                            initialValue: limiar,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                              fillColor: isDark ? AppColors.darkBg : AppColors.sand,
                            ),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: isDark ? AppColors.darkText : AppColors.charcoal,
                            ),
                            items: ['CRÍTICO', 'ALTO', 'MÉDIO', 'BAIXO'].map((val) {
                              return DropdownMenuItem<String>(
                                value: val,
                                child: Text(val),
                              );
                            }).toList(),
                            onChanged: (newVal) async {
                              if (newVal != null) {

                                await authVm.updateLimiarAlerta(newVal);

                                await perfilVm.updateLimiarAlerta(authVm.currentUser!.uid, newVal);

                                if (context.mounted) {
                                  context.read<HomeViewModel>().init(newVal);
                                  context.read<AlertasViewModel>().init(newVal);
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24, thickness: 0.5),

                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      secondary: Icon(
                        isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                        color: AppColors.gray,
                      ),
                      title: const Text(
                        'Modo Escuro',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      value: tema == 'escuro',
                      activeThumbColor: AppColors.coral,
                      onChanged: (val) async {
                        final novoTema = val ? 'escuro' : 'claro';
                        await authVm.updateTema(novoTema);
                        await perfilVm.updateTema(authVm.currentUser!.uid, novoTema);
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton(
                onPressed: () async {
                  await perfilVm.signOut();

                  await authVm.signOut();
                  if (context.mounted) {
                    Navigator.of(context).pushReplacementNamed('/');
                  }
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.riskCritical,
                  side: const BorderSide(color: AppColors.riskCritical, width: 1.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.logout_rounded, size: 18),
                    SizedBox(width: 8),
                    Text('SAIR DO SISTEMA'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
