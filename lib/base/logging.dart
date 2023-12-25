// logging.dart

// ignore_for_file: avoid_print

class Logger {
  static bool _enableLogging = true;

  // Enable or disable logging
  static void enableLogging(bool enable) {
    _enableLogging = enable;
  }

  // Log a message
  static void log(String message) {
    if (_enableLogging) {
      print('[LOG] $message');
    }
  }

  // Log an error
  static void error(String message) {
    if (_enableLogging) {
      print('[ERROR] $message');
    }
  }

  // Log a warning
  static void warn(String message) {
    if (_enableLogging) {
      print('[WARNING] $message');
    }
  }

  // Log an information message
  static void info(String message) {
    if (_enableLogging) {
      print('[INFO] $message');
    }
  }

  // Log a success message
  static void success(String message) {
    if (_enableLogging) {
      print('[SUCCESS] $message');
    }
  }
}
