import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_card.dart';

class TeamPage extends StatelessWidget {
  const TeamPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.teamAndDevelopment,
          style: AppTypography.heading1Secondary,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 24),
              
              // Card - Desenvolvedores
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.developers,
                      style: AppTypography.heading1Primary,
                    ),
                    const SizedBox(height: 16),
                    
                    // Desenvolvedor 1 - Luis Fernando
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Foto
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.buttonPrimary,
                              width: 2,
                            ),
                            image: const DecorationImage(
                              image: AssetImage('assets/images/lufespi.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        
                        // Informações
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Luis Fernando Souza Pinto',
                                style: AppTypography.heading2Primary,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                l10n.luisFernandoRole,
                                style: AppTypography.textPrimary,
                                textAlign: TextAlign.justify,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Desenvolvedor 2 - Kaue Muller
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Círculo para foto
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.inputBackground,
                            border: Border.all(
                              color: AppColors.buttonPrimary,
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.person,
                            size: 40,
                            color: AppColors.textDisabled,
                          ),
                        ),
                        const SizedBox(width: 16),
                        
                        // Informações
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Kaue Müller',
                                style: AppTypography.heading2Primary,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                l10n.kaueMullerRole,
                                style: AppTypography.textPrimary,
                                textAlign: TextAlign.justify,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Card - Projeto
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.aboutTheProject,
                      style: AppTypography.heading1Primary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.projectDescription,
                      style: AppTypography.textPrimary,
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Card - Tecnologias Utilizadas
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.technologiesUsed,
                      style: AppTypography.heading1Primary,
                    ),
                    const SizedBox(height: 16),
                    
                    // Grid de tecnologias
                    Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      children: [
                        _buildTechItem('Trello', 'assets/images/trello.png'),
                        _buildTechItem('Figma', 'assets/images/figma.png'),
                        _buildTechItem('Flutter', 'assets/images/flutter-logo.png'),
                        _buildTechItem('Python', 'assets/images/python.png'),
                        _buildTechItem('Github', 'assets/images/github-logo.png'),
                        _buildTechItem('PythonAnywhere', 'assets/images/pythonanywhere.png'),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTechItem(String name, String imagePath) {
    return Column(
      children: [
        // Logo da tecnologia
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.inputBackground,
            border: Border.all(
              color: AppColors.buttonPrimary,
              width: 2,
            ),
          ),
          child: ClipOval(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        
        // Nome da tecnologia
        Text(
          name,
          style: AppTypography.textPrimary,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
