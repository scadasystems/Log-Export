import 'dart:async';

import 'package:synchronized/synchronized.dart';
import 'dart:io';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_lib;
import 'package:intl/intl.dart';

/// LogExport is a class that exports log messages to a log file.
///
/// You need to initialize LogExport before using it.
class LogExport {
  static bool _initialized = false;
  static final _lock = Lock();
  static String _logPath = '';
  static String get logPath => _logPath;
  static String _prevFileName = '';
  static String _timezone = '';
  static int _manageOldLogFiles = 7;
  static File? _file;
  static final _buffer = <String>[];
  static Timer? _timer;

  /// Initialize LogExport
  /// - [logFolderPath] is the path where the log files will be stored.
  /// - [timezone] is the timezone of the log files. If it is empty, the timezone will be the local timezone.
  /// - [manageOldLogFiles] is the number of log files to keep. If it is 0, all log files will be kept.
  static Future<void> initialize({
    required String logFolderPath,
    String timezone = '',
    int manageOldLogFiles = 7,
  }) async {
    if (logFolderPath.isEmpty) {
      throw ArgumentError('logFolderPath is empty.');
    }

    _initialized = true;

    tz_lib.initializeTimeZones();

    _logPath = logFolderPath;
    _timezone = timezone;
    _manageOldLogFiles = manageOldLogFiles;

    var directory = Directory('$_logPath/');

    var exists = await directory.exists();

    if (exists) return;

    await directory.create(recursive: true);
  }

  /// Write a log message to the log file.
  static Future<void> write(String msg) async {
    if (!_initialized) {
      throw StateError('LogExport is not initialized.');
    }

    final now = _timezone.isEmpty ? DateTime.now() : tz.TZDateTime.now(tz.getLocation(_timezone));

    final fileName = DateFormat('yyyy-MM-dd').format(now);

    if (_prevFileName != fileName) {
      _prevFileName = fileName;
      _file = File('$_logPath/$fileName.txt');
      await _manageOldLogs();
    }

    final nowString = DateFormat('yyyy-MM-dd HH:mm:ss.SSS').format(now);
    final logString = '[$nowString] $msg';

    await _lock.synchronized(() async {
      _buffer.add(logString);

      _timer ??= Timer(const Duration(seconds: 3), () async {
        await _flushBuffer();
      });

      if (_buffer.length >= 10) {
        await _flushBuffer();
      }
    });

    return;
  }

  /// Delete old log files.
  static Future<void> _manageOldLogs() async {
    final directory = Directory(_logPath);
    final fileList = directory.listSync(recursive: true);

    if (_manageOldLogFiles == 0) return;

    if (fileList.length > _manageOldLogFiles) {
      fileList.sort((a, b) => a.path.compareTo(b.path));
      await fileList.first.delete(recursive: true);
    }
  }

  /// Flush the buffer to the log file.
  static Future<void> _flushBuffer() async {
    if (_buffer.isEmpty) return;

    await _file!.writeAsString('${_buffer.join('\n')}\n', mode: FileMode.append);

    _buffer.clear();

    _timer?.cancel();
    _timer = null;
  }
}
