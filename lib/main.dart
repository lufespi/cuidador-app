import 'package:flutter/material.dart';
import 'core/widgets/app_button.dart';
import 'screens/login_page.dart';

void main() => runApp(const CuidaDorApp());

class CuidaDorApp extends StatelessWidget {
  const CuidaDorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CuidaDor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal) ,
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}

/// Modelo simples (sem packages externos)
class DorRegistro {
  final DateTime dataHora;
  final int nivel;      // 0..10
  final String local;   // ex.: Joelho Direito
  final String? anotacao;

  DorRegistro({
    required this.dataHora,
    required this.nivel,
    required this.local,
    this.anotacao,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<DorRegistro> _registros = [];

  void _abrirRegistro() async {
    final novo = await showModalBottomSheet<DorRegistro>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => const _RegistrarDorSheet(),
    );
    if (novo != null) {
      setState(() {
        _registros.add(novo);
        _registros.sort((a, b) => b.dataHora.compareTo(a.dataHora));
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registro salvo')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CuidaDor — Registros de Dor')),
      body: _registros.isEmpty
          ? const _EmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _registros.length,
              itemBuilder: (_, i) {
                final r = _registros[i];
                return Card(
                  child: ListTile(
                    title: Text('${r.local} — nível ${r.nivel}'),
                    subtitle: Text(
                      '${_fmtData(r.dataHora)}  ${r.anotacao ?? ''}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    leading: CircleAvatar(
                      child: Text(r.nivel.toString()),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _abrirRegistro,
        label: const Text('Registrar dor'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  String _fmtData(DateTime dt) {
    // formato simples para começar
    final d = '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
    final h = '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    return '$d $h';
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.favorite_border, size: 56),
            const SizedBox(height: 12),
            const Text(
              'Você ainda não registrou sua dor.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Toque em "Registrar dor" para começar.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            AppButton.continuar(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const _BotoesTesteScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            const Text(
              'Ver componentes de botão',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class _RegistrarDorSheet extends StatefulWidget {
  const _RegistrarDorSheet();

  @override
  State<_RegistrarDorSheet> createState() => _RegistrarDorSheetState();
}

class _RegistrarDorSheetState extends State<_RegistrarDorSheet> {
  double _nivel = 5;
  String _local = 'Joelho Direito';
  final _anotacaoCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: viewInsets),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 4, margin: const EdgeInsets.only(bottom: 12), decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(2))),
              const Text('Registrar Dor', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Nível:'),
                  Expanded(
                    child: Slider(
                      value: _nivel,
                      min: 0,
                      max: 10,
                      divisions: 10,
                      label: _nivel.round().toString(),
                      onChanged: (v) => setState(() => _nivel = v),
                    ),
                  ),
                  Text(_nivel.round().toString()),
                ],
              ),
              DropdownButtonFormField<String>(
                value: _local,
                items: const [
                  DropdownMenuItem(value: 'Joelho Direito', child: Text('Joelho Direito')),
                  DropdownMenuItem(value: 'Joelho Esquerdo', child: Text('Joelho Esquerdo')),
                  DropdownMenuItem(value: 'Mãos', child: Text('Mãos')),
                  DropdownMenuItem(value: 'Quadril', child: Text('Quadril')),
                  DropdownMenuItem(value: 'Coluna', child: Text('Coluna')),
                ],
                onChanged: (v) => setState(() => _local = v ?? _local),
                decoration: const InputDecoration(labelText: 'Local da dor'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _anotacaoCtrl,
                decoration: const InputDecoration(
                  labelText: 'Anotação (opcional)',
                  hintText: 'Ex.: Dor após caminhada, rigidez matinal...',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        final r = DorRegistro(
                          dataHora: DateTime.now(),
                          nivel: _nivel.round(),
                          local: _local,
                          anotacao: _anotacaoCtrl.text.trim().isEmpty ? null : _anotacaoCtrl.text.trim(),
                        );
                        Navigator.pop(context, r);
                      },
                      icon: const Icon(Icons.save),
                      label: const Text('Salvar'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Tela de demonstração dos botões
class _BotoesTesteScreen extends StatelessWidget {
  const _BotoesTesteScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teste dos Botões'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Componentes de Botão',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 32),
            // Botão Indicar Local
            const Text(
              '1. Indicar Local da Dor (Outline)',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            AppButton.indicarLocal(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Indicar local pressionado!')),
                );
              },
            ),
            const SizedBox(height: 32),
            // Botão Continuar
            const Text(
              '2. Continuar (Preenchido)',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            AppButton.continuar(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Continuar pressionado!')),
                );
              },
            ),
            const SizedBox(height: 32),
            // Botão Criar Conta
            const Text(
              '3. Criar Conta (Preenchido - Mais Arredondado)',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            AppButton.criarConta(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Criar Conta pressionado!')),
                );
              },
            ),
            const SizedBox(height: 48),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Voltar'),
            ),
          ],
        ),
      ),
    );
  }
}
