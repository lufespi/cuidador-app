import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_button.dart';
import '../../l10n/app_localizations.dart';
import 'dor_provider.dart';
import 'body_region_mapper.dart';
import 'regioes/head_page.dart';
import 'regioes/torso_page.dart';
import 'regioes/left_arm_page.dart';
import 'regioes/right_arm_page.dart';
import 'regioes/left_hand_page.dart';
import 'regioes/right_hand_page.dart';
import 'regioes/left_leg_page.dart';
import 'regioes/right_leg_page.dart';
import 'regioes/left_foot_page.dart';
import 'regioes/right_foot_page.dart';

class IndicarLocalPage extends StatefulWidget {
  const IndicarLocalPage({super.key});

  @override
  State<IndicarLocalPage> createState() => _IndicarLocalPageState();
}

class _IndicarLocalPageState extends State<IndicarLocalPage> {
  // Dimensões de referência do container onde as coordenadas foram coletadas
  static const double _refWidth = 320.00;
  static const double _refHeight = 676.80;

  // Conjunto para armazenar os grupos que tiveram pontos selecionados
  final Set<String> _gruposSelecionados = {};

  @override
  void initState() {
    super.initState();
    // Sincroniza com o Provider ao iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _sincronizarComProvider();
    });
  }

  void _sincronizarComProvider() {
    final dorProvider = Provider.of<DorProvider>(context, listen: false);
    final regioesSelecionadas = dorProvider.regioesSelecionadas;
    
    setState(() {
      _gruposSelecionados.clear();
      _gruposSelecionados.addAll(regioesSelecionadas.keys);
    });
  }

  // Função para navegar para a página de detalhe do grupo
  void _navegarParaGrupo(String grupo) async {
    Widget? page;
    
    switch (grupo) {
      case 'cabeça':
        page = const HeadPage();
        break;
      case 'torso':
        page = const TorsoPage();
        break;
      case 'braço_esquerdo':
        // Imagem está de frente, então esquerdo da imagem = direito do usuário
        page = const RightArmPage();
        break;
      case 'braço_direito':
        // Imagem está de frente, então direito da imagem = esquerdo do usuário
        page = const LeftArmPage();
        break;
      case 'mao_esquerda':
        page = const LeftHandPage();
        break;
      case 'mao_direita':
        page = const RightHandPage();
        break;
      case 'perna_esquerda':
        // Imagem está de frente, então esquerdo da imagem = direito do usuário
        page = const RightLegPage();
        break;
      case 'perna_direita':
        // Imagem está de frente, então direito da imagem = esquerdo do usuário
        page = const LeftLegPage();
        break;
      case 'pe_esquerdo':
        // Imagem está de frente, então esquerdo da imagem = direito do usuário
        page = const RightFootPage();
        break;
      case 'pe_direito':
        // Imagem está de frente, então direito da imagem = esquerdo do usuário
        page = const LeftFootPage();
        break;
    }
    
    if (page != null && mounted) {
      final pontosSelecionados = await Navigator.push<List<String>>(
        context,
        MaterialPageRoute(builder: (context) => page!),
      );

      // Processa os pontos selecionados retornados
      if (pontosSelecionados != null && mounted) {
        final dorProvider = Provider.of<DorProvider>(context, listen: false);
        
        if (pontosSelecionados.isNotEmpty) {
          // Converte pontos para descrições legíveis
          final nomeRegiao = BodyRegionMapper.getNomeRegiao(grupo);
          final descricoes = pontosSelecionados.map((ponto) {
            return '$nomeRegiao: ${BodyRegionMapper.getNomePontoDetalhe(nomeRegiao, ponto)}';
          }).toList();
          
          // Salva no Provider primeiro
          dorProvider.adicionarRegiao(grupo, pontosSelecionados, descricoes);
          
          // Depois atualiza estado local
          setState(() {
            _gruposSelecionados.add(grupo);
          });
          
          debugPrint('Pontos selecionados no grupo $grupo: $pontosSelecionados');
          debugPrint('Descrições: $descricoes');
        } else {
          // Se não houver pontos selecionados, remove o grupo
          dorProvider.removerRegiao(grupo);
          
          setState(() {
            _gruposSelecionados.remove(grupo);
          });
        }
      }
    }
  }

  // Pontos fixos organizados por GRUPOS clicáveis
  // Cada grupo poderá expandir para uma visualização mais detalhada no futuro
  final List<Map<String, dynamic>> _pontosFixes = [
    // === GRUPO CABEÇA (#1-3) ===
    {'id': 'cabeca_topo', 'grupo': 'cabeça', 'x': 155.76, 'y': 68.13, 'width': _refWidth, 'height': _refHeight}, // #1
    {'id': 'cabeca_lateral_esquerda', 'grupo': 'cabeça', 'x': 138.54, 'y': 95.43, 'width': _refWidth, 'height': _refHeight}, // #2
    {'id': 'cabeca_lateral_direita', 'grupo': 'cabeça', 'x': 174.55, 'y': 93.90, 'width': _refWidth, 'height': _refHeight}, // #3
    
    // === GRUPO TORSO (#4-10) ===
    {'id': 'torso_pescoco', 'grupo': 'torso', 'x': 158.91, 'y': 139.87, 'width': _refWidth, 'height': _refHeight}, // #4
    {'id': 'torso_ombro_esquerdo', 'grupo': 'torso', 'x': 110.67, 'y': 169.74, 'width': _refWidth, 'height': _refHeight}, // #5
    {'id': 'torso_ombro_direito', 'grupo': 'torso', 'x': 206.73, 'y': 172.15, 'width': _refWidth, 'height': _refHeight}, // #6
    {'id': 'torso_peito', 'grupo': 'torso', 'x': 158.28, 'y': 203.86, 'width': _refWidth, 'height': _refHeight}, // #7
    {'id': 'torso_costela_esquerda', 'grupo': 'torso', 'x': 129.83, 'y': 234.56, 'width': _refWidth, 'height': _refHeight}, // #8
    {'id': 'torso_costela_direita', 'grupo': 'torso', 'x': 183.26, 'y': 234.56, 'width': _refWidth, 'height': _refHeight}, // #9
    {'id': 'torso_abdomen', 'grupo': 'torso', 'x': 158.17, 'y': 289.21, 'width': _refWidth, 'height': _refHeight}, // #10
    
    // === GRUPO BRAÇO ESQUERDO (#11-12) ===
    {'id': 'braco_esquerdo_cotovelo', 'grupo': 'braço_esquerdo', 'x': 93.14, 'y': 267.78, 'width': _refWidth, 'height': _refHeight}, // #11
    {'id': 'braco_esquerdo_antebraco', 'grupo': 'braço_esquerdo', 'x': 83.11, 'y': 325.36, 'width': _refWidth, 'height': _refHeight}, // #12
    
    // === GRUPO BRAÇO DIREITO (#13-14) ===
    {'id': 'braco_direito_cotovelo', 'grupo': 'braço_direito', 'x': 223.57, 'y': 263.42, 'width': _refWidth, 'height': _refHeight}, // #13
    {'id': 'braco_direito_antebraco', 'grupo': 'braço_direito', 'x': 235.18, 'y': 323.78, 'width': _refWidth, 'height': _refHeight}, // #14
    
    // === GRUPO MÃO DIREITA (#15-18) ===
    {'id': 'mao_direita_polegar', 'grupo': 'mao_direita', 'x': 41.10, 'y': 351.71, 'width': _refWidth, 'height': _refHeight}, // #15
    {'id': 'mao_direita_dedos', 'grupo': 'mao_direita', 'x': 43.57, 'y': 376.59, 'width': _refWidth, 'height': _refHeight}, // #16
    {'id': 'mao_direita_punho', 'grupo': 'mao_direita', 'x': 93.75, 'y': 381.05, 'width': _refWidth, 'height': _refHeight}, // #17
    {'id': 'mao_direita_palma', 'grupo': 'mao_direita', 'x': 67.03, 'y': 391.55, 'width': _refWidth, 'height': _refHeight}, // #18

    // === GRUPO MÃO ESQUERDA (#19-22) ===
    {'id': 'mao_esquerda_polegar', 'grupo': 'mao_esquerda', 'x': 273.23, 'y': 355.75, 'width': _refWidth, 'height': _refHeight}, // #19
    {'id': 'mao_esquerda_punho', 'grupo': 'mao_esquerda', 'x': 220.53, 'y': 382.63, 'width': _refWidth, 'height': _refHeight}, // #20
    {'id': 'mao_esquerda_dedos', 'grupo': 'mao_esquerda', 'x': 266.56, 'y': 383.57, 'width': _refWidth, 'height': _refHeight}, // #21
    {'id': 'mao_esquerda_palma', 'grupo': 'mao_esquerda', 'x': 245.73, 'y': 397.06, 'width': _refWidth, 'height': _refHeight}, // #22
    
    // === GRUPO PERNA ESQUERDA (#23-25) ===
    {'id': 'perna_esquerda_quadril', 'grupo': 'perna_esquerda', 'x': 129.72, 'y': 366.35, 'width': _refWidth, 'height': _refHeight}, // #23
    {'id': 'perna_esquerda_coxa', 'grupo': 'perna_esquerda', 'x': 121.90, 'y': 451.23, 'width': _refWidth, 'height': _refHeight}, // #24
    {'id': 'perna_esquerda_joelho', 'grupo': 'perna_esquerda', 'x': 116.49, 'y': 540.36, 'width': _refWidth, 'height': _refHeight}, // #25
    
    // === GRUPO PERNA DIREITA (#26-28) ===
    {'id': 'perna_direita_quadril', 'grupo': 'perna_direita', 'x': 189.09, 'y': 368.09, 'width': _refWidth, 'height': _refHeight}, // #26
    {'id': 'perna_direita_coxa', 'grupo': 'perna_direita', 'x': 199.43, 'y': 450.18, 'width': _refWidth, 'height': _refHeight}, // #27
    {'id': 'perna_direita_joelho', 'grupo': 'perna_direita', 'x': 209.61, 'y': 540.36, 'width': _refWidth, 'height': _refHeight}, // #28
    
    // === GRUPO PÉ ESQUERDO (#29) ===
    {'id': 'pe_esquerdo', 'grupo': 'pe_esquerdo', 'x': 100.60, 'y': 595.20, 'width': _refWidth, 'height': _refHeight}, // #29
    
    // === GRUPO PÉ DIREITO (#30) ===
    {'id': 'pe_direito', 'grupo': 'pe_direito', 'x': 225.96, 'y': 595.20, 'width': _refWidth, 'height': _refHeight}, // #30
  ];

  void _mostrarPopupConfirmacao() {
    final dorProvider = Provider.of<DorProvider>(context, listen: false);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(
              Icons.location_on,
              color: AppColors.buttonPrimary,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              'Locais Selecionados',
              style: AppTypography.heading2Primary,
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Você selecionou ${dorProvider.totalPontosSelecionados} ${dorProvider.totalPontosSelecionados == 1 ? 'local' : 'locais'} de dor:',
                style: AppTypography.bodyMedium,
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: dorProvider.descricoesPontos.map((desc) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.stateError.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.stateError.withOpacity(0.5),
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      desc,
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.stateError,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Editar',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Fecha o dialog
              Navigator.pop(context, true); // Volta para a tela anterior
            },
            style: TextButton.styleFrom(
              backgroundColor: AppColors.buttonPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Confirmar',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textWhite,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.buttonPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textWhite),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.indicatePainLocation,
              style: AppTypography.heading1Secondary,
            ),
            Text(
              l10n.selectPainArea,
              style: AppTypography.heading2Secondary,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                child: _buildCorpoHumano(),
              ),
            ),
          ),
          
          // Botão Confirmar Região
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: AppButton(
              label: l10n.confirmSelection,
              onPressed: _gruposSelecionados.isEmpty
                  ? null
                  : _mostrarPopupConfirmacao,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCorpoHumano() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.buttonPrimary.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Stack(
              children: [
                // Imagem do corpo humano
                Center(
                  child: Image.asset(
                    'assets/images/body-image.png',
                    fit: BoxFit.contain,
                    height: constraints.maxHeight * 0.9,
                  ),
                ),
                
                // Bolinhas nos pontos fixos
                ..._pontosFixes.asMap().entries.map((entry) {
                  final ponto = entry.value;
                  // Calcula a posição proporcional baseada no tamanho atual do container
                  final percentualX = ponto['x']! / ponto['width']!;
                  final percentualY = ponto['y']! / ponto['height']!;
                  final posX = constraints.maxWidth * percentualX;
                  final posY = constraints.maxHeight * percentualY;
                  
                  return Positioned(
                    left: posX - 10,
                    top: posY - 10,
                    child: GestureDetector(
                      onTap: () {
                        _navegarParaGrupo(ponto['grupo']);
                      },
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: AppColors.buttonPrimary.withValues(alpha: 0.8),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.textWhite,
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.buttonPrimary.withValues(alpha: 0.6),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
        );
      },
    );
  }
}
