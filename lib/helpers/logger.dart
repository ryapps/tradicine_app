import 'package:logger/logger.dart';

class LoggerHelper {
  static final logger = Logger();
  static void debug(String message) {
    logger.log(Level.debug, message);
  }
  static void info(String message) {
    logger.log(Level.info, message);
  }
  static void warning(String message) {
    logger.log(Level.warning, message);
  }
  static void error(String message) {
    logger.log(Level.error, message);
  }
}
