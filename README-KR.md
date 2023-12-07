# LogExport

LogExport는 로그 메시지를 로그 파일로 내보내는 Flutter Plugin 입니다.

LogExport를 사용하기 전에 초기화해야 합니다.

## 초기화

```dart
await LogExport.initialize(
  logFolderPath: 'path/to/log/files',
  timezone: 'Asia/Seoul',
  manageOldLogFiles: 7,
);
```

- `logFolderPath` 는 로그 파일이 저장될 경로입니다.
- `timezone` 은 로그 파일의 시간대입니다. 비어 있으면 시간대는 로컬 시간대를 사용합니다.
- `manageOldLogFiles` 는 유지할 로그 파일의 수입니다. 0 이면 모든 로그 파일이 유지됩니다.

## 로그 작성

로그 메시지를 로그 파일에 작성합니다.

```dart
await LogExport.write('This is a log message.');
```
