import 'head_page.dart';
import 'torso_page.dart';
import 'left_arm_page.dart';
import 'right_arm_page.dart';
import 'left_hand_page.dart';
import 'right_hand_page.dart';
import 'left_leg_page.dart';
import 'right_leg_page.dart';
import 'left_foot_page.dart';
import 'right_foot_page.dart';

/// Utilitário para limpar o cache de seleções de todas as páginas de região
class RegionCacheCleaner {
  /// Limpa todas as seleções salvas em cache nas páginas de região
  static void limparTodasSelecoes() {
    HeadPage.limparSelecoes();
    TorsoPage.limparSelecoes();
    LeftArmPage.limparSelecoes();
    RightArmPage.limparSelecoes();
    LeftHandPage.limparSelecoes();
    RightHandPage.limparSelecoes();
    LeftLegPage.limparSelecoes();
    RightLegPage.limparSelecoes();
    LeftFootPage.limparSelecoes();
    RightFootPage.limparSelecoes();
  }
}
