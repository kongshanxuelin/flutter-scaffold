import 'package:intl/intl.dart';

class Logger {
  bool mute = false;
  factory Logger() {
    final logger = new Logger._internal();
    return logger;
  }
  Logger._internal();

  //实例函数
  void log(msg,{String level:"DEBUG"}) {
    if (!mute) {
      DateTime now = new DateTime.now();
      var formatter = new DateFormat('yyyy-MM-dd HH:mm:ss');
      print("[ ${level} - " + formatter.format(now) +" ] : " + msg.toString());
    }
  }
  void debug(msg) {
    log(msg,level:"DEBUG");
  }
  void info(msg) {
    log(msg,level:"INFO");
  }
  void error(msg) {
    log(msg,level:"ERROR");
  }
}

var logger  = new Logger();