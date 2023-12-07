<a href="README-KR.md">
  <img src="language-kr.svg" alt="한국어">
</a>

<br>

# LogExport

LogExport is a Flutter plugin that exports log messages to a log file.

You must initialize LogExport before using it.

## Initialization

```dart
await LogExport.initialize(
  logFolderPath: 'path/to/log/files',
  timezone: 'Asia/Seoul',
  manageOldLogFiles: 7,
);
```

- `logFolderPath` is the path where the log file will be stored.
- `timezone` is the timezone of the log file. If empty, the timezone will be use local timezone.
- `manageOldLogFiles` is the number of log files to keep. If 0, all log files are kept.

## Writing Logs

Write log messages to the log file.

```dart
await LogExport.write('This is a log message.');
```
