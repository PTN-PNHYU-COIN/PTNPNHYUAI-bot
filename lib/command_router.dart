enum CommandRisk { safe, sensitive, blocked }

class CommandDecision {
  final String intent;
  final CommandRisk risk;
  final String response;

  const CommandDecision({
    required this.intent,
    required this.risk,
    required this.response,
  });
}

class CommandRouter {
  static const _safeIntents = <String>{
    'open_app',
    'search_files',
    'create_draft',
  };

  CommandDecision route(String rawText) {
    final text = rawText.trim().toLowerCase();

    if (text.isEmpty) {
      return const CommandDecision(
        intent: 'empty',
        risk: CommandRisk.blocked,
        response: 'Команду не почув. Спробуй ще раз.',
      );
    }

    if (text.contains('видали') ||
        text.contains('відправ') ||
        text.contains('купи') ||
        text.contains('опублікуй') ||
        text.contains('налаштування безпеки')) {
      return const CommandDecision(
        intent: 'sensitive_action',
        risk: CommandRisk.sensitive,
        response: 'Ця дія потребує явного підтвердження перед виконанням.',
      );
    }

    if (text.startsWith('відкрий ')) {
      return const CommandDecision(
        intent: 'open_app',
        risk: CommandRisk.safe,
        response: 'Команда розпізнана як відкриття дозволеного застосунку.',
      );
    }

    if (text.contains('знайди файл') || text.contains('пошук файлу')) {
      return const CommandDecision(
        intent: 'search_files',
        risk: CommandRisk.safe,
        response: 'Команда розпізнана як пошук файлів.',
      );
    }

    if (text.contains('створи чернетку') || text.contains('напиши чернетку')) {
      return const CommandDecision(
        intent: 'create_draft',
        risk: CommandRisk.safe,
        response: 'Команда розпізнана як створення чернетки.',
      );
    }

    final intent = 'unknown';
    final risk = _safeIntents.contains(intent)
        ? CommandRisk.safe
        : CommandRisk.blocked;

    return const CommandDecision(
      intent: 'unknown',
      risk: CommandRisk.blocked,
      response: 'Ця команда поки не входить до дозволеного списку.',
    );
  }
}
