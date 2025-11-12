# 🔌 Integração Backend Flask - CuidaDor App

## 📋 Arquivos Criados

### 📁 Estrutura
```
lib/
├── core/
│   ├── constants/
│   │   └── api_constants.dart          # URLs, endpoints e constantes
│   ├── models/
│   │   ├── user_model.dart            # Modelo de usuário
│   │   ├── auth_response_model.dart   # Resposta de autenticação
│   │   └── pain_record_model.dart     # Modelo de registro de dor
│   ├── providers/
│   │   └── register_provider.dart     # Provider para gerenciar registro
│   └── services/
│       ├── api_service.dart           # Cliente HTTP base
│       ├── auth_service.dart          # Serviço de autenticação
│       ├── pain_service.dart          # Serviço de gerenciamento de dor
│       └── EXEMPLO_USO.dart           # Exemplos práticos
└── screens/
    └── auth/
        └── login/
            └── login_page.dart        # ✅ Integrado com API
```

## 🚀 Como Usar

### 1. **Autenticação - Login**

```dart
import '../../../core/services/auth_service.dart';
import '../../../core/services/api_service.dart';

final _authService = AuthService();

Future<void> _handleLogin() async {
  try {
    await _authService.login(
      email: _emailController.text.trim(),
      password: _senhaController.text,
    );
    
    // Login bem-sucedido - navegar para home
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  } on ApiException catch (e) {
    // Erro da API (401, 404, etc)
    showError(e.message);
  } catch (e) {
    // Erro de conexão
    showError('Erro ao conectar com o servidor');
  }
}
```

### 2. **Autenticação - Registro**

```dart
Future<void> _handleRegister() async {
  try {
    await _authService.register(
      email: 'usuario@example.com',
      password: 'senha123',
      firstName: 'João',
      lastName: 'Silva',
      birthDate: '1990-01-15',  // YYYY-MM-DD
      phone: '+5511999999999',
      gender: 'masculino',  // masculino, feminino, outro, prefiro_nao_dizer
    );
    
    // Registro bem-sucedido - já está logado
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  } on ApiException catch (e) {
    showError(e.message);
  }
}
```

### 3. **Verificar Autenticação (no main.dart)**

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Verificar se há sessão salva
  final authService = AuthService();
  final isAuth = await authService.checkAuth();
  
  runApp(MyApp(isAuthenticated: isAuth));
}

class MyApp extends StatelessWidget {
  final bool isAuthenticated;
  
  const MyApp({super.key, required this.isAuthenticated});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: isAuthenticated ? const HomePage() : const LoginPage(),
    );
  }
}
```

### 4. **Registrar Dor**

```dart
import '../../../core/services/pain_service.dart';

final _painService = PainService();

Future<void> _savePainRecord() async {
  try {
    final record = await _painService.createPainRecord(
      bodyPart: 'joelho_direito',
      intensity: 7,  // 1-10
      description: 'Dor ao subir escadas',
      symptoms: ['inchaço', 'rigidez'],
      timestamp: DateTime.now(),
    );
    
    showSuccess('Registro salvo com sucesso!');
  } on ApiException catch (e) {
    showError(e.message);
  }
}
```

### 5. **Listar Registros de Dor**

```dart
Future<void> _loadPainRecords() async {
  try {
    // Listar todos
    final records = await _painService.getPainRecords();
    
    // Listar com filtro de data
    final filteredRecords = await _painService.getPainRecords(
      startDate: '2025-01-01',
      endDate: '2025-12-31',
    );
    
    setState(() {
      _painRecords = records;
    });
  } on ApiException catch (e) {
    showError(e.message);
  }
}
```

### 6. **Estatísticas de Dor**

```dart
Future<void> _loadStatistics() async {
  try {
    final stats = await _painService.getPainStatistics(
      startDate: '2025-01-01',
      endDate: '2025-12-31',
    );
    
    print('Média: ${stats.averageIntensity}');
    print('Mínimo: ${stats.minIntensity}');
    print('Máximo: ${stats.maxIntensity}');
    print('Total: ${stats.totalRecords}');
  } on ApiException catch (e) {
    showError(e.message);
  }
}
```

## 📡 Endpoints Disponíveis

### Autenticação
- `POST /api/v1/auth/register` - Criar conta
- `POST /api/v1/auth/login` - Login
- `GET /api/v1/auth/me` - Dados do usuário (requer token)

### Perfil
- `GET /api/v1/user/profile` - Buscar perfil
- `PUT /api/v1/user/profile` - Atualizar perfil
- `PUT /api/v1/user/preferences` - Atualizar preferências

### Dor
- `POST /api/v1/pain` - Criar registro
- `GET /api/v1/pain` - Listar registros
- `GET /api/v1/pain/<id>` - Buscar registro específico
- `PUT /api/v1/pain/<id>` - Atualizar registro
- `DELETE /api/v1/pain/<id>` - Deletar registro
- `GET /api/v1/pain/statistics` - Estatísticas

## 🔧 Configuração

### 1. Base URL
Edite `lib/core/constants/api_constants.dart`:

```dart
static const String baseUrl = 'http://localhost:5000/api/v1';
```

Para usar em dispositivo físico ou emulador Android, use:
```dart
static const String baseUrl = 'http://10.0.2.2:5000/api/v1';  // Android Emulator
static const String baseUrl = 'http://SEU_IP_LOCAL:5000/api/v1';  // Dispositivo físico
```

### 2. Dependências Instaladas
```yaml
dependencies:
  http: ^1.2.0
  shared_preferences: ^2.5.3
  provider: ^6.1.5+1
```

## ⚠️ Tratamento de Erros

Todos os serviços lançam `ApiException` em caso de erro:

```dart
try {
  await _authService.login(email: email, password: password);
} on ApiException catch (e) {
  // Erro específico da API
  print('Status: ${e.statusCode}');
  print('Mensagem: ${e.message}');
  print('Dados: ${e.data}');
} catch (e) {
  // Erro de conexão ou outro
  print('Erro: $e');
}
```

## 🎯 Próximos Passos

### ✅ Já Implementado:
1. ✅ Estrutura de serviços (API, Auth, Pain)
2. ✅ Modelos de dados (User, PainRecord, AuthResponse)
3. ✅ Constantes da API
4. ✅ Login integrado com backend
5. ✅ Provider para registro
6. ✅ Documentação e exemplos

### 📝 TODO - Integrar nas Telas:

1. **Register Steps (1, 2, 3)**
   - Usar `RegisterProvider` para armazenar dados
   - No Step 3, chamar `authService.register()`
   - Navegação após sucesso

2. **Dor Page**
   - Integrar `painService.createPainRecord()`
   - Exibir lista de registros históricos
   - Implementar edição e exclusão

3. **Account Page (Settings)**
   - Integrar `authService.updateProfile()`
   - Atualizar preferências
   - Logout

4. **Home Page**
   - Exibir estatísticas com `painService.getPainStatistics()`
   - Gráficos de evolução da dor

## 📚 Arquivos de Referência

- **EXEMPLO_USO.dart** - Exemplos práticos de todos os serviços
- **register_provider.dart** - Provider para gerenciar fluxo de registro
- **login_page.dart** - Exemplo real de integração

## 🔐 Segurança

- Token JWT salvo automaticamente no `shared_preferences`
- Token incluído automaticamente em todas as requisições autenticadas
- Logout limpa todos os dados locais

## 🐛 Troubleshooting

### Erro de Conexão:
1. Verifique se o backend Flask está rodando
2. Confirme a URL correta no `api_constants.dart`
3. Use `10.0.2.2` para emulador Android ao invés de `localhost`

### Token Expirado:
- O serviço detecta automaticamente e faz logout
- Usuário é redirecionado para tela de login

### Campos Obrigatórios:
- Email, password, first_name, last_name são obrigatórios no registro
- body_part e intensity são obrigatórios no registro de dor

---

**Desenvolvido para o projeto CuidaDor** 🩺
Backend: Flask | Frontend: Flutter
