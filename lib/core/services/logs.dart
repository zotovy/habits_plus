class LogServices {
  List<String> _logs = [];

  List<String> get log => _logs;

  void addLog(String val) {
    _logs.add('${DateTime.now()} | $val');
  }
}
