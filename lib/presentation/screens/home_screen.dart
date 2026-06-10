import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/viewmodels/auth_viewmodel.dart';
import '../../domain/viewmodels/home_viewmodel.dart';
import '../components/alert_card.dart';
import '../components/metric_card.dart';
import '../components/section_header.dart';
import 'main_navigation_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  double _getHueForRisk(String risk) {
    switch (risk.toUpperCase()) {
      case 'CRÍTICO':
        return BitmapDescriptor.hueRed;
      case 'ALTO':
        return BitmapDescriptor.hueOrange;
      case 'MÉDIO':
        return BitmapDescriptor.hueYellow;
      case 'BAIXO':
      default:
        return BitmapDescriptor.hueGreen;
    }
  }

  Set<Marker> _buildMarkers(List<dynamic> alertas, HomeViewModel homeVm) {
    return alertas.map((alerta) {
      return Marker(
        markerId: MarkerId(alerta.id),
        position: LatLng(alerta.latitude, alerta.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(_getHueForRisk(alerta.classificacao)),
        infoWindow: InfoWindow(
          title: alerta.tipo.toUpperCase(),
          snippet: alerta.localizacao,
        ),
        onTap: () {
          homeVm.selecionarAlerta(alerta);
        },
      );
    }).toSet();
  }

  @override
  Widget build(BuildContext context) {
    final authVm = context.watch<AuthViewModel>();
    final homeVm = context.watch<HomeViewModel>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (homeVm.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppColors.coral),
        ),
      );
    }

    final alerts = homeVm.todosAlertas;
    final markers = _buildMarkers(alerts, homeVm);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 16,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 38,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.radar_rounded,
                color: AppColors.coral,
                size: 24,
              ),
            ),
            const SizedBox(width: 8),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Sky',
                    style: TextStyle(
                      color: isDark ? Colors.white : AppColors.charcoal,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.8,
                      fontFamily: 'Outfit',
                    ),
                  ),
                  TextSpan(
                    text: 'Log',
                    style: const TextStyle(
                      color: AppColors.coral,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.8,
                      fontFamily: 'Outfit',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              final novoTema = isDark ? 'claro' : 'escuro';
              authVm.updateTema(novoTema);
            },
            icon: Icon(
              isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              color: isDark ? Colors.amber : AppColors.charcoal,
            ),
            tooltip: 'Alternar Tema',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [

          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(-14.235, -51.925),
                    zoom: 4.0,
                  ),
                  markers: markers,
                  onMapCreated: (controller) {

                  },
                  onTap: (_) {

                    homeVm.limparAlertaSelecionado();
                  },
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  mapType: MapType.normal,
                ),

                if (homeVm.alertaSelecionado != null)
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkCard : AppColors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isDark ? AppColors.darkBorder : AppColors.grayLight,
                          width: 0.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  homeVm.alertaSelecionado!.tipo.toUpperCase(),
                                  style: TextStyle(
                                    color: AppColors.coral,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.6,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  homeVm.alertaSelecionado!.localizacao,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Risco: ${homeVm.alertaSelecionado!.classificacao} · Fonte: ${homeVm.alertaSelecionado!.fonte}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.gray,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              final selected = homeVm.alertaSelecionado!;
                              homeVm.limparAlertaSelecionado();
                              Navigator.of(context).pushNamed(
                                '/alerta',
                                arguments: selected.id,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              minimumSize: Size.zero,
                            ),
                            child: const Text('DETALHES', style: TextStyle(fontSize: 10)),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Row(
                    children: [
                      Expanded(
                        child: MetricCard(
                          titulo: 'Alertas Ativos',
                          valor: homeVm.totalAlertasAtivos.toString(),
                          icone: Icons.warning_amber_rounded,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: MetricCard(
                          titulo: 'Críticos',
                          valor: homeVm.alertasCriticos.toString(),
                          icone: Icons.gpp_bad_outlined,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: MetricCard(
                          titulo: 'Rotas Seguras',
                          valor: homeVm.rotasSeguras.toString(),
                          icone: Icons.local_shipping_outlined,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  SectionHeader(
                    titulo: 'Alertas Recentes',
                    acaoLabel: 'Ver todos',
                    onAcao: () {

                      final parentState = context.findAncestorStateOfType<State<MainNavigationScreen>>();
                      if (parentState != null) {
                        Navigator.of(context).pushReplacementNamed('/alertas');
                      }
                    },
                  ),
                  const SizedBox(height: 12),

                  if (homeVm.alertasRecentes.isEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle_outline_rounded,
                            color: AppColors.riskLow,
                            size: 44,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Nenhum alerta ativo no momento.',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Todas as rotas estão operando normalmente.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: homeVm.alertasRecentes.length,
                      itemBuilder: (context, index) {
                        final alerta = homeVm.alertasRecentes[index];
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
