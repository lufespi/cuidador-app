import 'package:flutter/material.dart';
import '../../core/network/token_storage.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_logo.dart';
import '../../data/services/auth_service.dart';
import '../home/home_page.dart';
import 'login/login_page.dart';
import 'package:provider/provider.dart';
import '../../core/theme/theme_provider.dart';

/// Tela de splash que verifica se o usuário já está logado
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    // Aguarda um pouco para mostrar o splash
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final tokenStorage = TokenStorage();
    final isAuthenticated = await tokenStorage.isAuthenticated();

    if (isAuthenticated) {
      // Usuário já está logado, tenta carregar perfil
      try {
        final authService = AuthService();
        final user = await authService.getProfile();

        if (!mounted) return;

        // Carrega configurações do usuário
        Provider.of<ThemeProvider>(context, listen: false)
            .setCurrentUser(user.email);

        // Navega para home
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      } catch (e) {
        // Se falhar ao carregar perfil, limpa tokens e vai para login
        await tokenStorage.clearTokens();
        
        if (!mounted) return;
        
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
      }
    } else {
      // Usuário não está logado, vai para tela de login
      if (!mounted) return;
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF1E1E1E)
          : AppColors.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            const AppLogo(),
            const SizedBox(height: 24),
            
            // Loading indicator
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).brightness == Brightness.dark
                    ? AppColors.buttonPrimary
                    : AppColors.buttonPrimary,
              ),
            ),
            const SizedBox(height: 16),
            
            // Texto
            Text(
              'Carregando...',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white70
                    : AppColors.textDisabled,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
