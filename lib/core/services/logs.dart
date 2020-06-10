import 'package:habits_plus/core/util/logger.dart';

class LogServices {
  List<String> _logs = [];

  List<String> get log => _logs;

  void addError(String val, e) {
    _logs.add('${DateTime.now()} | $val $e');
    logger.e(val, e);
  }

  void addLog(String val) {
    _logs.add('${DateTime.now()} | $val');
    logger.i(val);
  }
}
