/// Utilitários para mapear nomes de regiões do corpo
class BodyRegionMapper {
  /// Mapa de IDs de pontos para nomes legíveis (considerando inversão esquerda/direita)
  static final Map<String, String> _pontosParaNomes = {
    // Cabeça
    'cabeca_topo': 'Cabeça: Topo',
    'cabeca_lateral_esquerda': 'Cabeça: Lado direito', // Invertido
    'cabeca_lateral_direita': 'Cabeça: Lado esquerdo', // Invertido
    
    // Torso
    'torso_pescoco': 'Torso: Pescoço',
    'torso_ombro_esquerdo': 'Torso: Ombro direito', // Invertido
    'torso_ombro_direito': 'Torso: Ombro esquerdo', // Invertido
    'torso_peito': 'Torso: Peito',
    'torso_costela_esquerda': 'Torso: Costela direita', // Invertido
    'torso_costela_direita': 'Torso: Costela esquerda', // Invertido
    'torso_abdomen': 'Torso: Abdômen',
    
    // Braço Esquerdo (imagem) = Direito (usuário)
    'braco_esquerdo_cotovelo': 'Braço direito: Cotovelo',
    'braco_esquerdo_antebraco': 'Braço direito: Antebraço',
    
    // Braço Direito (imagem) = Esquerdo (usuário)
    'braco_direito_cotovelo': 'Braço esquerdo: Cotovelo',
    'braco_direito_antebraco': 'Braço esquerdo: Antebraço',
    
    // Mão Direita (imagem) = Esquerda (usuário) 
    'mao_direita_polegar': 'Mão esquerda: Polegar',
    'mao_direita_dedos': 'Mão esquerda: Dedos',
    'mao_direita_punho': 'Mão esquerda: Punho',
    'mao_direita_palma': 'Mão esquerda: Palma',
    
    // Mão Esquerda (imagem) = Direita (usuário)
    'mao_esquerda_polegar': 'Mão direita: Polegar',
    'mao_esquerda_punho': 'Mão direita: Punho',
    'mao_esquerda_dedos': 'Mão direita: Dedos',
    'mao_esquerda_palma': 'Mão direita: Palma',
    
    // Perna Esquerda (imagem) = Direita (usuário)
    'perna_esquerda_quadril': 'Perna direita: Quadril',
    'perna_esquerda_coxa': 'Perna direita: Coxa',
    'perna_esquerda_joelho': 'Perna direita: Joelho',
    
    // Perna Direita (imagem) = Esquerda (usuário)
    'perna_direita_quadril': 'Perna esquerda: Quadril',
    'perna_direita_coxa': 'Perna esquerda: Coxa',
    'perna_direita_joelho': 'Perna esquerda: Joelho',
    
    // Pé Esquerdo (imagem) = Direito (usuário)
    'pe_esquerdo': 'Pé direito',
    
    // Pé Direito (imagem) = Esquerdo (usuário)
    'pe_direito': 'Pé esquerdo',
  };

  /// Mapa de pontos das páginas de detalhes para nomes legíveis
  static final Map<String, Map<String, String>> _pontosPaginasDetalhes = {
    'Cabeça': {
      'Ponto 1': 'Lado direito superior',
      'Ponto 2': 'Lado esquerdo superior',
      'Ponto 3': 'Lado esquerdo lateral',
      'Ponto 4': 'Lado direito lateral',
      'Ponto 5': 'Topo esquerdo',
      'Ponto 6': 'Topo direito',
      'Ponto 7': 'Centro',
    },
    'Torso': {
      'Ponto 1': 'Pescoço',
      'Ponto 2': 'Ombro direito',
      'Ponto 3': 'Ombro esquerdo',
      'Ponto 4': 'Peito superior direito',
      'Ponto 5': 'Peito superior esquerdo',
      'Ponto 6': 'Centro do peito',
      'Ponto 7': 'Costela direita',
      'Ponto 8': 'Costela esquerda',
      'Ponto 9': 'Abdômen superior direito',
      'Ponto 10': 'Abdômen superior esquerdo',
      'Ponto 11': 'Centro do abdômen',
    },
    // Adicionar outros conforme necessário
  };

  /// Converte ID do ponto para nome legível
  static String getNomePonto(String pontoId) {
    return _pontosParaNomes[pontoId] ?? pontoId;
  }

  /// Converte ponto da página de detalhe para nome legível
  static String getNomePontoDetalhe(String regiao, String ponto) {
    if (_pontosPaginasDetalhes.containsKey(regiao)) {
      return _pontosPaginasDetalhes[regiao]![ponto] ?? ponto;
    }
    return ponto;
  }

  /// Obtém nome da região em formato legível (considerando inversão)
  static String getNomeRegiao(String regiao) {
    switch (regiao) {
      case 'cabeça':
        return 'Cabeça';
      case 'torso':
        return 'Torso';
      case 'braço_esquerdo':
        return 'Braço direito'; // Invertido
      case 'braço_direito':
        return 'Braço esquerdo'; // Invertido
      case 'mao_esquerda':
        return 'Mão direita'; // Invertido
      case 'mao_direita':
        return 'Mão esquerda'; // Invertido
      case 'perna_esquerda':
        return 'Perna direita'; // Invertido
      case 'perna_direita':
        return 'Perna esquerda'; // Invertido
      case 'pe_esquerdo':
        return 'Pé direito'; // Invertido
      case 'pe_direito':
        return 'Pé esquerdo'; // Invertido
      default:
        return regiao;
    }
  }

  /// Agrupa descrições por parte do corpo
  static Map<String, List<String>> agruparPorParteDoCorpo(List<String> descricoes) {
    final Map<String, List<String>> agrupadas = {};
    
    for (var desc in descricoes) {
      final partes = desc.split(':');
      if (partes.length >= 2) {
        final parte = partes[0].trim();
        final local = partes.sublist(1).join(':').trim();
        
        if (!agrupadas.containsKey(parte)) {
          agrupadas[parte] = [];
        }
        agrupadas[parte]!.add(local);
      }
    }
    
    return agrupadas;
  }
}
