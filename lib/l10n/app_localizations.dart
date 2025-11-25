import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('en', 'US'),
    Locale('pt'),
    Locale('pt', 'BR'),
  ];

  /// No description provided for @navPain.
  ///
  /// In pt_BR, this message translates to:
  /// **'Dor'**
  String get navPain;

  /// No description provided for @navPractices.
  ///
  /// In pt_BR, this message translates to:
  /// **'Práticas'**
  String get navPractices;

  /// No description provided for @navEducation.
  ///
  /// In pt_BR, this message translates to:
  /// **'Educação'**
  String get navEducation;

  /// No description provided for @navReminders.
  ///
  /// In pt_BR, this message translates to:
  /// **'Lembretes'**
  String get navReminders;

  /// No description provided for @navSettings.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ajustes'**
  String get navSettings;

  /// No description provided for @welcome.
  ///
  /// In pt_BR, this message translates to:
  /// **'Bem-vindo! Complete seu cadastro para começar'**
  String get welcome;

  /// No description provided for @welcomeBack.
  ///
  /// In pt_BR, this message translates to:
  /// **'Gerencie sua saúde osteoarticular'**
  String get welcomeBack;

  /// No description provided for @login.
  ///
  /// In pt_BR, this message translates to:
  /// **'Entrar'**
  String get login;

  /// No description provided for @createAccount.
  ///
  /// In pt_BR, this message translates to:
  /// **'Criar Conta'**
  String get createAccount;

  /// No description provided for @email.
  ///
  /// In pt_BR, this message translates to:
  /// **'E-mail'**
  String get email;

  /// No description provided for @emailHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'seu@email.com'**
  String get emailHint;

  /// No description provided for @password.
  ///
  /// In pt_BR, this message translates to:
  /// **'Senha'**
  String get password;

  /// No description provided for @passwordHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'••••••'**
  String get passwordHint;

  /// No description provided for @confirmPassword.
  ///
  /// In pt_BR, this message translates to:
  /// **'Confirmar Senha'**
  String get confirmPassword;

  /// No description provided for @forgotPassword.
  ///
  /// In pt_BR, this message translates to:
  /// **'Esqueci minha senha'**
  String get forgotPassword;

  /// No description provided for @continueButton.
  ///
  /// In pt_BR, this message translates to:
  /// **'Continuar'**
  String get continueButton;

  /// No description provided for @registerStep1Title.
  ///
  /// In pt_BR, this message translates to:
  /// **'Informações Pessoais'**
  String get registerStep1Title;

  /// No description provided for @firstName.
  ///
  /// In pt_BR, this message translates to:
  /// **'Primeiro Nome'**
  String get firstName;

  /// No description provided for @firstNameHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Digite seu primeiro nome'**
  String get firstNameHint;

  /// No description provided for @lastName.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sobrenome'**
  String get lastName;

  /// No description provided for @lastNameHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Digite seu sobrenome'**
  String get lastNameHint;

  /// No description provided for @birthdate.
  ///
  /// In pt_BR, this message translates to:
  /// **'Data de Nascimento'**
  String get birthdate;

  /// No description provided for @birthdateHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'DD/MM/AAAA'**
  String get birthdateHint;

  /// No description provided for @gender.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sexo'**
  String get gender;

  /// No description provided for @genderOptional.
  ///
  /// In pt_BR, this message translates to:
  /// **'(opcional)'**
  String get genderOptional;

  /// No description provided for @genderHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Selecione uma opção'**
  String get genderHint;

  /// No description provided for @genderMale.
  ///
  /// In pt_BR, this message translates to:
  /// **'Masculino'**
  String get genderMale;

  /// No description provided for @genderFemale.
  ///
  /// In pt_BR, this message translates to:
  /// **'Feminino'**
  String get genderFemale;

  /// No description provided for @genderOther.
  ///
  /// In pt_BR, this message translates to:
  /// **'Outro'**
  String get genderOther;

  /// No description provided for @registerStep2Title.
  ///
  /// In pt_BR, this message translates to:
  /// **'Dados de Saúde'**
  String get registerStep2Title;

  /// No description provided for @registerStep2Description.
  ///
  /// In pt_BR, this message translates to:
  /// **'Conte um pouco sobre você para começarmos seu acompanhamento personalizado.'**
  String get registerStep2Description;

  /// No description provided for @healthDataDescription.
  ///
  /// In pt_BR, this message translates to:
  /// **'Selecione seu diagnóstico principal e comorbidades. Você pode editar isso mais tarde.'**
  String get healthDataDescription;

  /// No description provided for @primaryDiagnosis.
  ///
  /// In pt_BR, this message translates to:
  /// **'Diagnóstico Principal'**
  String get primaryDiagnosis;

  /// No description provided for @rheumatoidArthritis.
  ///
  /// In pt_BR, this message translates to:
  /// **'Artrite reumatoide'**
  String get rheumatoidArthritis;

  /// No description provided for @arthrosis.
  ///
  /// In pt_BR, this message translates to:
  /// **'Artrose'**
  String get arthrosis;

  /// No description provided for @fibromyalgia.
  ///
  /// In pt_BR, this message translates to:
  /// **'Fibromialgia'**
  String get fibromyalgia;

  /// No description provided for @otherDiagnosis.
  ///
  /// In pt_BR, this message translates to:
  /// **'Outro diagnóstico'**
  String get otherDiagnosis;

  /// No description provided for @specifyDiagnosis.
  ///
  /// In pt_BR, this message translates to:
  /// **'Especifique seu diagnóstico'**
  String get specifyDiagnosis;

  /// No description provided for @comorbidities.
  ///
  /// In pt_BR, this message translates to:
  /// **'Comorbidades'**
  String get comorbidities;

  /// No description provided for @comorbiditiesDescription.
  ///
  /// In pt_BR, this message translates to:
  /// **'Selecione todas que se aplicam (ou \"Nenhuma\")'**
  String get comorbiditiesDescription;

  /// No description provided for @hypertension.
  ///
  /// In pt_BR, this message translates to:
  /// **'Hipertensão'**
  String get hypertension;

  /// No description provided for @diabetes.
  ///
  /// In pt_BR, this message translates to:
  /// **'Diabetes'**
  String get diabetes;

  /// No description provided for @osteoporosis.
  ///
  /// In pt_BR, this message translates to:
  /// **'Osteoporose'**
  String get osteoporosis;

  /// No description provided for @other.
  ///
  /// In pt_BR, this message translates to:
  /// **'Outro'**
  String get other;

  /// No description provided for @none.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nenhuma'**
  String get none;

  /// No description provided for @specifyComorbidity.
  ///
  /// In pt_BR, this message translates to:
  /// **'Especifique a comorbidade'**
  String get specifyComorbidity;

  /// No description provided for @registerStep3Title.
  ///
  /// In pt_BR, this message translates to:
  /// **'Preferências de Acessibilidade'**
  String get registerStep3Title;

  /// No description provided for @registerStep3Question.
  ///
  /// In pt_BR, this message translates to:
  /// **'Gostaria de personalizar sua experiência?'**
  String get registerStep3Question;

  /// No description provided for @fontSize.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tamanho da Fonte'**
  String get fontSize;

  /// No description provided for @fontSizeVerySmall.
  ///
  /// In pt_BR, this message translates to:
  /// **'Muito Pequeno'**
  String get fontSizeVerySmall;

  /// No description provided for @fontSizeSmall.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pequeno'**
  String get fontSizeSmall;

  /// No description provided for @fontSizeSmallMedium.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pequeno-Médio'**
  String get fontSizeSmallMedium;

  /// No description provided for @fontSizeMedium.
  ///
  /// In pt_BR, this message translates to:
  /// **'Médio'**
  String get fontSizeMedium;

  /// No description provided for @fontSizeMediumLarge.
  ///
  /// In pt_BR, this message translates to:
  /// **'Médio-Grande'**
  String get fontSizeMediumLarge;

  /// No description provided for @fontSizeLarge.
  ///
  /// In pt_BR, this message translates to:
  /// **'Grande'**
  String get fontSizeLarge;

  /// No description provided for @fontSizeVeryLarge.
  ///
  /// In pt_BR, this message translates to:
  /// **'Muito Grande'**
  String get fontSizeVeryLarge;

  /// No description provided for @highContrast.
  ///
  /// In pt_BR, this message translates to:
  /// **'Alto Contraste'**
  String get highContrast;

  /// No description provided for @highContrastDescription.
  ///
  /// In pt_BR, this message translates to:
  /// **'Melhor visibilidade para textos'**
  String get highContrastDescription;

  /// No description provided for @textToSpeech.
  ///
  /// In pt_BR, this message translates to:
  /// **'Texto-Para-Fala'**
  String get textToSpeech;

  /// No description provided for @textToSpeechDescription.
  ///
  /// In pt_BR, this message translates to:
  /// **'Leitura de textos em voz alta'**
  String get textToSpeechDescription;

  /// No description provided for @privacyAndData.
  ///
  /// In pt_BR, this message translates to:
  /// **'Privacidade e Uso de Dados'**
  String get privacyAndData;

  /// No description provided for @gdprConsent.
  ///
  /// In pt_BR, this message translates to:
  /// **'Li e concordo com a política de privacidade'**
  String get gdprConsent;

  /// No description provided for @emailConsent.
  ///
  /// In pt_BR, this message translates to:
  /// **'Desejo receber e-mails informativos'**
  String get emailConsent;

  /// No description provided for @finishRegistration.
  ///
  /// In pt_BR, this message translates to:
  /// **'Finalizar Cadastro'**
  String get finishRegistration;

  /// No description provided for @back.
  ///
  /// In pt_BR, this message translates to:
  /// **'Voltar'**
  String get back;

  /// No description provided for @save.
  ///
  /// In pt_BR, this message translates to:
  /// **'Salvar'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// No description provided for @apply.
  ///
  /// In pt_BR, this message translates to:
  /// **'Aplicar'**
  String get apply;

  /// No description provided for @edit.
  ///
  /// In pt_BR, this message translates to:
  /// **'Editar'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In pt_BR, this message translates to:
  /// **'Deletar'**
  String get delete;

  /// No description provided for @confirm.
  ///
  /// In pt_BR, this message translates to:
  /// **'Confirmar'**
  String get confirm;

  /// No description provided for @yes.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sim'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In pt_BR, this message translates to:
  /// **'Não'**
  String get no;

  /// No description provided for @ok.
  ///
  /// In pt_BR, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @required.
  ///
  /// In pt_BR, this message translates to:
  /// **'*'**
  String get required;

  /// No description provided for @optional.
  ///
  /// In pt_BR, this message translates to:
  /// **'(opcional)'**
  String get optional;

  /// No description provided for @painTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Dor'**
  String get painTitle;

  /// No description provided for @painLevel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nível de Dor'**
  String get painLevel;

  /// No description provided for @painLocation.
  ///
  /// In pt_BR, this message translates to:
  /// **'Local da Dor'**
  String get painLocation;

  /// No description provided for @indicatePainLocation.
  ///
  /// In pt_BR, this message translates to:
  /// **'Indicar local da dor'**
  String get indicatePainLocation;

  /// No description provided for @painHistory.
  ///
  /// In pt_BR, this message translates to:
  /// **'Histórico de Dor'**
  String get painHistory;

  /// No description provided for @noPainHistory.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nenhum registro de dor ainda'**
  String get noPainHistory;

  /// No description provided for @noPainHistoryDescription.
  ///
  /// In pt_BR, this message translates to:
  /// **'Registre seu primeiro episódio de dor usando o botão abaixo'**
  String get noPainHistoryDescription;

  /// No description provided for @registerPain.
  ///
  /// In pt_BR, this message translates to:
  /// **'Registrar Dor'**
  String get registerPain;

  /// No description provided for @painIntensity.
  ///
  /// In pt_BR, this message translates to:
  /// **'Intensidade da Dor'**
  String get painIntensity;

  /// No description provided for @noPain.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sem dor'**
  String get noPain;

  /// No description provided for @mildPain.
  ///
  /// In pt_BR, this message translates to:
  /// **'Dor leve'**
  String get mildPain;

  /// No description provided for @moderatePain.
  ///
  /// In pt_BR, this message translates to:
  /// **'Dor moderada'**
  String get moderatePain;

  /// No description provided for @severePain.
  ///
  /// In pt_BR, this message translates to:
  /// **'Dor severa'**
  String get severePain;

  /// No description provided for @worstPain.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pior dor possível'**
  String get worstPain;

  /// No description provided for @practicesTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Práticas de Bem-Estar'**
  String get practicesTitle;

  /// No description provided for @practicesSubtitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Exercícios e técnicas para aliviar a dor'**
  String get practicesSubtitle;

  /// No description provided for @startPractice.
  ///
  /// In pt_BR, this message translates to:
  /// **'Iniciar Prática'**
  String get startPractice;

  /// No description provided for @startSession.
  ///
  /// In pt_BR, this message translates to:
  /// **'Iniciar Sessão'**
  String get startSession;

  /// No description provided for @benefits.
  ///
  /// In pt_BR, this message translates to:
  /// **'Benefícios'**
  String get benefits;

  /// No description provided for @howToDo.
  ///
  /// In pt_BR, this message translates to:
  /// **'Como Fazer'**
  String get howToDo;

  /// No description provided for @attention.
  ///
  /// In pt_BR, this message translates to:
  /// **'Atenção'**
  String get attention;

  /// No description provided for @categoryBreathing.
  ///
  /// In pt_BR, this message translates to:
  /// **'Respiração'**
  String get categoryBreathing;

  /// No description provided for @categoryStretching.
  ///
  /// In pt_BR, this message translates to:
  /// **'Alongamento'**
  String get categoryStretching;

  /// No description provided for @categoryLianGong.
  ///
  /// In pt_BR, this message translates to:
  /// **'LianGong'**
  String get categoryLianGong;

  /// No description provided for @categoryRelaxation.
  ///
  /// In pt_BR, this message translates to:
  /// **'Relaxamento'**
  String get categoryRelaxation;

  /// No description provided for @categoryTouch.
  ///
  /// In pt_BR, this message translates to:
  /// **'Toque'**
  String get categoryTouch;

  /// No description provided for @levelBeginner.
  ///
  /// In pt_BR, this message translates to:
  /// **'Iniciante'**
  String get levelBeginner;

  /// No description provided for @levelIntermediate.
  ///
  /// In pt_BR, this message translates to:
  /// **'Intermediário'**
  String get levelIntermediate;

  /// No description provided for @practice478Title.
  ///
  /// In pt_BR, this message translates to:
  /// **'Respiração 4-7-8'**
  String get practice478Title;

  /// No description provided for @practice478Description.
  ///
  /// In pt_BR, this message translates to:
  /// **'Acalma o sistema nervoso, reduz ansiedade e pode melhorar a percepção da dor. Ideal antes de dormir.'**
  String get practice478Description;

  /// No description provided for @practice478Benefits.
  ///
  /// In pt_BR, this message translates to:
  /// **'Acalma o sistema nervoso, reduz ansiedade e pode melhorar a percepção da dor. Ideal antes de dormir.'**
  String get practice478Benefits;

  /// No description provided for @practice478Step1.
  ///
  /// In pt_BR, this message translates to:
  /// **'Inspire pelo nariz contando até 4'**
  String get practice478Step1;

  /// No description provided for @practice478Step2.
  ///
  /// In pt_BR, this message translates to:
  /// **'Segure o ar contando até 7'**
  String get practice478Step2;

  /// No description provided for @practice478Step3.
  ///
  /// In pt_BR, this message translates to:
  /// **'Expire pela boca contando até 8'**
  String get practice478Step3;

  /// No description provided for @practice478Step4.
  ///
  /// In pt_BR, this message translates to:
  /// **'Repita 4 ciclos completos'**
  String get practice478Step4;

  /// No description provided for @practice478Warning.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pare se sentir tontura. Não force a respiração.'**
  String get practice478Warning;

  /// No description provided for @practiceStretchingTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Alongamento de Mãos'**
  String get practiceStretchingTitle;

  /// No description provided for @practiceStretchingDescription.
  ///
  /// In pt_BR, this message translates to:
  /// **'Bom para rigidez matinal. Melhora mobilidade das articulações dos dedos.'**
  String get practiceStretchingDescription;

  /// No description provided for @practiceStretchingBenefits.
  ///
  /// In pt_BR, this message translates to:
  /// **'Reduz rigidez matinal, melhora mobilidade das articulações dos dedos e previne dores nas mãos.'**
  String get practiceStretchingBenefits;

  /// No description provided for @practiceStretchingStep1.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sente-se confortavelmente'**
  String get practiceStretchingStep1;

  /// No description provided for @practiceStretchingStep2.
  ///
  /// In pt_BR, this message translates to:
  /// **'Abra as mãos devagar'**
  String get practiceStretchingStep2;

  /// No description provided for @practiceStretchingStep3.
  ///
  /// In pt_BR, this message translates to:
  /// **'Feche formando punho suave'**
  String get practiceStretchingStep3;

  /// No description provided for @practiceStretchingStep4.
  ///
  /// In pt_BR, this message translates to:
  /// **'Repita 10 vezes'**
  String get practiceStretchingStep4;

  /// No description provided for @practiceStretchingStep5.
  ///
  /// In pt_BR, this message translates to:
  /// **'Descanse'**
  String get practiceStretchingStep5;

  /// No description provided for @practiceStretchingWarning.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pare se sentir dor forte.'**
  String get practiceStretchingWarning;

  /// No description provided for @practiceLiangongTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'LianGong - Rotação de Ombros'**
  String get practiceLiangongTitle;

  /// No description provided for @practiceLiangongDescription.
  ///
  /// In pt_BR, this message translates to:
  /// **'Melhora mobilidade dos ombros, reduz tensão na região cervical.'**
  String get practiceLiangongDescription;

  /// No description provided for @practiceLiangongBenefits.
  ///
  /// In pt_BR, this message translates to:
  /// **'Melhora mobilidade dos ombros, reduz tensão na região cervical e alivia dor nas costas.'**
  String get practiceLiangongBenefits;

  /// No description provided for @practiceLiangongStep1.
  ///
  /// In pt_BR, this message translates to:
  /// **'Fique em pé ou sentado'**
  String get practiceLiangongStep1;

  /// No description provided for @practiceLiangongStep2.
  ///
  /// In pt_BR, this message translates to:
  /// **'Relaxe os ombros'**
  String get practiceLiangongStep2;

  /// No description provided for @practiceLiangongStep3.
  ///
  /// In pt_BR, this message translates to:
  /// **'Gire os ombros para frente 8 vezes'**
  String get practiceLiangongStep3;

  /// No description provided for @practiceLiangongStep4.
  ///
  /// In pt_BR, this message translates to:
  /// **'Gire os ombros para trás 8 vezes'**
  String get practiceLiangongStep4;

  /// No description provided for @practiceLiangongStep5.
  ///
  /// In pt_BR, this message translates to:
  /// **'Descanse entre as séries'**
  String get practiceLiangongStep5;

  /// No description provided for @practiceLiangongWarning.
  ///
  /// In pt_BR, this message translates to:
  /// **'Movimentos devem ser suaves e controlados.'**
  String get practiceLiangongWarning;

  /// No description provided for @practiceDeepBreathingTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Respiração Profunda'**
  String get practiceDeepBreathingTitle;

  /// No description provided for @practiceDeepBreathingDescription.
  ///
  /// In pt_BR, this message translates to:
  /// **'Reduz tensão e ansiedade através da respiração diafragmática controlada.'**
  String get practiceDeepBreathingDescription;

  /// No description provided for @practiceDeepBreathingBenefits.
  ///
  /// In pt_BR, this message translates to:
  /// **'Reduz tensão e ansiedade através da respiração diafragmática controlada. Promove relaxamento geral.'**
  String get practiceDeepBreathingBenefits;

  /// No description provided for @practiceDeepBreathingStep1.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sente-se ou deite confortavelmente'**
  String get practiceDeepBreathingStep1;

  /// No description provided for @practiceDeepBreathingStep2.
  ///
  /// In pt_BR, this message translates to:
  /// **'Coloque uma mão no peito e outra na barriga'**
  String get practiceDeepBreathingStep2;

  /// No description provided for @practiceDeepBreathingStep3.
  ///
  /// In pt_BR, this message translates to:
  /// **'Inspire profundamente pelo nariz'**
  String get practiceDeepBreathingStep3;

  /// No description provided for @practiceDeepBreathingStep4.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sinta a barriga expandir'**
  String get practiceDeepBreathingStep4;

  /// No description provided for @practiceDeepBreathingStep5.
  ///
  /// In pt_BR, this message translates to:
  /// **'Expire lentamente pela boca'**
  String get practiceDeepBreathingStep5;

  /// No description provided for @practiceDeepBreathingStep6.
  ///
  /// In pt_BR, this message translates to:
  /// **'Repita por 5 minutos'**
  String get practiceDeepBreathingStep6;

  /// No description provided for @practiceDeepBreathingWarning.
  ///
  /// In pt_BR, this message translates to:
  /// **'Não force. Pare se sentir tontura.'**
  String get practiceDeepBreathingWarning;

  /// No description provided for @practiceSighTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Suspiro de Alívio'**
  String get practiceSighTitle;

  /// No description provided for @practiceSighDescription.
  ///
  /// In pt_BR, this message translates to:
  /// **'Libera tensão rapidamente através de suspiros profundos e audíveis.'**
  String get practiceSighDescription;

  /// No description provided for @practiceSighBenefits.
  ///
  /// In pt_BR, this message translates to:
  /// **'Libera tensão rapidamente através de suspiros profundos e audíveis. Alívio instantâneo.'**
  String get practiceSighBenefits;

  /// No description provided for @practiceSighStep1.
  ///
  /// In pt_BR, this message translates to:
  /// **'Inspire profundamente pelo nariz'**
  String get practiceSighStep1;

  /// No description provided for @practiceSighStep2.
  ///
  /// In pt_BR, this message translates to:
  /// **'Segure por 2 segundos'**
  String get practiceSighStep2;

  /// No description provided for @practiceSighStep3.
  ///
  /// In pt_BR, this message translates to:
  /// **'Solte o ar com um suspiro audivel'**
  String get practiceSighStep3;

  /// No description provided for @practiceSighStep4.
  ///
  /// In pt_BR, this message translates to:
  /// **'Repita 5-10 vezes'**
  String get practiceSighStep4;

  /// No description provided for @practiceSighWarning.
  ///
  /// In pt_BR, this message translates to:
  /// **'Use quando sentir tensão acumulada.'**
  String get practiceSighWarning;

  /// No description provided for @practiceRelaxationTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Relaxamento Muscular'**
  String get practiceRelaxationTitle;

  /// No description provided for @practiceRelaxationDescription.
  ///
  /// In pt_BR, this message translates to:
  /// **'Alivia tensão muscular através de contração e relaxamento progressivo.'**
  String get practiceRelaxationDescription;

  /// No description provided for @practiceRelaxationBenefits.
  ///
  /// In pt_BR, this message translates to:
  /// **'Alivia tensão muscular através de contração e relaxamento progressivo. Reduz estresse corporal.'**
  String get practiceRelaxationBenefits;

  /// No description provided for @practiceRelaxationStep1.
  ///
  /// In pt_BR, this message translates to:
  /// **'Deite-se confortavelmente'**
  String get practiceRelaxationStep1;

  /// No description provided for @practiceRelaxationStep2.
  ///
  /// In pt_BR, this message translates to:
  /// **'Contraia os músculos dos pés por 5 segundos'**
  String get practiceRelaxationStep2;

  /// No description provided for @practiceRelaxationStep3.
  ///
  /// In pt_BR, this message translates to:
  /// **'Relaxe completamente'**
  String get practiceRelaxationStep3;

  /// No description provided for @practiceRelaxationStep4.
  ///
  /// In pt_BR, this message translates to:
  /// **'Suba progressivamente pelo corpo'**
  String get practiceRelaxationStep4;

  /// No description provided for @practiceRelaxationStep5.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pernas, abdômen, braços, rosto'**
  String get practiceRelaxationStep5;

  /// No description provided for @practiceRelaxationWarning.
  ///
  /// In pt_BR, this message translates to:
  /// **'Não force as contrações.'**
  String get practiceRelaxationWarning;

  /// No description provided for @practiceTouchTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Toque Calmante'**
  String get practiceTouchTitle;

  /// No description provided for @practiceTouchDescription.
  ///
  /// In pt_BR, this message translates to:
  /// **'Proporciona conforto imediato através do calor das mãos e toques suaves.'**
  String get practiceTouchDescription;

  /// No description provided for @practiceTouchBenefits.
  ///
  /// In pt_BR, this message translates to:
  /// **'Proporciona conforto imediato através do calor das mãos e toques suaves. Autocompaixão.'**
  String get practiceTouchBenefits;

  /// No description provided for @practiceTouchStep1.
  ///
  /// In pt_BR, this message translates to:
  /// **'Esfregue as mãos até aquecer'**
  String get practiceTouchStep1;

  /// No description provided for @practiceTouchStep2.
  ///
  /// In pt_BR, this message translates to:
  /// **'Coloque as mãos sobre o rosto'**
  String get practiceTouchStep2;

  /// No description provided for @practiceTouchStep3.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sinta o calor e conforto'**
  String get practiceTouchStep3;

  /// No description provided for @practiceTouchStep4.
  ///
  /// In pt_BR, this message translates to:
  /// **'Mova para outras áreas que precisam'**
  String get practiceTouchStep4;

  /// No description provided for @practiceTouchStep5.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ombros, pescoço, peito'**
  String get practiceTouchStep5;

  /// No description provided for @practiceTouchWarning.
  ///
  /// In pt_BR, this message translates to:
  /// **'Use toques suaves e gentis.'**
  String get practiceTouchWarning;

  /// No description provided for @duration.
  ///
  /// In pt_BR, this message translates to:
  /// **'Duração'**
  String get duration;

  /// No description provided for @difficulty.
  ///
  /// In pt_BR, this message translates to:
  /// **'Dificuldade'**
  String get difficulty;

  /// No description provided for @difficultyEasy.
  ///
  /// In pt_BR, this message translates to:
  /// **'Fácil'**
  String get difficultyEasy;

  /// No description provided for @difficultyModerate.
  ///
  /// In pt_BR, this message translates to:
  /// **'Moderado'**
  String get difficultyModerate;

  /// No description provided for @difficultyHard.
  ///
  /// In pt_BR, this message translates to:
  /// **'Difícil'**
  String get difficultyHard;

  /// No description provided for @instructions.
  ///
  /// In pt_BR, this message translates to:
  /// **'Instruções'**
  String get instructions;

  /// No description provided for @educationTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Educação'**
  String get educationTitle;

  /// No description provided for @educationSubtitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Aprenda sobre osteoartrite e autocuidado'**
  String get educationSubtitle;

  /// No description provided for @educationTopicOsteoarthritis.
  ///
  /// In pt_BR, this message translates to:
  /// **'O que é Osteoartrite?'**
  String get educationTopicOsteoarthritis;

  /// No description provided for @educationTopicNutrition.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nutrição e Saúde das Articulações'**
  String get educationTopicNutrition;

  /// No description provided for @educationTopicExercise.
  ///
  /// In pt_BR, this message translates to:
  /// **'Exercícios e Movimento'**
  String get educationTopicExercise;

  /// No description provided for @educationTagIntroduction.
  ///
  /// In pt_BR, this message translates to:
  /// **'Introdução'**
  String get educationTagIntroduction;

  /// No description provided for @educationTagBasic.
  ///
  /// In pt_BR, this message translates to:
  /// **'Básico'**
  String get educationTagBasic;

  /// No description provided for @educationTagDiet.
  ///
  /// In pt_BR, this message translates to:
  /// **'Dieta'**
  String get educationTagDiet;

  /// No description provided for @educationTagNutrition.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nutrição'**
  String get educationTagNutrition;

  /// No description provided for @educationTagExercise.
  ///
  /// In pt_BR, this message translates to:
  /// **'Exercício'**
  String get educationTagExercise;

  /// No description provided for @educationTagMovement.
  ///
  /// In pt_BR, this message translates to:
  /// **'Movimento'**
  String get educationTagMovement;

  /// No description provided for @osteoarthritisDefinition.
  ///
  /// In pt_BR, this message translates to:
  /// **'Definição'**
  String get osteoarthritisDefinition;

  /// No description provided for @osteoarthritisDefinitionText.
  ///
  /// In pt_BR, this message translates to:
  /// **'A osteoartrite, também conhecida como artrose, é uma doença degenerativa das articulações que afeta principalmente a cartilagem. É o tipo mais comum de artrite e pode causar dor, rigidez e limitação de movimento.'**
  String get osteoarthritisDefinitionText;

  /// No description provided for @osteoarthritisMainCauses.
  ///
  /// In pt_BR, this message translates to:
  /// **'Causas Principais'**
  String get osteoarthritisMainCauses;

  /// No description provided for @osteoarthritisMainCausesText.
  ///
  /// In pt_BR, this message translates to:
  /// **'• Envelhecimento natural\n• Sobrepeso e obesidade\n• Lesões articulares anteriores\n• Uso repetitivo das articulações\n• Fatores genéticos\n• Deformidades ósseas'**
  String get osteoarthritisMainCausesText;

  /// No description provided for @osteoarthritisCommonSymptoms.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sintomas Comuns'**
  String get osteoarthritisCommonSymptoms;

  /// No description provided for @osteoarthritisCommonSymptomsText.
  ///
  /// In pt_BR, this message translates to:
  /// **'• Dor nas articulações durante ou após movimento\n• Rigidez, especialmente ao acordar\n• Perda de flexibilidade\n• Sensação de atrito ao mover a articulação\n• Inchaço ao redor da articulação'**
  String get osteoarthritisCommonSymptomsText;

  /// No description provided for @osteoarthritisMostAffected.
  ///
  /// In pt_BR, this message translates to:
  /// **'Articulações Mais Afetadas'**
  String get osteoarthritisMostAffected;

  /// No description provided for @osteoarthritisMostAffectedText.
  ///
  /// In pt_BR, this message translates to:
  /// **'• Joelhos\n• Quadris\n• Mãos e dedos\n• Coluna vertebral\n• Dedos dos pés'**
  String get osteoarthritisMostAffectedText;

  /// No description provided for @osteoarthritisHighlight.
  ///
  /// In pt_BR, this message translates to:
  /// **'Embora não tenha cura, a osteoartrite pode ser gerenciada com tratamento adequado, exercícios e mudanças no estilo de vida.'**
  String get osteoarthritisHighlight;

  /// No description provided for @nutritionImportance.
  ///
  /// In pt_BR, this message translates to:
  /// **'Importância da Nutrição'**
  String get nutritionImportance;

  /// No description provided for @nutritionImportanceText.
  ///
  /// In pt_BR, this message translates to:
  /// **'Uma dieta equilibrada desempenha papel fundamental na saúde das articulações. Os alimentos certos podem ajudar a reduzir inflamação, fortalecer ossos e cartilagens, e controlar o peso corporal.'**
  String get nutritionImportanceText;

  /// No description provided for @nutritionRecommendedFoods.
  ///
  /// In pt_BR, this message translates to:
  /// **'Alimentos Recomendados'**
  String get nutritionRecommendedFoods;

  /// No description provided for @nutritionRecommendedFoodsText.
  ///
  /// In pt_BR, this message translates to:
  /// **'• Peixes ricos em ômega-3 (salmão, sardinha)\n• Frutas vermelhas e cítricas\n• Vegetais verde-escuros\n• Nozes e sementes\n• Azeite de oliva extravirgem\n• Alimentos ricos em vitamina D\n• Chá verde\n• Gengibre e cúrcuma'**
  String get nutritionRecommendedFoodsText;

  /// No description provided for @nutritionFoodsToAvoid.
  ///
  /// In pt_BR, this message translates to:
  /// **'Alimentos a Evitar'**
  String get nutritionFoodsToAvoid;

  /// No description provided for @nutritionFoodsToAvoidText.
  ///
  /// In pt_BR, this message translates to:
  /// **'• Açúcares refinados\n• Alimentos processados\n• Gorduras trans\n• Excesso de sal\n• Carnes vermelhas em excesso\n• Bebidas açucaradas'**
  String get nutritionFoodsToAvoidText;

  /// No description provided for @nutritionHydration.
  ///
  /// In pt_BR, this message translates to:
  /// **'Hidratação'**
  String get nutritionHydration;

  /// No description provided for @nutritionHydrationText.
  ///
  /// In pt_BR, this message translates to:
  /// **'Beber água suficiente é essencial para manter as articulações lubrificadas. A cartilagem contém cerca de 80% de água, e a desidratação pode aumentar o atrito nas articulações.'**
  String get nutritionHydrationText;

  /// No description provided for @nutritionSupplements.
  ///
  /// In pt_BR, this message translates to:
  /// **'Suplementos Úteis'**
  String get nutritionSupplements;

  /// No description provided for @nutritionSupplementsText.
  ///
  /// In pt_BR, this message translates to:
  /// **'• Glucosamina e condroitina\n• Colágeno tipo II\n• Vitamina D e cálcio\n• Ômega-3\n• Vitamina C\n\nConsulte sempre um profissional de saúde antes de iniciar qualquer suplementação.'**
  String get nutritionSupplementsText;

  /// No description provided for @nutritionHighlight.
  ///
  /// In pt_BR, this message translates to:
  /// **'Manter um peso saudável reduz a carga nas articulações e pode diminuir significativamente a dor.'**
  String get nutritionHighlight;

  /// No description provided for @exerciseBenefits.
  ///
  /// In pt_BR, this message translates to:
  /// **'Benefícios do Exercício'**
  String get exerciseBenefits;

  /// No description provided for @exerciseBenefitsText.
  ///
  /// In pt_BR, this message translates to:
  /// **'O exercício regular é fundamental para gerenciar a osteoartrite. Ele ajuda a fortalecer os músculos ao redor das articulações, manter a flexibilidade, reduzir a dor e melhorar o humor.'**
  String get exerciseBenefitsText;

  /// No description provided for @exerciseRecommendedTypes.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tipos de Exercícios Recomendados'**
  String get exerciseRecommendedTypes;

  /// No description provided for @exerciseRecommendedTypesText.
  ///
  /// In pt_BR, this message translates to:
  /// **'• Exercícios aeróbicos de baixo impacto (caminhada, natação, ciclismo)\n• Exercícios de fortalecimento muscular\n• Alongamentos e exercícios de flexibilidade\n• Exercícios de equilíbrio\n• Atividades aquáticas\n• Tai Chi e Yoga adaptados'**
  String get exerciseRecommendedTypesText;

  /// No description provided for @exerciseRecommendedFrequency.
  ///
  /// In pt_BR, this message translates to:
  /// **'Frequência Recomendada'**
  String get exerciseRecommendedFrequency;

  /// No description provided for @exerciseRecommendedFrequencyText.
  ///
  /// In pt_BR, this message translates to:
  /// **'• Aeróbico: 30 minutos, 5 dias por semana\n• Fortalecimento: 2-3 vezes por semana\n• Flexibilidade: Diariamente\n• Sempre respeite seus limites e descanse quando necessário'**
  String get exerciseRecommendedFrequencyText;

  /// No description provided for @exerciseTipsToStart.
  ///
  /// In pt_BR, this message translates to:
  /// **'Dicas para Começar'**
  String get exerciseTipsToStart;

  /// No description provided for @exerciseTipsToStartText.
  ///
  /// In pt_BR, this message translates to:
  /// **'• Comece devagar e aumente gradualmente\n• Aqueça antes e alongue depois\n• Escolha atividades de baixo impacto\n• Use calçados adequados\n• Ouça seu corpo e pare se sentir dor\n• Mantenha-se consistente'**
  String get exerciseTipsToStartText;

  /// No description provided for @exerciseWhenToAvoid.
  ///
  /// In pt_BR, this message translates to:
  /// **'Quando Evitar Exercícios'**
  String get exerciseWhenToAvoid;

  /// No description provided for @exerciseWhenToAvoidText.
  ///
  /// In pt_BR, this message translates to:
  /// **'• Durante crises de inflamação aguda\n• Se houver dor intensa\n• Após lesões não tratadas\n• Sempre consulte seu médico antes de iniciar um novo programa de exercícios'**
  String get exerciseWhenToAvoidText;

  /// No description provided for @exerciseHighlight.
  ///
  /// In pt_BR, this message translates to:
  /// **'O movimento é essencial, mas é importante encontrar o equilíbrio certo. Nem muito pouco, nem demais.'**
  String get exerciseHighlight;

  /// No description provided for @learnMore.
  ///
  /// In pt_BR, this message translates to:
  /// **'Saiba Mais'**
  String get learnMore;

  /// No description provided for @articles.
  ///
  /// In pt_BR, this message translates to:
  /// **'Artigos'**
  String get articles;

  /// No description provided for @videos.
  ///
  /// In pt_BR, this message translates to:
  /// **'Vídeos'**
  String get videos;

  /// No description provided for @remindersTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Lembretes'**
  String get remindersTitle;

  /// No description provided for @remindersSubtitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Não esqueça seus cuidados'**
  String get remindersSubtitle;

  /// No description provided for @addReminder.
  ///
  /// In pt_BR, this message translates to:
  /// **'Adicionar Lembrete'**
  String get addReminder;

  /// No description provided for @editReminder.
  ///
  /// In pt_BR, this message translates to:
  /// **'Editar Lembrete'**
  String get editReminder;

  /// No description provided for @deleteReminder.
  ///
  /// In pt_BR, this message translates to:
  /// **'Excluir Lembrete'**
  String get deleteReminder;

  /// No description provided for @deleteReminderConfirmation.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tem certeza que deseja excluir este lembrete?'**
  String get deleteReminderConfirmation;

  /// No description provided for @noReminders.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nenhum lembrete criado'**
  String get noReminders;

  /// No description provided for @noRemindersDescription.
  ///
  /// In pt_BR, this message translates to:
  /// **'Toque no botão + para criar'**
  String get noRemindersDescription;

  /// No description provided for @reminderTime.
  ///
  /// In pt_BR, this message translates to:
  /// **'Horário'**
  String get reminderTime;

  /// No description provided for @reminderRepeat.
  ///
  /// In pt_BR, this message translates to:
  /// **'Repetir'**
  String get reminderRepeat;

  /// No description provided for @reminderDaily.
  ///
  /// In pt_BR, this message translates to:
  /// **'Diário'**
  String get reminderDaily;

  /// No description provided for @reminderWeekdays.
  ///
  /// In pt_BR, this message translates to:
  /// **'Dias úteis'**
  String get reminderWeekdays;

  /// No description provided for @reminderWeekends.
  ///
  /// In pt_BR, this message translates to:
  /// **'Fins de semana'**
  String get reminderWeekends;

  /// No description provided for @reminderCustom.
  ///
  /// In pt_BR, this message translates to:
  /// **'Personalizado'**
  String get reminderCustom;

  /// No description provided for @reminderWeekly.
  ///
  /// In pt_BR, this message translates to:
  /// **'Semanalmente'**
  String get reminderWeekly;

  /// No description provided for @reminderMonthly.
  ///
  /// In pt_BR, this message translates to:
  /// **'Mensalmente'**
  String get reminderMonthly;

  /// No description provided for @reminderTypeExercise.
  ///
  /// In pt_BR, this message translates to:
  /// **'Exercício'**
  String get reminderTypeExercise;

  /// No description provided for @reminderTypeMedication.
  ///
  /// In pt_BR, this message translates to:
  /// **'Medicação'**
  String get reminderTypeMedication;

  /// No description provided for @reminderTypeAppointment.
  ///
  /// In pt_BR, this message translates to:
  /// **'Consulta'**
  String get reminderTypeAppointment;

  /// No description provided for @reminderTypePractice.
  ///
  /// In pt_BR, this message translates to:
  /// **'Prática'**
  String get reminderTypePractice;

  /// No description provided for @reminderTypeHydration.
  ///
  /// In pt_BR, this message translates to:
  /// **'Hidratação'**
  String get reminderTypeHydration;

  /// No description provided for @reminderTypeDiet.
  ///
  /// In pt_BR, this message translates to:
  /// **'Dieta'**
  String get reminderTypeDiet;

  /// No description provided for @reminderTypeLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Lembrete'**
  String get reminderTypeLabel;

  /// No description provided for @reminderTypeHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tipo de lembrete'**
  String get reminderTypeHint;

  /// No description provided for @reminderTitlePlaceholder.
  ///
  /// In pt_BR, this message translates to:
  /// **'Título do lembrete'**
  String get reminderTitlePlaceholder;

  /// No description provided for @reminderDescriptionPlaceholder.
  ///
  /// In pt_BR, this message translates to:
  /// **'Descrição do lembrete'**
  String get reminderDescriptionPlaceholder;

  /// No description provided for @reminderTimeHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Horário (ex: 08:00)'**
  String get reminderTimeHint;

  /// No description provided for @reminderFrequencyHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Frequência'**
  String get reminderFrequencyHint;

  /// No description provided for @createReminder.
  ///
  /// In pt_BR, this message translates to:
  /// **'Criar Lembrete'**
  String get createReminder;

  /// No description provided for @saveChanges.
  ///
  /// In pt_BR, this message translates to:
  /// **'Salvar Alterações'**
  String get saveChanges;

  /// No description provided for @selectDays.
  ///
  /// In pt_BR, this message translates to:
  /// **'Selecionar Dias'**
  String get selectDays;

  /// No description provided for @monday.
  ///
  /// In pt_BR, this message translates to:
  /// **'Segunda-feira'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In pt_BR, this message translates to:
  /// **'Terça-feira'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In pt_BR, this message translates to:
  /// **'Quarta-feira'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In pt_BR, this message translates to:
  /// **'Quinta-feira'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sexta-feira'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sábado'**
  String get saturday;

  /// No description provided for @sunday.
  ///
  /// In pt_BR, this message translates to:
  /// **'Domingo'**
  String get sunday;

  /// No description provided for @pleaseEnterTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Por favor, insira um título'**
  String get pleaseEnterTitle;

  /// No description provided for @pleaseEnterTime.
  ///
  /// In pt_BR, this message translates to:
  /// **'Por favor, insira um horário'**
  String get pleaseEnterTime;

  /// No description provided for @exampleMorningWalk.
  ///
  /// In pt_BR, this message translates to:
  /// **'Caminhada Matinal'**
  String get exampleMorningWalk;

  /// No description provided for @exampleMorningWalkDesc.
  ///
  /// In pt_BR, this message translates to:
  /// **'Faça 30 minutos de caminhada leve'**
  String get exampleMorningWalkDesc;

  /// No description provided for @exampleTakeMedication.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomar Medicamento'**
  String get exampleTakeMedication;

  /// No description provided for @exampleTakeMedicationDesc.
  ///
  /// In pt_BR, this message translates to:
  /// **'Medicação prescrita pelo médico'**
  String get exampleTakeMedicationDesc;

  /// No description provided for @exampleMedicalAppointment.
  ///
  /// In pt_BR, this message translates to:
  /// **'Consulta Médica'**
  String get exampleMedicalAppointment;

  /// No description provided for @exampleMedicalAppointmentDesc.
  ///
  /// In pt_BR, this message translates to:
  /// **'Lembre-se de levar exames e documentos'**
  String get exampleMedicalAppointmentDesc;

  /// No description provided for @exampleBreathing478.
  ///
  /// In pt_BR, this message translates to:
  /// **'Respiração 4-7-8'**
  String get exampleBreathing478;

  /// No description provided for @exampleBreathing478Desc.
  ///
  /// In pt_BR, this message translates to:
  /// **'Faça 5 minutos de exercícios respiratórios'**
  String get exampleBreathing478Desc;

  /// No description provided for @exampleDrinkWater.
  ///
  /// In pt_BR, this message translates to:
  /// **'Beber Água'**
  String get exampleDrinkWater;

  /// No description provided for @exampleDrinkWaterDesc.
  ///
  /// In pt_BR, this message translates to:
  /// **'Hidrate-se com um copo de água'**
  String get exampleDrinkWaterDesc;

  /// No description provided for @exampleHealthySnack.
  ///
  /// In pt_BR, this message translates to:
  /// **'Lanche Saudável'**
  String get exampleHealthySnack;

  /// No description provided for @exampleHealthySnackDesc.
  ///
  /// In pt_BR, this message translates to:
  /// **'Coma uma fruta ou alimento nutritivo'**
  String get exampleHealthySnackDesc;

  /// No description provided for @settingsTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ajustes'**
  String get settingsTitle;

  /// No description provided for @settingsSubtitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Acessibilidade e preferências'**
  String get settingsSubtitle;

  /// No description provided for @account.
  ///
  /// In pt_BR, this message translates to:
  /// **'Conta'**
  String get account;

  /// No description provided for @accountDescription.
  ///
  /// In pt_BR, this message translates to:
  /// **'Gerencie suas informações pessoais.'**
  String get accountDescription;

  /// No description provided for @accessibility.
  ///
  /// In pt_BR, this message translates to:
  /// **'Acessibilidade'**
  String get accessibility;

  /// No description provided for @accessibilityDescription.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ajuste o aplicativo para melhor atender suas necessidades.'**
  String get accessibilityDescription;

  /// No description provided for @notificationsAndAlerts.
  ///
  /// In pt_BR, this message translates to:
  /// **'Notificações e Alertas'**
  String get notificationsAndAlerts;

  /// No description provided for @notificationsDescription.
  ///
  /// In pt_BR, this message translates to:
  /// **'Configure lembretes para práticas e medicamentos'**
  String get notificationsDescription;

  /// No description provided for @privacyAndSecurity.
  ///
  /// In pt_BR, this message translates to:
  /// **'Privacidade e Segurança'**
  String get privacyAndSecurity;

  /// No description provided for @privacyDescription.
  ///
  /// In pt_BR, this message translates to:
  /// **'Controle de dados e permissões.'**
  String get privacyDescription;

  /// No description provided for @themeAndAppearance.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tema e Aparência'**
  String get themeAndAppearance;

  /// No description provided for @themeDescription.
  ///
  /// In pt_BR, this message translates to:
  /// **'Personalize cores e modo de exibição.'**
  String get themeDescription;

  /// No description provided for @language.
  ///
  /// In pt_BR, this message translates to:
  /// **'Idioma'**
  String get language;

  /// No description provided for @languageDescriptionShort.
  ///
  /// In pt_BR, this message translates to:
  /// **'Selecione o idioma do aplicativo.'**
  String get languageDescriptionShort;

  /// No description provided for @aboutApp.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sobre o Aplicativo'**
  String get aboutApp;

  /// No description provided for @aboutDescription.
  ///
  /// In pt_BR, this message translates to:
  /// **'Informações sobre o aplicativo e a equipe'**
  String get aboutDescription;

  /// No description provided for @theme.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tema'**
  String get theme;

  /// No description provided for @languageSelection.
  ///
  /// In pt_BR, this message translates to:
  /// **'Seleção de Idioma'**
  String get languageSelection;

  /// No description provided for @languageDescription.
  ///
  /// In pt_BR, this message translates to:
  /// **'Você pode alterar o idioma de sua preferência'**
  String get languageDescription;

  /// No description provided for @themeLight.
  ///
  /// In pt_BR, this message translates to:
  /// **'Claro'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In pt_BR, this message translates to:
  /// **'Escuro'**
  String get themeDark;

  /// No description provided for @themeSystem.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sistema'**
  String get themeSystem;

  /// No description provided for @notifications.
  ///
  /// In pt_BR, this message translates to:
  /// **'Notificações'**
  String get notifications;

  /// No description provided for @privacy.
  ///
  /// In pt_BR, this message translates to:
  /// **'Privacidade'**
  String get privacy;

  /// No description provided for @about.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sobre'**
  String get about;

  /// No description provided for @version.
  ///
  /// In pt_BR, this message translates to:
  /// **'Versão'**
  String get version;

  /// No description provided for @logout.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sair'**
  String get logout;

  /// No description provided for @logoutConfirmTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sair da sua conta?'**
  String get logoutConfirmTitle;

  /// No description provided for @portuguese.
  ///
  /// In pt_BR, this message translates to:
  /// **'Português'**
  String get portuguese;

  /// No description provided for @english.
  ///
  /// In pt_BR, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @spanish.
  ///
  /// In pt_BR, this message translates to:
  /// **'Español'**
  String get spanish;

  /// No description provided for @brazil.
  ///
  /// In pt_BR, this message translates to:
  /// **'Brasil'**
  String get brazil;

  /// No description provided for @unitedStates.
  ///
  /// In pt_BR, this message translates to:
  /// **'Estados Unidos'**
  String get unitedStates;

  /// No description provided for @spain.
  ///
  /// In pt_BR, this message translates to:
  /// **'Espanha'**
  String get spain;

  /// No description provided for @languageApplied.
  ///
  /// In pt_BR, this message translates to:
  /// **'Idioma {language} aplicado'**
  String languageApplied(String language);

  /// No description provided for @languageNotAvailable.
  ///
  /// In pt_BR, this message translates to:
  /// **'{language} - Não está disponível no momento.'**
  String languageNotAvailable(String language);

  /// No description provided for @errorRequired.
  ///
  /// In pt_BR, this message translates to:
  /// **'Campo obrigatório'**
  String get errorRequired;

  /// No description provided for @errorInvalidEmail.
  ///
  /// In pt_BR, this message translates to:
  /// **'E-mail inválido'**
  String get errorInvalidEmail;

  /// No description provided for @errorPasswordMismatch.
  ///
  /// In pt_BR, this message translates to:
  /// **'As senhas não coincidem'**
  String get errorPasswordMismatch;

  /// No description provided for @errorInvalidDate.
  ///
  /// In pt_BR, this message translates to:
  /// **'Data inválida'**
  String get errorInvalidDate;

  /// No description provided for @errorFillAllFields.
  ///
  /// In pt_BR, this message translates to:
  /// **'Por favor, preencha todos os campos'**
  String get errorFillAllFields;

  /// No description provided for @errorSelectOption.
  ///
  /// In pt_BR, this message translates to:
  /// **'Por favor, selecione uma opção'**
  String get errorSelectOption;

  /// No description provided for @successSaved.
  ///
  /// In pt_BR, this message translates to:
  /// **'Salvo com sucesso!'**
  String get successSaved;

  /// No description provided for @successRegistrationComplete.
  ///
  /// In pt_BR, this message translates to:
  /// **'Cadastro finalizado com sucesso!'**
  String get successRegistrationComplete;

  /// No description provided for @successPreferencesSaved.
  ///
  /// In pt_BR, this message translates to:
  /// **'Preferências salvas com sucesso!'**
  String get successPreferencesSaved;

  /// No description provided for @successLanguageChanged.
  ///
  /// In pt_BR, this message translates to:
  /// **'Idioma alterado com sucesso!'**
  String get successLanguageChanged;

  /// No description provided for @accessibilityPreferences.
  ///
  /// In pt_BR, this message translates to:
  /// **'Preferências de Acessibilidade'**
  String get accessibilityPreferences;

  /// No description provided for @adjustInterfaceForNeeds.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ajuste a interface para melhor atender suas necessidades.'**
  String get adjustInterfaceForNeeds;

  /// No description provided for @fontSizeLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tamanho da Fonte'**
  String get fontSizeLabel;

  /// No description provided for @fontSizeWith.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tamanho da Fonte: {size}'**
  String fontSizeWith(String size);

  /// No description provided for @previewText.
  ///
  /// In pt_BR, this message translates to:
  /// **'Bem vindo ao CuidaDor!\nCriado por Luis Fernando e Kaue Müller'**
  String get previewText;

  /// No description provided for @displayMode.
  ///
  /// In pt_BR, this message translates to:
  /// **'Modo de Exibição'**
  String get displayMode;

  /// No description provided for @displayModeDescription.
  ///
  /// In pt_BR, this message translates to:
  /// **'Escolha entre o modo claro, escuro ou automático para melhor conforto visual'**
  String get displayModeDescription;

  /// No description provided for @lightMode.
  ///
  /// In pt_BR, this message translates to:
  /// **'Modo Claro'**
  String get lightMode;

  /// No description provided for @lightModeDescription.
  ///
  /// In pt_BR, this message translates to:
  /// **'Interface clara, melhor para ambientes bem iluminados'**
  String get lightModeDescription;

  /// No description provided for @darkMode.
  ///
  /// In pt_BR, this message translates to:
  /// **'Modo Escuro'**
  String get darkMode;

  /// No description provided for @darkModeDescription.
  ///
  /// In pt_BR, this message translates to:
  /// **'Interface escura, ideal para ambientes com pouca luz'**
  String get darkModeDescription;

  /// No description provided for @automaticMode.
  ///
  /// In pt_BR, this message translates to:
  /// **'Automático'**
  String get automaticMode;

  /// No description provided for @automaticModeDescription.
  ///
  /// In pt_BR, this message translates to:
  /// **'Alterna entre claro e escuro baseado nas configurações do sistema'**
  String get automaticModeDescription;

  /// No description provided for @lightModeActivated.
  ///
  /// In pt_BR, this message translates to:
  /// **'Modo Claro ativado'**
  String get lightModeActivated;

  /// No description provided for @darkModeActivated.
  ///
  /// In pt_BR, this message translates to:
  /// **'Modo Escuro ativado'**
  String get darkModeActivated;

  /// No description provided for @systemThemeActivated.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tema do Sistema ativado'**
  String get systemThemeActivated;

  /// No description provided for @personalInformation.
  ///
  /// In pt_BR, this message translates to:
  /// **'Informações Pessoais'**
  String get personalInformation;

  /// No description provided for @personalInfoDescription.
  ///
  /// In pt_BR, this message translates to:
  /// **'Gerencie seus dados pessoais e de contato'**
  String get personalInfoDescription;

  /// No description provided for @name.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nome'**
  String get name;

  /// No description provided for @phone.
  ///
  /// In pt_BR, this message translates to:
  /// **'Telefone'**
  String get phone;

  /// No description provided for @healthData.
  ///
  /// In pt_BR, this message translates to:
  /// **'Dados de Saúde'**
  String get healthData;

  /// No description provided for @healthDataInfo.
  ///
  /// In pt_BR, this message translates to:
  /// **'Gerencie informações sobre sua saúde'**
  String get healthDataInfo;

  /// No description provided for @securityAndPrivacy.
  ///
  /// In pt_BR, this message translates to:
  /// **'Segurança e Privacidade'**
  String get securityAndPrivacy;

  /// No description provided for @securityDescription.
  ///
  /// In pt_BR, this message translates to:
  /// **'Altere sua senha ou exclua sua conta'**
  String get securityDescription;

  /// No description provided for @changePassword.
  ///
  /// In pt_BR, this message translates to:
  /// **'Alterar senha'**
  String get changePassword;

  /// No description provided for @deleteMyAccount.
  ///
  /// In pt_BR, this message translates to:
  /// **'Excluir minha conta'**
  String get deleteMyAccount;

  /// No description provided for @notInformed.
  ///
  /// In pt_BR, this message translates to:
  /// **'Não informado'**
  String get notInformed;

  /// No description provided for @noneSelected.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nenhuma'**
  String get noneSelected;

  /// No description provided for @editName.
  ///
  /// In pt_BR, this message translates to:
  /// **'Editar Nome'**
  String get editName;

  /// No description provided for @editNameDescription.
  ///
  /// In pt_BR, this message translates to:
  /// **'Atualize seu nome como aparece no aplicativo'**
  String get editNameDescription;

  /// No description provided for @nameUpdatedSuccess.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nome atualizado com sucesso!'**
  String get nameUpdatedSuccess;

  /// No description provided for @editBirthDate.
  ///
  /// In pt_BR, this message translates to:
  /// **'Editar Data de Nascimento'**
  String get editBirthDate;

  /// No description provided for @editBirthDateDescription.
  ///
  /// In pt_BR, this message translates to:
  /// **'Atualize sua data de nascimento'**
  String get editBirthDateDescription;

  /// No description provided for @currentBirthDate.
  ///
  /// In pt_BR, this message translates to:
  /// **'Data de Nascimento Atual'**
  String get currentBirthDate;

  /// No description provided for @newBirthDate.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nova Data de Nascimento'**
  String get newBirthDate;

  /// No description provided for @selectDate.
  ///
  /// In pt_BR, this message translates to:
  /// **'Selecionar Data'**
  String get selectDate;

  /// No description provided for @birthDateUpdatedSuccess.
  ///
  /// In pt_BR, this message translates to:
  /// **'Data de nascimento atualizada com sucesso!'**
  String get birthDateUpdatedSuccess;

  /// No description provided for @editGender.
  ///
  /// In pt_BR, this message translates to:
  /// **'Editar Gênero'**
  String get editGender;

  /// No description provided for @editGenderDescription.
  ///
  /// In pt_BR, this message translates to:
  /// **'Atualize seu gênero'**
  String get editGenderDescription;

  /// No description provided for @currentGender.
  ///
  /// In pt_BR, this message translates to:
  /// **'Gênero Atual'**
  String get currentGender;

  /// No description provided for @selectNewGender.
  ///
  /// In pt_BR, this message translates to:
  /// **'Selecionar Novo Gênero'**
  String get selectNewGender;

  /// No description provided for @genderUpdatedSuccess.
  ///
  /// In pt_BR, this message translates to:
  /// **'Gênero atualizado com sucesso!'**
  String get genderUpdatedSuccess;

  /// No description provided for @editPhone.
  ///
  /// In pt_BR, this message translates to:
  /// **'Editar Telefone'**
  String get editPhone;

  /// No description provided for @editPhoneDescription.
  ///
  /// In pt_BR, this message translates to:
  /// **'Atualize seu número de telefone'**
  String get editPhoneDescription;

  /// No description provided for @confirmWithPassword.
  ///
  /// In pt_BR, this message translates to:
  /// **'Confirme com sua senha'**
  String get confirmWithPassword;

  /// No description provided for @currentPassword.
  ///
  /// In pt_BR, this message translates to:
  /// **'Senha Atual'**
  String get currentPassword;

  /// No description provided for @phoneUpdatedSuccess.
  ///
  /// In pt_BR, this message translates to:
  /// **'Telefone atualizado com sucesso!'**
  String get phoneUpdatedSuccess;

  /// No description provided for @editEmail.
  ///
  /// In pt_BR, this message translates to:
  /// **'Editar E-mail'**
  String get editEmail;

  /// No description provided for @editEmailDescription.
  ///
  /// In pt_BR, this message translates to:
  /// **'Atualize seu endereço de e-mail'**
  String get editEmailDescription;

  /// No description provided for @emailUpdatedSuccess.
  ///
  /// In pt_BR, this message translates to:
  /// **'Email atualizado com sucesso!'**
  String get emailUpdatedSuccess;

  /// No description provided for @changePasswordTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Alterar Senha'**
  String get changePasswordTitle;

  /// No description provided for @changePasswordDescription.
  ///
  /// In pt_BR, this message translates to:
  /// **'Crie uma nova senha para sua conta'**
  String get changePasswordDescription;

  /// No description provided for @newPassword.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nova Senha'**
  String get newPassword;

  /// No description provided for @confirmNewPassword.
  ///
  /// In pt_BR, this message translates to:
  /// **'Confirmar Nova Senha'**
  String get confirmNewPassword;

  /// No description provided for @passwordUpdatedSuccess.
  ///
  /// In pt_BR, this message translates to:
  /// **'Senha atualizada com sucesso!'**
  String get passwordUpdatedSuccess;

  /// No description provided for @passwordRequirements.
  ///
  /// In pt_BR, this message translates to:
  /// **'A senha deve ter pelo menos 6 caracteres'**
  String get passwordRequirements;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In pt_BR, this message translates to:
  /// **'As senhas não coincidem'**
  String get passwordsDoNotMatch;

  /// No description provided for @currentPasswordRequired.
  ///
  /// In pt_BR, this message translates to:
  /// **'Senha atual obrigatória'**
  String get currentPasswordRequired;

  /// No description provided for @newPasswordRequired.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nova senha obrigatória'**
  String get newPasswordRequired;

  /// No description provided for @editDiagnosis.
  ///
  /// In pt_BR, this message translates to:
  /// **'Editar Diagnóstico'**
  String get editDiagnosis;

  /// No description provided for @editDiagnosisDescription.
  ///
  /// In pt_BR, this message translates to:
  /// **'Atualize seu diagnóstico principal'**
  String get editDiagnosisDescription;

  /// No description provided for @currentDiagnosis.
  ///
  /// In pt_BR, this message translates to:
  /// **'Diagnóstico Atual'**
  String get currentDiagnosis;

  /// No description provided for @selectNewDiagnosis.
  ///
  /// In pt_BR, this message translates to:
  /// **'Selecione Novo Diagnóstico'**
  String get selectNewDiagnosis;

  /// No description provided for @diagnosisUpdatedSuccess.
  ///
  /// In pt_BR, this message translates to:
  /// **'Diagnóstico principal atualizado com sucesso!'**
  String get diagnosisUpdatedSuccess;

  /// No description provided for @specifyNewDiagnosis.
  ///
  /// In pt_BR, this message translates to:
  /// **'Especifique o diagnóstico'**
  String get specifyNewDiagnosis;

  /// No description provided for @editComorbidities.
  ///
  /// In pt_BR, this message translates to:
  /// **'Editar Comorbidades'**
  String get editComorbidities;

  /// No description provided for @editComorbiditiesDescription.
  ///
  /// In pt_BR, this message translates to:
  /// **'Atualize suas comorbidades'**
  String get editComorbiditiesDescription;

  /// No description provided for @currentComorbidities.
  ///
  /// In pt_BR, this message translates to:
  /// **'Comorbidades Atuais'**
  String get currentComorbidities;

  /// No description provided for @selectComorbidities.
  ///
  /// In pt_BR, this message translates to:
  /// **'Selecione as Comorbidades'**
  String get selectComorbidities;

  /// No description provided for @selectAllThatApply.
  ///
  /// In pt_BR, this message translates to:
  /// **'Selecione todas que se aplicam'**
  String get selectAllThatApply;

  /// No description provided for @comorbiditiesUpdatedSuccess.
  ///
  /// In pt_BR, this message translates to:
  /// **'Comorbidades atualizadas com sucesso!'**
  String get comorbiditiesUpdatedSuccess;

  /// No description provided for @notificationsAndReminders.
  ///
  /// In pt_BR, this message translates to:
  /// **'Notificações e Lembretes'**
  String get notificationsAndReminders;

  /// No description provided for @practiceReminders.
  ///
  /// In pt_BR, this message translates to:
  /// **'Lembretes de Práticas'**
  String get practiceReminders;

  /// No description provided for @practiceRemindersDescription.
  ///
  /// In pt_BR, this message translates to:
  /// **'Receba lembretes para fazer suas práticas de bem-estar'**
  String get practiceRemindersDescription;

  /// No description provided for @medicationReminders.
  ///
  /// In pt_BR, this message translates to:
  /// **'Lembretes de Medicamentos'**
  String get medicationReminders;

  /// No description provided for @medicationRemindersDescription.
  ///
  /// In pt_BR, this message translates to:
  /// **'Receba lembretes para tomar seus medicamentos'**
  String get medicationRemindersDescription;

  /// No description provided for @painReminders.
  ///
  /// In pt_BR, this message translates to:
  /// **'Lembretes de Registro de Dor'**
  String get painReminders;

  /// No description provided for @painRemindersDescription.
  ///
  /// In pt_BR, this message translates to:
  /// **'Seja lembrado de registrar seus níveis de dor'**
  String get painRemindersDescription;

  /// No description provided for @reminderTimes.
  ///
  /// In pt_BR, this message translates to:
  /// **'Horários dos Lembretes'**
  String get reminderTimes;

  /// No description provided for @reminderTimesDescription.
  ///
  /// In pt_BR, this message translates to:
  /// **'Configure os horários em que deseja receber lembretes'**
  String get reminderTimesDescription;

  /// No description provided for @morning.
  ///
  /// In pt_BR, this message translates to:
  /// **'Manhã'**
  String get morning;

  /// No description provided for @afternoon.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tarde'**
  String get afternoon;

  /// No description provided for @evening.
  ///
  /// In pt_BR, this message translates to:
  /// **'Noite'**
  String get evening;

  /// No description provided for @notificationSound.
  ///
  /// In pt_BR, this message translates to:
  /// **'Som de Notificação'**
  String get notificationSound;

  /// No description provided for @notificationSoundDescription.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ative ou desative o som das notificações'**
  String get notificationSoundDescription;

  /// No description provided for @vibration.
  ///
  /// In pt_BR, this message translates to:
  /// **'Vibração'**
  String get vibration;

  /// No description provided for @vibrationDescription.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ative ou desative a vibração nas notificações'**
  String get vibrationDescription;

  /// No description provided for @changesSuccessfullySaved.
  ///
  /// In pt_BR, this message translates to:
  /// **'Alterações salvas com sucesso!'**
  String get changesSuccessfullySaved;

  /// No description provided for @dataManagement.
  ///
  /// In pt_BR, this message translates to:
  /// **'Gerenciamento de Dados'**
  String get dataManagement;

  /// No description provided for @dataManagementDescription.
  ///
  /// In pt_BR, this message translates to:
  /// **'Controle suas informações e como são usadas'**
  String get dataManagementDescription;

  /// No description provided for @viewPrivacyPolicy.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ver Política de Privacidade'**
  String get viewPrivacyPolicy;

  /// No description provided for @openingPrivacyPolicy.
  ///
  /// In pt_BR, this message translates to:
  /// **'Abrindo Política de Privacidade...'**
  String get openingPrivacyPolicy;

  /// No description provided for @dataSharing.
  ///
  /// In pt_BR, this message translates to:
  /// **'Compartilhamento de Dados'**
  String get dataSharing;

  /// No description provided for @dataSharingDescription.
  ///
  /// In pt_BR, this message translates to:
  /// **'Controle como seus dados são compartilhados'**
  String get dataSharingDescription;

  /// No description provided for @shareAnonymousData.
  ///
  /// In pt_BR, this message translates to:
  /// **'Compartilhar dados anônimos para pesquisa'**
  String get shareAnonymousData;

  /// No description provided for @shareAnonymousDataDescription.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ajude a melhorar o aplicativo compartilhando dados anônimos de uso'**
  String get shareAnonymousDataDescription;

  /// No description provided for @shareHealthProfessionals.
  ///
  /// In pt_BR, this message translates to:
  /// **'Compartilhar com profissionais de saúde'**
  String get shareHealthProfessionals;

  /// No description provided for @shareHealthProfessionalsDescription.
  ///
  /// In pt_BR, this message translates to:
  /// **'Permita que profissionais de saúde autorizados acessem seus dados'**
  String get shareHealthProfessionalsDescription;

  /// No description provided for @dataExport.
  ///
  /// In pt_BR, this message translates to:
  /// **'Exportação de Dados'**
  String get dataExport;

  /// No description provided for @dataExportDescription.
  ///
  /// In pt_BR, this message translates to:
  /// **'Baixe uma cópia dos seus dados'**
  String get dataExportDescription;

  /// No description provided for @exportMyData.
  ///
  /// In pt_BR, this message translates to:
  /// **'Exportar Meus Dados'**
  String get exportMyData;

  /// No description provided for @exportDataDescription.
  ///
  /// In pt_BR, this message translates to:
  /// **'Receba um arquivo com todas as suas informações'**
  String get exportDataDescription;

  /// No description provided for @accountDeletion.
  ///
  /// In pt_BR, this message translates to:
  /// **'Exclusão de Conta'**
  String get accountDeletion;

  /// No description provided for @accountDeletionWarning.
  ///
  /// In pt_BR, this message translates to:
  /// **'Esta ação é permanente e não pode ser desfeita. Todos os seus dados serão excluídos.'**
  String get accountDeletionWarning;

  /// No description provided for @requestAccountDeletion.
  ///
  /// In pt_BR, this message translates to:
  /// **'Solicitar Exclusão de Conta'**
  String get requestAccountDeletion;

  /// No description provided for @aboutTheApp.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sobre o CuidaDor'**
  String get aboutTheApp;

  /// No description provided for @appVersion.
  ///
  /// In pt_BR, this message translates to:
  /// **'Versão do Aplicativo'**
  String get appVersion;

  /// No description provided for @developedBy.
  ///
  /// In pt_BR, this message translates to:
  /// **'Desenvolvido por'**
  String get developedBy;

  /// No description provided for @aboutAppInfo.
  ///
  /// In pt_BR, this message translates to:
  /// **'Informações do Aplicativo'**
  String get aboutAppInfo;

  /// No description provided for @aboutAppDescription.
  ///
  /// In pt_BR, this message translates to:
  /// **'Conheça mais sobre o CuidaDor'**
  String get aboutAppDescription;

  /// No description provided for @teamAndDevelopment.
  ///
  /// In pt_BR, this message translates to:
  /// **'Equipe e Desenvolvimento'**
  String get teamAndDevelopment;

  /// No description provided for @teamDescription.
  ///
  /// In pt_BR, this message translates to:
  /// **'Conheça quem desenvolveu o aplicativo'**
  String get teamDescription;

  /// No description provided for @termsAndPrivacy.
  ///
  /// In pt_BR, this message translates to:
  /// **'Termos e Política de Privacidade'**
  String get termsAndPrivacy;

  /// No description provided for @termsDescription.
  ///
  /// In pt_BR, this message translates to:
  /// **'Leia nossos termos de uso e política'**
  String get termsDescription;

  /// No description provided for @feedbackTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Feedback'**
  String get feedbackTitle;

  /// No description provided for @feedbackDescription.
  ///
  /// In pt_BR, this message translates to:
  /// **'Envie suas sugestões e comentários'**
  String get feedbackDescription;

  /// No description provided for @sendFeedback.
  ///
  /// In pt_BR, this message translates to:
  /// **'Enviar Feedback'**
  String get sendFeedback;

  /// No description provided for @feedbackSentSuccess.
  ///
  /// In pt_BR, this message translates to:
  /// **'Feedback enviado com sucesso!'**
  String get feedbackSentSuccess;

  /// No description provided for @feedbackFormTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Envie seu Feedback'**
  String get feedbackFormTitle;

  /// No description provided for @feedbackFormDescription.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sua opinião é muito importante para nós! Compartilhe suas ideias, sugestões ou relate problemas.'**
  String get feedbackFormDescription;

  /// No description provided for @nameOptional.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nome (opcional)'**
  String get nameOptional;

  /// No description provided for @emailOptional.
  ///
  /// In pt_BR, this message translates to:
  /// **'E-mail (opcional)'**
  String get emailOptional;

  /// No description provided for @messageRequired.
  ///
  /// In pt_BR, this message translates to:
  /// **'Mensagem *'**
  String get messageRequired;

  /// No description provided for @enterYourMessage.
  ///
  /// In pt_BR, this message translates to:
  /// **'Digite sua mensagem aqui...'**
  String get enterYourMessage;

  /// No description provided for @messageTooShort.
  ///
  /// In pt_BR, this message translates to:
  /// **'A mensagem deve ter pelo menos 10 caracteres'**
  String get messageTooShort;

  /// No description provided for @teamMembers.
  ///
  /// In pt_BR, this message translates to:
  /// **'Membros da Equipe'**
  String get teamMembers;

  /// No description provided for @developers.
  ///
  /// In pt_BR, this message translates to:
  /// **'Desenvolvedores'**
  String get developers;

  /// No description provided for @advisor.
  ///
  /// In pt_BR, this message translates to:
  /// **'Orientador(a)'**
  String get advisor;

  /// No description provided for @university.
  ///
  /// In pt_BR, this message translates to:
  /// **'Universidade'**
  String get university;

  /// No description provided for @course.
  ///
  /// In pt_BR, this message translates to:
  /// **'Curso'**
  String get course;

  /// No description provided for @termsOfUse.
  ///
  /// In pt_BR, this message translates to:
  /// **'Termos de Uso'**
  String get termsOfUse;

  /// No description provided for @privacyPolicy.
  ///
  /// In pt_BR, this message translates to:
  /// **'Política de Privacidade'**
  String get privacyPolicy;

  /// No description provided for @lastUpdated.
  ///
  /// In pt_BR, this message translates to:
  /// **'Última atualização'**
  String get lastUpdated;

  /// No description provided for @deleteAccountDevelopment.
  ///
  /// In pt_BR, this message translates to:
  /// **'Função de exclusão em desenvolvimento'**
  String get deleteAccountDevelopment;

  /// No description provided for @applyLanguage.
  ///
  /// In pt_BR, this message translates to:
  /// **'Aplicar Idioma'**
  String get applyLanguage;

  /// No description provided for @appObjective.
  ///
  /// In pt_BR, this message translates to:
  /// **'Objetivo'**
  String get appObjective;

  /// No description provided for @appObjectiveDescription.
  ///
  /// In pt_BR, this message translates to:
  /// **'O Cuidador App foi desenvolvido para auxiliar cuidadores de idosos no acompanhamento diário de suas atividades, saúde e bem-estar. O aplicativo oferece ferramentas para registro de dor, lembretes de medicamentos, exercícios práticos e orientações educacionais.'**
  String get appObjectiveDescription;

  /// No description provided for @features.
  ///
  /// In pt_BR, this message translates to:
  /// **'Funcionalidades'**
  String get features;

  /// No description provided for @featurePainTracking.
  ///
  /// In pt_BR, this message translates to:
  /// **'Registro e acompanhamento de dor'**
  String get featurePainTracking;

  /// No description provided for @featureReminders.
  ///
  /// In pt_BR, this message translates to:
  /// **'Lembretes de medicamentos e cuidados'**
  String get featureReminders;

  /// No description provided for @featurePractices.
  ///
  /// In pt_BR, this message translates to:
  /// **'Práticas e exercícios guiados'**
  String get featurePractices;

  /// No description provided for @featureEducation.
  ///
  /// In pt_BR, this message translates to:
  /// **'Conteúdo educacional'**
  String get featureEducation;

  /// No description provided for @featureAccessibility.
  ///
  /// In pt_BR, this message translates to:
  /// **'Recursos de acessibilidade'**
  String get featureAccessibility;

  /// No description provided for @luisFernandoRole.
  ///
  /// In pt_BR, this message translates to:
  /// **'Responsável pela gestão do projeto, design e desenvolvimento front-end da aplicação utilizando Flutter.'**
  String get luisFernandoRole;

  /// No description provided for @kaueMullerRole.
  ///
  /// In pt_BR, this message translates to:
  /// **'Responsável pelo desenvolvimento back-end, integração de banco de dados e implementação de APIs'**
  String get kaueMullerRole;

  /// No description provided for @advisorName.
  ///
  /// In pt_BR, this message translates to:
  /// **'Prof.ª Dr.ª Edilaine Cristina da Silva Gherardi'**
  String get advisorName;

  /// No description provided for @advisorRole.
  ///
  /// In pt_BR, this message translates to:
  /// **'Orientadora do projeto de Trabalho de Conclusão de Curso (TCC)'**
  String get advisorRole;

  /// No description provided for @universityName.
  ///
  /// In pt_BR, this message translates to:
  /// **'Universidade Estadual de Londrina'**
  String get universityName;

  /// No description provided for @courseName.
  ///
  /// In pt_BR, this message translates to:
  /// **'Bacharelado em Ciência da Computação'**
  String get courseName;

  /// No description provided for @termsAndPrivacyTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Termos e Privacidade'**
  String get termsAndPrivacyTitle;

  /// No description provided for @termsOfUseTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Termos de Uso'**
  String get termsOfUseTitle;

  /// No description provided for @termsIntro.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ao utilizar este aplicativo, você concorda com os seguintes termos:'**
  String get termsIntro;

  /// No description provided for @termPurposeTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'1. Finalidade'**
  String get termPurposeTitle;

  /// No description provided for @termPurposeDesc.
  ///
  /// In pt_BR, this message translates to:
  /// **'O aplicativo destina-se exclusivamente ao auxílio de cuidadores, não substituindo orientação médica profissional.'**
  String get termPurposeDesc;

  /// No description provided for @termResponsibilityTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'2. Responsabilidade'**
  String get termResponsibilityTitle;

  /// No description provided for @termResponsibilityDesc.
  ///
  /// In pt_BR, this message translates to:
  /// **'As informações registradas são de responsabilidade do usuário. O desenvolvedor não se responsabiliza por decisões tomadas com base nos dados do aplicativo.'**
  String get termResponsibilityDesc;

  /// No description provided for @termProperUseTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'3. Uso Adequado'**
  String get termProperUseTitle;

  /// No description provided for @termProperUseDesc.
  ///
  /// In pt_BR, this message translates to:
  /// **'O aplicativo deve ser utilizado de forma ética e responsável, respeitando as orientações médicas estabelecidas.'**
  String get termProperUseDesc;

  /// No description provided for @privacyPolicyTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Política de Privacidade'**
  String get privacyPolicyTitle;

  /// No description provided for @privacyDataCollectionTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Coleta de Dados'**
  String get privacyDataCollectionTitle;

  /// No description provided for @privacyDataCollectionDesc.
  ///
  /// In pt_BR, this message translates to:
  /// **'Os dados inseridos no aplicativo são armazenados de forma segura e poderão ser sincronizados com um banco de dados para backup e acesso em múltiplos dispositivos.'**
  String get privacyDataCollectionDesc;

  /// No description provided for @privacyDataUsageTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Uso dos Dados'**
  String get privacyDataUsageTitle;

  /// No description provided for @privacyDataUsageDesc.
  ///
  /// In pt_BR, this message translates to:
  /// **'As informações coletadas são utilizadas exclusivamente para o funcionamento das funcionalidades do aplicativo e para fornecer uma melhor experiência ao usuário.'**
  String get privacyDataUsageDesc;

  /// No description provided for @privacySharingTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Compartilhamento'**
  String get privacySharingTitle;

  /// No description provided for @privacySharingDesc.
  ///
  /// In pt_BR, this message translates to:
  /// **'Seus dados pessoais não serão compartilhados com terceiros sem o seu consentimento explícito, exceto quando exigido por lei.'**
  String get privacySharingDesc;

  /// No description provided for @privacySecurityTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Segurança'**
  String get privacySecurityTitle;

  /// No description provided for @privacySecurityDesc.
  ///
  /// In pt_BR, this message translates to:
  /// **'O aplicativo utiliza autenticação por senha para proteger o acesso aos seus dados. Mantenha sua senha segura e não a compartilhe com terceiros.'**
  String get privacySecurityDesc;

  /// No description provided for @questionsOrSuggestionsTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Dúvidas ou Sugestões'**
  String get questionsOrSuggestionsTitle;

  /// No description provided for @questionsOrSuggestionsDesc.
  ///
  /// In pt_BR, this message translates to:
  /// **'Para esclarecimentos sobre os termos de uso ou política de privacidade, utilize a seção de Feedback no menu Sobre.'**
  String get questionsOrSuggestionsDesc;

  /// No description provided for @copyrightText.
  ///
  /// In pt_BR, this message translates to:
  /// **'© Todos os Direitos Reservados - 2025\nDesenvolvido por Luis Fernando Souza Pinto e Kaue Müller'**
  String get copyrightText;

  /// No description provided for @aboutTheProject.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sobre o Projeto'**
  String get aboutTheProject;

  /// No description provided for @projectDescription.
  ///
  /// In pt_BR, this message translates to:
  /// **'Esse projeto foi desenvolvido como trabalho final da disciplina de Desenvolvimento de Aplicativos Móveis, ministrado pelo professor Gilson Augusto Helfer, com o objetivo de apoiar o autocuidado e o manejo da dor em pessoas com osteoartrite. Oferecendo ferramentas para monitoramento da dor, práticas terapêuticas guiadas e conteúdo educativo baseado em evidências científicas.\n\nDesenvolvido com Flutter, o aplicativo oferece uma experiência nativa tanto para Android quanto iOS, garantindo desempenho e usabilidade em diferentes plataformas.'**
  String get projectDescription;

  /// No description provided for @technologiesUsed.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tecnologias Utilizadas'**
  String get technologiesUsed;

  /// No description provided for @yourOpinionMatters.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sua opinião é importante!'**
  String get yourOpinionMatters;

  /// No description provided for @feedbackInstructions.
  ///
  /// In pt_BR, this message translates to:
  /// **'Compartilhe suas sugestões, reporte problemas ou envie elogios. Seu feedback nos ajuda a melhorar o aplicativo.'**
  String get feedbackInstructions;

  /// No description provided for @feedbackType.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tipo de Feedback'**
  String get feedbackType;

  /// No description provided for @suggestion.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sugestão'**
  String get suggestion;

  /// No description provided for @problem.
  ///
  /// In pt_BR, this message translates to:
  /// **'Problema'**
  String get problem;

  /// No description provided for @compliment.
  ///
  /// In pt_BR, this message translates to:
  /// **'Elogio'**
  String get compliment;

  /// No description provided for @yourName.
  ///
  /// In pt_BR, this message translates to:
  /// **'Seu nome'**
  String get yourName;

  /// No description provided for @describeFeedback.
  ///
  /// In pt_BR, this message translates to:
  /// **'Descreva seu feedback aqui...'**
  String get describeFeedback;

  /// No description provided for @feedbackRequired.
  ///
  /// In pt_BR, this message translates to:
  /// **'Por favor, descreva seu feedback'**
  String get feedbackRequired;

  /// No description provided for @feedbackMinLength.
  ///
  /// In pt_BR, this message translates to:
  /// **'A mensagem deve ter pelo menos 10 caracteres'**
  String get feedbackMinLength;

  /// No description provided for @pleaseSelectFeedbackType.
  ///
  /// In pt_BR, this message translates to:
  /// **'Por favor, selecione o tipo de feedback'**
  String get pleaseSelectFeedbackType;

  /// No description provided for @errorSendingFeedback.
  ///
  /// In pt_BR, this message translates to:
  /// **'Erro ao enviar feedback'**
  String get errorSendingFeedback;

  /// No description provided for @adminTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Administrador'**
  String get adminTitle;

  /// No description provided for @manageUsersAndReports.
  ///
  /// In pt_BR, this message translates to:
  /// **'Gerencie usuários e relatórios.'**
  String get manageUsersAndReports;

  /// No description provided for @users.
  ///
  /// In pt_BR, this message translates to:
  /// **'Usuários'**
  String get users;

  /// No description provided for @viewManageUsers.
  ///
  /// In pt_BR, this message translates to:
  /// **'Visualize e gerencie usuários cadastrados.'**
  String get viewManageUsers;

  /// No description provided for @feedback.
  ///
  /// In pt_BR, this message translates to:
  /// **'Feedback'**
  String get feedback;

  /// No description provided for @viewUserFeedback.
  ///
  /// In pt_BR, this message translates to:
  /// **'Visualize o feedback enviado pelos usuários.'**
  String get viewUserFeedback;

  /// No description provided for @reports.
  ///
  /// In pt_BR, this message translates to:
  /// **'Relatórios'**
  String get reports;

  /// No description provided for @exportUserData.
  ///
  /// In pt_BR, this message translates to:
  /// **'Exporte dados dos usuários.'**
  String get exportUserData;

  /// No description provided for @featureAvailableSoon.
  ///
  /// In pt_BR, this message translates to:
  /// **'Funcionalidade disponível em breve'**
  String get featureAvailableSoon;

  /// No description provided for @feedbackListTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Feedback'**
  String get feedbackListTitle;

  /// No description provided for @searchByNameEmailMessage.
  ///
  /// In pt_BR, this message translates to:
  /// **'Buscar por nome, email ou mensagem...'**
  String get searchByNameEmailMessage;

  /// No description provided for @type.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tipo'**
  String get type;

  /// No description provided for @all.
  ///
  /// In pt_BR, this message translates to:
  /// **'Todos'**
  String get all;

  /// No description provided for @feedbacksFound.
  ///
  /// In pt_BR, this message translates to:
  /// **'feedback(s) encontrado(s)'**
  String get feedbacksFound;

  /// No description provided for @tryAgain.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tentar Novamente'**
  String get tryAgain;

  /// No description provided for @noFeedbackFound.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nenhum feedback encontrado.'**
  String get noFeedbackFound;

  /// No description provided for @anonymous.
  ///
  /// In pt_BR, this message translates to:
  /// **'Anônimo'**
  String get anonymous;

  /// No description provided for @emailNotProvided.
  ///
  /// In pt_BR, this message translates to:
  /// **'Email não informado'**
  String get emailNotProvided;

  /// No description provided for @feedbackDetailTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Detalhes do Feedback'**
  String get feedbackDetailTitle;

  /// No description provided for @confirmDelete.
  ///
  /// In pt_BR, this message translates to:
  /// **'Confirmar exclusão'**
  String get confirmDelete;

  /// No description provided for @confirmDeleteFeedback.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tem certeza que deseja excluir este feedback?'**
  String get confirmDeleteFeedback;

  /// No description provided for @feedbackDeletedSuccess.
  ///
  /// In pt_BR, this message translates to:
  /// **'Feedback excluído com sucesso'**
  String get feedbackDeletedSuccess;

  /// No description provided for @errorDeletingFeedback.
  ///
  /// In pt_BR, this message translates to:
  /// **'Erro ao excluir feedback'**
  String get errorDeletingFeedback;

  /// No description provided for @feedbackInfo.
  ///
  /// In pt_BR, this message translates to:
  /// **'Informações do Feedback'**
  String get feedbackInfo;

  /// No description provided for @userInfo.
  ///
  /// In pt_BR, this message translates to:
  /// **'Informações do Usuário'**
  String get userInfo;

  /// No description provided for @submittedBy.
  ///
  /// In pt_BR, this message translates to:
  /// **'Enviado por'**
  String get submittedBy;

  /// No description provided for @userEmail.
  ///
  /// In pt_BR, this message translates to:
  /// **'E-mail do usuário'**
  String get userEmail;

  /// No description provided for @submittedAt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Enviado em'**
  String get submittedAt;

  /// No description provided for @message.
  ///
  /// In pt_BR, this message translates to:
  /// **'Mensagem'**
  String get message;

  /// No description provided for @deleteFeedback.
  ///
  /// In pt_BR, this message translates to:
  /// **'Excluir Feedback'**
  String get deleteFeedback;

  /// No description provided for @noPainLocationIndicated.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nenhum local da dor indicado'**
  String get noPainLocationIndicated;

  /// No description provided for @noPainLocationMessage.
  ///
  /// In pt_BR, this message translates to:
  /// **'Você não indicou nenhum local da dor. Deseja salvar o registro mesmo assim?'**
  String get noPainLocationMessage;

  /// No description provided for @painRecordSavedSuccess.
  ///
  /// In pt_BR, this message translates to:
  /// **'Registro de dor salvo com sucesso!'**
  String get painRecordSavedSuccess;

  /// No description provided for @errorSavingPainRecord.
  ///
  /// In pt_BR, this message translates to:
  /// **'Erro ao salvar registro'**
  String get errorSavingPainRecord;

  /// No description provided for @errorLoadingRecords.
  ///
  /// In pt_BR, this message translates to:
  /// **'Erro ao carregar registros'**
  String get errorLoadingRecords;

  /// No description provided for @noRecordFound.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nenhum registro encontrado'**
  String get noRecordFound;

  /// No description provided for @today.
  ///
  /// In pt_BR, this message translates to:
  /// **'Hoje'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ontem'**
  String get yesterday;

  /// No description provided for @last7Days.
  ///
  /// In pt_BR, this message translates to:
  /// **'Últimos 7 dias'**
  String get last7Days;

  /// No description provided for @last14Days.
  ///
  /// In pt_BR, this message translates to:
  /// **'Últimos 14 dias'**
  String get last14Days;

  /// No description provided for @last30Days.
  ///
  /// In pt_BR, this message translates to:
  /// **'Últimos 30 dias'**
  String get last30Days;

  /// No description provided for @custom.
  ///
  /// In pt_BR, this message translates to:
  /// **'Personalizado'**
  String get custom;

  /// No description provided for @editPainLevel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Editar Nível de Dor'**
  String get editPainLevel;

  /// No description provided for @editAnnotations.
  ///
  /// In pt_BR, this message translates to:
  /// **'Editar Anotações'**
  String get editAnnotations;

  /// No description provided for @deleteRecord.
  ///
  /// In pt_BR, this message translates to:
  /// **'Excluir Registro'**
  String get deleteRecord;

  /// No description provided for @deleteRecordConfirmation.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tem certeza que deseja excluir este registro de dor? Esta ação não pode ser desfeita.'**
  String get deleteRecordConfirmation;

  /// No description provided for @errorUpdating.
  ///
  /// In pt_BR, this message translates to:
  /// **'Erro ao atualizar'**
  String get errorUpdating;

  /// No description provided for @errorDeleting.
  ///
  /// In pt_BR, this message translates to:
  /// **'Erro ao excluir'**
  String get errorDeleting;

  /// No description provided for @painRecordDetails.
  ///
  /// In pt_BR, this message translates to:
  /// **'Detalhes do Registro'**
  String get painRecordDetails;

  /// No description provided for @dataCollectionTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Coleta de Dados'**
  String get dataCollectionTitle;

  /// No description provided for @dataCollectionDescription.
  ///
  /// In pt_BR, this message translates to:
  /// **'Gerencie como deseja compartilhar seus dados de uso da aplicação de acordo com a Lei Geral de Proteção de Dados'**
  String get dataCollectionDescription;

  /// No description provided for @shareMyStatistics.
  ///
  /// In pt_BR, this message translates to:
  /// **'Compartilhar minhas estatísticas'**
  String get shareMyStatistics;

  /// No description provided for @shareMyStatisticsDesc.
  ///
  /// In pt_BR, this message translates to:
  /// **'Seus dados são protegidos e utilizados apenas para os propósitos descritos na política de privacidade.'**
  String get shareMyStatisticsDesc;

  /// No description provided for @shareDiagnosticDataOnly.
  ///
  /// In pt_BR, this message translates to:
  /// **'Compartilhar somente dados de diagnóstico'**
  String get shareDiagnosticDataOnly;

  /// No description provided for @shareDiagnosticDataOnlyDesc.
  ///
  /// In pt_BR, this message translates to:
  /// **'Serão coletados apenas dados do aplicativo para fins de melhoria do aplicativo.'**
  String get shareDiagnosticDataOnlyDesc;

  /// No description provided for @emailPreferences.
  ///
  /// In pt_BR, this message translates to:
  /// **'Preferências de E-mail'**
  String get emailPreferences;

  /// No description provided for @emailPreferencesDesc.
  ///
  /// In pt_BR, this message translates to:
  /// **'Gerencie se deseja receber notificações por e-mail'**
  String get emailPreferencesDesc;

  /// No description provided for @receiveEmailNotifications.
  ///
  /// In pt_BR, this message translates to:
  /// **'Receber notificações por e-mail'**
  String get receiveEmailNotifications;

  /// No description provided for @painPageTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Como você está se sentindo hoje?'**
  String get painPageTitle;

  /// No description provided for @painPageSubtitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Registre seu nível de dor'**
  String get painPageSubtitle;

  /// No description provided for @painNoPain.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sem Dor'**
  String get painNoPain;

  /// No description provided for @painMinimal.
  ///
  /// In pt_BR, this message translates to:
  /// **'Dor Mínima'**
  String get painMinimal;

  /// No description provided for @painMild.
  ///
  /// In pt_BR, this message translates to:
  /// **'Dor Leve'**
  String get painMild;

  /// No description provided for @painModerate.
  ///
  /// In pt_BR, this message translates to:
  /// **'Dor Moderada'**
  String get painModerate;

  /// No description provided for @painSevere.
  ///
  /// In pt_BR, this message translates to:
  /// **'Dor Intensa'**
  String get painSevere;

  /// No description provided for @painUnbearable.
  ///
  /// In pt_BR, this message translates to:
  /// **'Dor Insuportável'**
  String get painUnbearable;

  /// No description provided for @painNoPainDesc.
  ///
  /// In pt_BR, this message translates to:
  /// **'Você está completamente confortável, sem nenhum desconforto'**
  String get painNoPainDesc;

  /// No description provided for @painMinimalDesc.
  ///
  /// In pt_BR, this message translates to:
  /// **'Dor muito leve que você consegue ignorar.\n\nExemplo: Pequena coceira, leve desconforto ao sentar em posição errada.'**
  String get painMinimalDesc;

  /// No description provided for @painMildDesc.
  ///
  /// In pt_BR, this message translates to:
  /// **'Dor perceptível mas não impede suas atividades.\n\nExemplo: Dor de cabeça leve, pequena dor muscular após exercício.\n\nVocê consegue trabalhar e se concentrar normalmente'**
  String get painMildDesc;

  /// No description provided for @painModerateDesc.
  ///
  /// In pt_BR, this message translates to:
  /// **'Dor que interfere nas atividades mas você ainda consegue realizá-las.\n\nExemplo: Dor de dente chata, torção de tornozelo, cólica menstrual moderada,\n\nVocê pode precisar de analgésico simples,\nDificulta concentração em tarefas complexas.'**
  String get painModerateDesc;

  /// No description provided for @painSevereDesc.
  ///
  /// In pt_BR, this message translates to:
  /// **'Dor que domina seus sentidos e limita significativamente suas atividades.\n\nExemplo: Enxaqueca forte, cólica renal, fratura óssea.\n\nVocê não consegue ignorar a dor,\nDificuldade para dormir ou realizar atividades básicas,\nPrecisa de medicação mais forte.'**
  String get painSevereDesc;

  /// No description provided for @painUnbearableDesc.
  ///
  /// In pt_BR, this message translates to:
  /// **'A pior dor imaginável, você não consegue fazer nada além de lidar com ela.\n\nExemplo: Apendicite aguda, trabalho de parto em transição, queimaduras graves.\n\nPode causar choque, náuseas, vômitos.\nRequer atendimento médico imediato. \n\nMuitas pessoas nunca experimentaram esse nível de dor.'**
  String get painUnbearableDesc;

  /// No description provided for @addAnnotation.
  ///
  /// In pt_BR, this message translates to:
  /// **'Adicionar uma anotação'**
  String get addAnnotation;

  /// No description provided for @annotationHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ex.: Dor após a caminhada, degrau a mais...'**
  String get annotationHint;

  /// No description provided for @saveRecord.
  ///
  /// In pt_BR, this message translates to:
  /// **'Salvar Registro'**
  String get saveRecord;

  /// No description provided for @recordSavedSuccess.
  ///
  /// In pt_BR, this message translates to:
  /// **'Registro salvo com sucesso!'**
  String get recordSavedSuccess;

  /// No description provided for @history.
  ///
  /// In pt_BR, this message translates to:
  /// **'Histórico'**
  String get history;

  /// No description provided for @days.
  ///
  /// In pt_BR, this message translates to:
  /// **'dias'**
  String get days;

  /// No description provided for @customPeriod.
  ///
  /// In pt_BR, this message translates to:
  /// **'Personalizado'**
  String get customPeriod;

  /// No description provided for @customPeriodSoon.
  ///
  /// In pt_BR, this message translates to:
  /// **'Seletor de período personalizado em breve'**
  String get customPeriodSoon;

  /// No description provided for @visualizePainPattern.
  ///
  /// In pt_BR, this message translates to:
  /// **'Visualize o padrão da sua dor'**
  String get visualizePainPattern;

  /// No description provided for @chartWillBeDisplayed.
  ///
  /// In pt_BR, this message translates to:
  /// **'Gráfico será exibido aqui'**
  String get chartWillBeDisplayed;

  /// No description provided for @recentHistory.
  ///
  /// In pt_BR, this message translates to:
  /// **'Histórico Recente'**
  String get recentHistory;

  /// No description provided for @basedOnPreviousRecords.
  ///
  /// In pt_BR, this message translates to:
  /// **'Com base em seus registros anteriores'**
  String get basedOnPreviousRecords;

  /// No description provided for @painAfterExercise.
  ///
  /// In pt_BR, this message translates to:
  /// **'Dor após exercício'**
  String get painAfterExercise;

  /// No description provided for @morningStiffness.
  ///
  /// In pt_BR, this message translates to:
  /// **'Rigidez matinal'**
  String get morningStiffness;

  /// No description provided for @moderatePainAfterWalk.
  ///
  /// In pt_BR, this message translates to:
  /// **'Dor moderada após caminhada'**
  String get moderatePainAfterWalk;

  /// No description provided for @selectPainArea.
  ///
  /// In pt_BR, this message translates to:
  /// **'Selecionar área de dor'**
  String get selectPainArea;

  /// No description provided for @confirmSelection.
  ///
  /// In pt_BR, this message translates to:
  /// **'Confirmar Seleção'**
  String get confirmSelection;

  /// No description provided for @head.
  ///
  /// In pt_BR, this message translates to:
  /// **'Cabeça'**
  String get head;

  /// No description provided for @torso.
  ///
  /// In pt_BR, this message translates to:
  /// **'Torso'**
  String get torso;

  /// No description provided for @leftArm.
  ///
  /// In pt_BR, this message translates to:
  /// **'Braço E.'**
  String get leftArm;

  /// No description provided for @rightArm.
  ///
  /// In pt_BR, this message translates to:
  /// **'Braço D.'**
  String get rightArm;

  /// No description provided for @leftHand.
  ///
  /// In pt_BR, this message translates to:
  /// **'Mão E.'**
  String get leftHand;

  /// No description provided for @rightHand.
  ///
  /// In pt_BR, this message translates to:
  /// **'Mão D.'**
  String get rightHand;

  /// No description provided for @leftLeg.
  ///
  /// In pt_BR, this message translates to:
  /// **'Perna E.'**
  String get leftLeg;

  /// No description provided for @rightLeg.
  ///
  /// In pt_BR, this message translates to:
  /// **'Perna D.'**
  String get rightLeg;

  /// No description provided for @leftFoot.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pé E.'**
  String get leftFoot;

  /// No description provided for @rightFoot.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pé D.'**
  String get rightFoot;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'en':
      {
        switch (locale.countryCode) {
          case 'US':
            return AppLocalizationsEnUs();
        }
        break;
      }
    case 'pt':
      {
        switch (locale.countryCode) {
          case 'BR':
            return AppLocalizationsPtBr();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
