# Guia de Integração com Backend

## 📁 Estrutura de Arquivos

```
lib/
├── core/
│   ├── config/
│   │   └── api_config.dart          # URLs e configurações da API
│   ├── errors/
│   │   └── api_exceptions.dart      # Exceções personalizadas
│   └── network/
│       ├── http_client.dart         # Cliente HTTP com interceptors
│       └── token_storage.dart       # Gerenciamento de tokens JWT
│
├── data/
│   ├── models/
│   │   ├── user_model.dart          # Modelo de usuário
│   │   ├── auth_response.dart       # Resposta de autenticação
│   │   └── pain_record_model.dart   # Modelo de registro de dor
│   │
│   ├── services/
│   │   ├── auth_service.dart        # Serviço de autenticação
│   │   └── pain_service.dart        # Serviço de dor
│   │
│   └── api_service.dart             # Fachada principal (retrocompatível)
```

## 🚀 Exemplos de Uso

### 1. Login Simples (Retrocompatível)

```dart
final apiService = ApiService();

try {
  final success = await apiService.login('user@email.com', 'senha123');
  if (success) {
    // Login bem-sucedido
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage()));
  }
} catch (e) {
  // Erro no login
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Erro ao fazer login')),
  );
}
```

### 2. Login com Tratamento de Erros Específicos

```dart
final apiService = ApiService();

try {
  final authResponse = await apiService.auth.login(
    email: 'user@email.com',
    senha: 'senha123',
  );
  
  // Login bem-sucedido - token já está salvo automaticamente
  print('Token: ${authResponse.accessToken}');
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage()));
  
} on UnauthorizedException catch (e) {
  // Credenciais inválidas
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Email ou senha incorretos')),
  );
} on NetworkException catch (e) {
  // Sem internet
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Verifique sua conexão')),
  );
} on ApiException catch (e) {
  // Outros erros
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(e.message)),
  );
}
```

### 3. Registro de Novo Usuário

```dart
final apiService = ApiService();

try {
  final authResponse = await apiService.auth.register(
    email: 'novo@email.com',
    senha: 'senha123',
    nome: 'João Silva',
    dataNascimento: DateTime(1990, 5, 15),
    genero: 'masculino',
    telefone: '11999999999',
  );
  
  // Registro bem-sucedido - já está autenticado
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage()));
  
} on ValidationException catch (e) {
  // Dados inválidos
  print('Erros de validação: ${e.data}');
} catch (e) {
  print('Erro: $e');
}
```

### 4. Obter Perfil do Usuário

```dart
final apiService = ApiService();

try {
  final user = await apiService.auth.getProfile();
  print('Nome: ${user.nome}');
  print('Email: ${user.email}');
} on UnauthorizedException {
  // Token expirado - redirecionar para login
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginPage()));
}
```

### 5. Criar Registro de Dor

```dart
final apiService = ApiService();

try {
  final painRecord = await apiService.pain.createPainRecord(
    bodyParts: ['Cabeça', 'Torso'],
    intensidade: 7,
    descricao: 'Dor de cabeça forte após trabalhar',
    dataRegistro: DateTime.now(),
  );
  
  print('Registro criado com ID: ${painRecord.id}');
  
} on ValidationException catch (e) {
  print('Erro de validação: ${e.message}');
} catch (e) {
  print('Erro: $e');
}
```

### 6. Listar Registros de Dor

```dart
final apiService = ApiService();

try {
  final records = await apiService.pain.getPainRecords(
    startDate: DateTime.now().subtract(Duration(days: 30)),
    endDate: DateTime.now(),
    limit: 10,
  );
  
  for (final record in records) {
    print('Dor em ${record.bodyParts.join(", ")} - Intensidade: ${record.intensidade}');
  }
} catch (e) {
  print('Erro ao buscar registros: $e');
}
```

### 7. Logout

```dart
final apiService = ApiService();

try {
  await apiService.logout();
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginPage()));
} catch (e) {
  // Mesmo com erro, limpar tokens localmente
  print('Erro no logout: $e');
}
```

### 8. Verificar Autenticação

```dart
final apiService = ApiService();

final isAuth = await apiService.isAuthenticated();
if (!isAuth) {
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginPage()));
}
```

## 🔧 Configuração

### Alterar URL do Backend

Edite `lib/core/config/api_config.dart`:

```dart
static const String _prodBaseUrl = 'https://SeuApp.pythonanywhere.com';
```

### Trocar para Ambiente de Desenvolvimento

No `api_config.dart`, mude:

```dart
static String get baseUrl => isProduction ? _prodBaseUrl : _devBaseUrl;
```

### Build em Produção

```bash
flutter build apk --release
flutter build ios --release
```

## 🐍 Estrutura Sugerida do Backend Python

### Estrutura de Diretórios

```
backend/
├── app/
│   ├── __init__.py
│   ├── main.py                 # Entrada da aplicação
│   ├── config.py               # Configurações
│   ├── database.py             # Conexão com BD
│   │
│   ├── models/
│   │   ├── __init__.py
│   │   ├── user.py
│   │   ├── pain_record.py
│   │   └── practice.py
│   │
│   ├── schemas/
│   │   ├── __init__.py
│   │   ├── user_schema.py
│   │   ├── pain_schema.py
│   │   └── auth_schema.py
│   │
│   ├── routes/
│   │   ├── __init__.py
│   │   ├── auth_routes.py
│   │   ├── pain_routes.py
│   │   └── practice_routes.py
│   │
│   ├── services/
│   │   ├── __init__.py
│   │   ├── auth_service.py
│   │   └── pain_service.py
│   │
│   └── utils/
│       ├── __init__.py
│       ├── security.py         # JWT, hashing
│       └── dependencies.py     # Dependências
│
├── requirements.txt
└── README.md
```

### Exemplo de Endpoint (FastAPI)

```python
# routes/auth_routes.py
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from ..schemas.auth_schema import LoginRequest, RegisterRequest, AuthResponse
from ..services.auth_service import AuthService
from ..utils.dependencies import get_db

router = APIRouter(prefix="/auth", tags=["auth"])

@router.post("/login", response_model=AuthResponse)
def login(request: LoginRequest, db: Session = Depends(get_db)):
    auth_service = AuthService(db)
    return auth_service.login(request.email, request.senha)

@router.post("/register", response_model=AuthResponse, status_code=201)
def register(request: RegisterRequest, db: Session = Depends(get_db)):
    auth_service = AuthService(db)
    return auth_service.register(request)
```

### Formato de Resposta JSON

```json
{
  "access_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...",
  "refresh_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...",
  "user_id": "123",
  "email": "user@email.com",
  "user": {
    "id": "123",
    "email": "user@email.com",
    "nome": "João Silva"
  }
}
```

## 📦 Dependências Necessárias

Adicione no `pubspec.yaml`:

```yaml
dependencies:
  http: ^1.1.0
  shared_preferences: ^2.2.2
  provider: ^6.1.1  # Para state management
```

Instale:

```bash
flutter pub get
```

## 🧪 Testes

### Testar Login

```dart
void main() {
  test('Login deve retornar token', () async {
    final apiService = ApiService();
    final response = await apiService.auth.login(
      email: 'test@email.com',
      senha: 'senha123',
    );
    
    expect(response.accessToken, isNotEmpty);
  });
}
```

## 🔐 Segurança

1. **Nunca** comite tokens ou senhas no código
2. Use HTTPS em produção
3. Implemente refresh token para renovar acesso
4. Valide entrada do usuário antes de enviar
5. Use `flutter_dotenv` para variáveis de ambiente

## 📝 Versionamento da API

Use URLs versionadas:

```dart
static const String apiVersion = 'v1';
static String get apiUrl => '$baseUrl/api/$apiVersion';
```

No backend:

```python
app.include_router(auth_router, prefix="/api/v1")
app.include_router(pain_router, prefix="/api/v1")
```

## 🎯 Próximos Passos

1. ✅ Implementar serviços restantes (práticas, lembretes, educação)
2. ✅ Adicionar paginação nas listagens
3. ✅ Implementar cache local (offline-first)
4. ✅ Adicionar testes unitários
5. ✅ Implementar refresh token automático
6. ✅ Adicionar logging e analytics
