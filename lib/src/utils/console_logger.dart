import 'dart:async';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:logging/logging.dart';

// ANSI color codes
const String reset = '[0m';
const String red = '[31m';
const String green = '[32m';
const String yellow = '[33m';
const String blue = '[34m';
const String cyan = '[36m';
const String magenta = '[35m';

class ConsoleLogger {
  final Logger _logger;
  Timer? _spinnerTimer;
  int _spinnerIndex = 0;
  final List<String> _spinner = [
    '⠋',
    '⠙',
    '⠹',
    '⠸',
    '⠼',
    '⠴',
    '⠦',
    '⠧',
    '⠇',
    '⠏',
  ];

  ConsoleLogger(String name) : _logger = Logger(name);

  void info(String message) {
    _logger.info(message);
  }

  void warning(String message) {
    _logger.warning(message);
  }

  void severe(String message) {
    _logger.severe(message);
  }

  void fine(String message) {
    _logger.fine(message);
  }

  void startSpinner(String message) {
    _spinnerTimer = Timer.periodic(const Duration(milliseconds: 80), (timer) {
      stdout.write('\r${_spinner[_spinnerIndex]} $message');
      _spinnerIndex = (_spinnerIndex + 1) % _spinner.length;
    });
  }

  void stopSpinner({bool success = true, String? message}) {
    _spinnerTimer?.cancel();
    stdout.write('\r');
    if (success) {
      info(message ?? 'Done.');
    } else {
      severe(message ?? 'Failed.');
    }
  }

  static void initialize() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      final emoji = _getEmojiForLevel(record.level);
      final color = _getColorForLevel(record.level);
      final time = DateFormat('HH:mm:ss').format(record.time);

      // Using print here is acceptable for CLI logging output
      // ignore: avoid_print
      print('$color$emoji [$time] ${record.message}$reset');
    });
  }

  static String _getColorForLevel(Level level) {
    if (level == Level.SEVERE) {
      return red;
    } else if (level == Level.WARNING) {
      return yellow;
    } else if (level == Level.INFO) {
      return green;
    } else if (level == Level.CONFIG) {
      return blue;
    } else if (level == Level.FINE) {
      return cyan;
    } else if (level == Level.FINER) {
      return magenta;
    } else if (level == Level.FINEST) {
      return magenta;
    }
    return reset;
  }

  static String _getEmojiForLevel(Level level) {
    if (level == Level.SEVERE) {
      return '💥';
    } else if (level == Level.WARNING) {
      return '⚠️';
    } else if (level == Level.INFO) {
      return 'ℹ️';
    } else if (level == Level.CONFIG) {
      return '⚙️';
    } else if (level == Level.FINE) {
      return '✨';
    } else if (level == Level.FINER) {
      return '🔍';
    } else if (level == Level.FINEST) {
      return '🔬';
    }
    return '✅';
  }
}