import 'package:flutter/material.dart';

import 'command_router.dart';

void main() {
  runApp(const PtnpnhyuaiApp());
}

class PtnpnhyuaiApp extends StatelessWidget {
  const PtnpnhyuaiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PTNPNHYUAI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const AssistantHomePage(),
    );
  }
}

class AssistantHomePage extends StatefulWidget {
  const AssistantHomePage({super.key});

  @override
  State<AssistantHomePage> createState() => _AssistantHomePageState();
}

class _AssistantHomePageState extends State<AssistantHomePage> {
  final _controller = TextEditingController();
  final _router = CommandRouter();

  String _status = 'Скажи: «Птен, стартуємо»';
  String _reply = 'Готовий до безпечних команд.';

  void _submitCommand() {
    final decision = _router.route(_controller.text);

    setState(() {
      _status = 'Intent: ${decision.intent}';
      _reply = decision.response;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PTNPNHYUAI')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.mic_rounded, size: 72),
              const SizedBox(height: 20),
              Text(
                _status,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Тестова команда',
                  hintText: 'Наприклад: відкрий Telegram',
                ),
                onSubmitted: (_) => _submitCommand(),
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: _submitCommand,
                icon: const Icon(Icons.send_rounded),
                label: const Text('Виконати тест'),
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(_reply),
                ),
              ),
              const Spacer(),
              const Text(
                'Прототип працює у dry-run режимі: команди класифікуються, але дії на пристрої ще не виконуються.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
