import 'package:flutter/foundation.dart';

/// Provider para gerenciar estado dos registros de dor
class DorProvider with ChangeNotifier {
  // Mapa de regiões selecionadas: região -> lista de pontos
  final Map<String, List<String>> _regioesSelecionadas = {};
  
  // Lista de descrições legíveis dos pontos selecionados
  final List<String> _descricoesPontos = [];

  /// Obtém todas as regiões selecionadas
  Map<String, List<String>> get regioesSelecionadas => Map.unmodifiable(_regioesSelecionadas);
  
  /// Obtém descrições dos pontos selecionados
  List<String> get descricoesPontos => List.unmodifiable(_descricoesPontos);
  
  /// Verifica se há regiões selecionadas
  bool get temRegioesSelecionadas => _regioesSelecionadas.isNotEmpty;
  
  /// Total de pontos selecionados em todas as regiões
  int get totalPontosSelecionados {
    return _regioesSelecionadas.values.fold(0, (sum, list) => sum + list.length);
  }

  /// Adiciona uma região com seus pontos selecionados
  void adicionarRegiao(String regiao, List<String> pontos, List<String> descricoes) {
    if (pontos.isEmpty) {
      _regioesSelecionadas.remove(regiao);
      // Remove descrições antigas desta região
      _descricoesPontos.removeWhere((desc) => desc.startsWith(_getNomeRegiao(regiao)));
    } else {
      _regioesSelecionadas[regiao] = List.from(pontos);
      // Remove descrições antigas desta região
      _descricoesPontos.removeWhere((desc) => desc.startsWith(_getNomeRegiao(regiao)));
      // Adiciona novas descrições
      _descricoesPontos.addAll(descricoes);
    }
    notifyListeners();
  }

  /// Remove uma região específica
  void removerRegiao(String regiao) {
    _regioesSelecionadas.remove(regiao);
    _descricoesPontos.removeWhere((desc) => desc.startsWith(_getNomeRegiao(regiao)));
    notifyListeners();
  }

  /// Limpa todas as seleções
  void limparSelecoes() {
    _regioesSelecionadas.clear();
    _descricoesPontos.clear();
    notifyListeners();
  }

  /// Obtém lista de todas as localizações em formato de string
  List<String> getLocalizacoesParaSalvar() {
    final List<String> localizacoes = [];
    _regioesSelecionadas.forEach((regiao, pontos) {
      for (var ponto in pontos) {
        localizacoes.add('$regiao:$ponto');
      }
    });
    return localizacoes;
  }

  /// Converte nome interno da região para nome legível
  String _getNomeRegiao(String regiao) {
    switch (regiao) {
      case 'cabeça':
        return 'Cabeça';
      case 'torso':
        return 'Torso';
      case 'braço_esquerdo':
        return 'Braço direito'; // Invertido para usuário
      case 'braço_direito':
        return 'Braço esquerdo'; // Invertido para usuário
      case 'mao_esquerda':
        return 'Mão esquerda';
      case 'mao_direita':
        return 'Mão direita';
      case 'perna_esquerda':
        return 'Perna direita'; // Invertido para usuário
      case 'perna_direita':
        return 'Perna esquerda'; // Invertido para usuário
      case 'pe_esquerdo':
        return 'Pé direito'; // Invertido para usuário
      case 'pe_direito':
        return 'Pé esquerdo'; // Invertido para usuário
      default:
        return regiao;
    }
  }

  /// Obtém descrições agrupadas por parte do corpo
  Map<String, List<String>> getDescricoesAgrupadas() {
    final Map<String, List<String>> agrupadas = {};
    
    for (var desc in _descricoesPontos) {
      final partes = desc.split(':');
      if (partes.length == 2) {
        final parte = partes[0].trim();
        final local = partes[1].trim();
        
        if (!agrupadas.containsKey(parte)) {
          agrupadas[parte] = [];
        }
        agrupadas[parte]!.add(local);
      }
    }
    
    return agrupadas;
  }
}
