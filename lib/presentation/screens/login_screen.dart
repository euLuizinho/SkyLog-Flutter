import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/viewmodels/auth_viewmodel.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nomeController = TextEditingController();
  final _empresaController = TextEditingController();

  bool _isSignUp = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authVm = context.read<AuthViewModel>();
      if (authVm.isAuthenticated) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nomeController.dispose();
    _empresaController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final authVm = context.read<AuthViewModel>();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    bool success = false;
    if (_isSignUp) {
      final nome = _nomeController.text.trim();
      final empresa = _empresaController.text.trim();
      success = await authVm.signUp(email, password, nome, empresa);
    } else {
      success = await authVm.signIn(email, password);
    }

    if (success && mounted) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authVm = context.watch<AuthViewModel>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.sand,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(24),
            child: Card(
              elevation: 0,
              color: isDark ? AppColors.darkCard : AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(
                  color: isDark ? AppColors.darkBorder : AppColors.grayLight,
                  width: 0.5,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      Column(
                        children: [
                          Image.asset(
                            'assets/images/logo.png',
                            height: 70,
                            errorBuilder: (context, error, stackTrace) => const Icon(
                              Icons.radar_rounded,
                              color: AppColors.coral,
                              size: 48,
                            ),
                          ),
                          const SizedBox(height: 12),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Sky',
                                  style: TextStyle(
                                    color: isDark ? Colors.white : AppColors.charcoal,
                                    fontSize: 32,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -1.0,
                                    fontFamily: 'Outfit',
                                  ),
                                ),
                                TextSpan(
                                  text: 'Log',
                                  style: const TextStyle(
                                    color: AppColors.coral,
                                    fontSize: 32,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -1.0,
                                    fontFamily: 'Outfit',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _isSignUp ? 'Criar Nova Conta' : 'Gestor de Frota',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: isDark ? AppColors.darkText : AppColors.charcoal,
                            ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _isSignUp
                            ? 'Cadastre-se para monitorar a frota via satélite.'
                            : 'Monitore riscos naturais em tempo real.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 28),

                      if (authVm.errorMessage != null)
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.riskCritical.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppColors.riskCritical.withOpacity(0.3),
                              width: 0.5,
                            ),
                          ),
                          child: Text(
                            authVm.errorMessage!,
                            style: const TextStyle(
                              color: AppColors.riskCritical,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                      if (_isSignUp) ...[
                        TextFormField(
                          controller: _nomeController,
                          keyboardType: TextInputType.name,
                          decoration: const InputDecoration(
                            labelText: 'Nome Completo',
                            prefixIcon: Icon(Icons.person_outline_rounded, size: 18),
                          ),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'Informe seu nome.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _empresaController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            labelText: 'Empresa Logística',
                            prefixIcon: Icon(Icons.business_rounded, size: 18),
                          ),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'Informe o nome da empresa.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                      ],

                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'E-mail do Gestor',
                          prefixIcon: Icon(Icons.email_outlined, size: 18),
                        ),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Informe o e-mail.';
                          }
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(val.trim())) {
                            return 'Informe um e-mail válido.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Senha de Acesso',
                          prefixIcon: Icon(Icons.lock_outline_rounded, size: 18),
                        ),
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Informe a senha.';
                          }
                          if (val.length < 6) {
                            return 'A senha precisa ter no mínimo 6 dígitos.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 28),

                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: authVm.isLoading ? null : _submit,
                          child: authVm.isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(_isSignUp ? 'CADASTRAR CONTA' : 'ACESSAR PAINEL'),
                        ),
                      ),
                      const SizedBox(height: 16),

                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isSignUp = !_isSignUp;
                            authVm.reloadProfile();
                          });
                        },
                        child: Text(
                          _isSignUp
                              ? 'Já possui conta? Faça login'
                              : 'Não tem conta? Cadastre-se',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
