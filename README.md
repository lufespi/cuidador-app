# CuidaDor 🩺

[![Flutter](https://img.shields.io/badge/Flutter-3.0%2B-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.0%2B-0175C2?logo=dart)](https://dart.dev)
[![Platform](https://img.shields.io/badge/Platform-Android-green)]()
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

**CuidaDor** é um aplicativo mobile desenvolvido em Flutter para registro e acompanhamento de dores crônicas, oferecendo ferramentas de gestão para pacientes e administradores de saúde.

## ✨ Funcionalidades

### 📊 Registro de Dor
- **Localização Anatômica**: Seleção visual de partes do corpo via imagens interativas
- **Intensidade**: Escala de 0-10 para quantificar a dor
- **Características**: Tipo (aguda, crônica, latejante, etc.), duração e frequência
- **Contexto**: Gatilhos, atividades relacionadas e anotações detalhadas
- **Histórico Completo**: Visualização cronológica com filtros e paginação

### 🏃 Práticas de Saúde
- **Exercícios Físicos**: Registro de atividades com duração e intensidade
- **Fisioterapia**: Acompanhamento de sessões e evoluções
- **Medicação**: Controle de medicamentos com alertas de horário
- **Técnicas Alternativas**: Meditação, acupuntura, yoga e outros

### 🔔 Lembretes Inteligentes
- Notificações personalizadas para práticas de saúde
- Agendamento recorrente (diário, semanal, personalizado)
- Gestão completa com edição e exclusão

### 👥 Painel Administrativo
- Visualização de todos os usuários cadastrados
- Acesso aos registros de dor de cada paciente
- Estatísticas agregadas para análise populacional
- Controle de preferências de compartilhamento de dados

### 💬 Sistema de Feedback
- Envio de sugestões e relatos de problemas
- Comunicação direta com administradores
- Histórico de feedbacks enviados

### 🌍 Internacionalização (i18n)
- **Português Brasileiro (PT-BR)**: Idioma padrão
- **Inglês (EN-US)**: Suporte completo
- Alternância automática baseada no sistema ou seleção manual

### 🎨 Temas e Acessibilidade
- **Modo Claro e Escuro**: Suporte nativo com alternância automática
- **Tipografia Acessível**: Tamanhos de fonte ajustáveis
- **Alto Contraste**: Paleta de cores otimizada para legibilidade
- **Ícones Intuitivos**: Interface visual consistente

### 🔒 Privacidade e Segurança
- **Autenticação JWT**: Login seguro com tokens de sessão
- **Preferências de Compartilhamento**:
  - Não compartilhar dados
  - Compartilhar estatísticas completas
  - Compartilhar apenas dados de diagnóstico
- **Exclusão de Conta**: Remoção completa de dados pessoais

## 📋 Pré-requisitos

- **Flutter**: 3.0 ou superior
- **Dart SDK**: 3.0 ou superior
- **Android Studio** / **VS Code** com plugins Flutter/Dart
- **Dispositivo Android** (físico ou emulador)

## 🚀 Instalação e Configuração

### 1. Clone o Repositório
```bash
git clone https://github.com/lufespi/cuidador-app.git
cd cuidador_app
```

### 2. Instale as Dependências
```bash
flutter pub get
```

### 3. Execute o Aplicativo
```bash
# Listar dispositivos disponíveis
flutter devices

# Executar em dispositivo específico
flutter run -d <device_id>

# Modo debug com hot reload
flutter run --debug

# Modo release (otimizado)
flutter run --release
```

## 📦 Build para Distribuição

### Android APK

```bash
# Build release padrão (universal APK)
flutter build apk --release

# Build otimizado por arquitetura (menor tamanho)
flutter build apk --split-per-abi --release

# Build debug para testes
flutter build apk --debug
```

**Localização dos APKs:**
- **Release**: `build/app/outputs/flutter-apk/app-release.apk`
- **Debug**: `build/app/outputs/flutter-apk/app-debug.apk`
- **Split ABIs**: `build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk`, `app-arm64-v8a-release.apk`, etc.


## 📁 Estrutura do Projeto

```
lib/
├── main.dart                      # Ponto de entrada da aplicação
├── core/                          # Núcleo da aplicação
│   ├── theme/                     # Temas claro e escuro
│   ├── utils/                     # Utilitários e helpers
│   └── widgets/                   # Widgets reutilizáveis globais
├── data/                          # Camada de dados
│   ├── models/                    # Modelos de dados (User, PainRecord, etc.)
│   └── services/                  # Serviços de API e persistência
│       ├── auth_service.dart      # Autenticação e gestão de usuários
│       ├── pain_service.dart      # Registros de dor
│       ├── practice_service.dart  # Práticas de saúde
│       └── feedback_service.dart  # Sistema de feedback
├── l10n/                          # Arquivos de localização
│   ├── app_pt.arb                 # Strings em Português
│   └── app_en.arb                 # Strings em Inglês
└── screens/                       # Telas da aplicação
    ├── home/                      # Tela inicial e navegação
    ├── auth/                      # Login e registro
    ├── dor/                       # Gestão de dores
    │   ├── dor_page.dart          # Lista de registros
    │   ├── pain_detail_page.dart  # Detalhes do registro
    │   └── pain_form_page.dart    # Formulário de criação/edição
    ├── praticas/                  # Práticas de saúde
    ├── lembretes/                 # Gerenciamento de lembretes
    ├── feedback/                  # Envio de feedback
    └── settings/                  # Configurações
        ├── admin/                 # Painel administrativo
        ├── account/               # Gestão de conta
        └── privacy/               # Privacidade e segurança

assets/
├── fonts/                         # Fontes customizadas
├── icons/                         # Ícones do aplicativo
│   ├── accessibility/
│   ├── body-parts/                # Imagens anatômicas para seleção
│   ├── navigation-bar/
│   └── pain/                      # Ícones de intensidade de dor
└── images/                        # Imagens e ilustrações
```

## 🌐 Internacionalização

O CuidaDor utiliza o sistema de localização nativo do Flutter (`.arb` files):


## 🗄️ Migrações de Banco de Dados

O projeto inclui scripts SQL e Python para migrações de schema:

### Executar Migração SQL
```bash
mysql -u usuario -p database_name < scripts/add_data_share_preference.sql
```

### Executar Migração Python
```bash
python scripts/add_data_share_preference.py
```

## 🧪 Testes

```bash
# Executar todos os testes
flutter test

# Executar testes com cobertura
flutter test --coverage

# Testes de widget específico
flutter test test/widget_test.dart
```

## 🤝 Contribuindo

1. Faça um fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/MinhaFeature`)
3. Commit suas mudanças (`git commit -m 'Adiciona MinhaFeature'`)
4. Push para a branch (`git push origin feature/MinhaFeature`)
5. Abra um Pull Request

### Diretrizes de Código
- Siga as convenções de estilo do Dart ([Effective Dart](https://dart.dev/guides/language/effective-dart))
- Adicione comentários em código complexo
- Mantenha a cobertura de testes acima de 80%
- Traduza novas strings em ambos os idiomas (PT-BR e EN-US)

## 👨‍💻 Autor

Desenvolvido por [lufespi](https://github.com/lufespi)

---

**CuidaDor** - Cuidando da sua saúde, gerencie sua saúde osteoarticular 💙
