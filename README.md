# quash_assignment

There are saveral usage for this plugin as mentioned below.

## Network Monitor
- Network API calls monitoring and logs data.
- Fetch data and display for your records.

## Crash Monitor
- App crash logging.
- Fetch logged and can be displayed.

## Screenshots every 100 ms
- Capturing screenshot without any permissions

## Getting Started for Network Monitoring

#### To add API calling monitor add interceptor to your dio instance.
```
final dio = Dio();
dio.interceptors.add(DioLogger());
```

#### To Get all API calls log you can fetch data calling below mentioned API.
```
final logs = await DioLogger().getAllLogs();
```

## Getting Started for Crash Logs

#### Start logging crash
```
void main() {
  runZonedGuarded(() {
    runApp(MyApp());
  }, (error, stackTrace) {
    CrashLogger.logError(error, stackTrace);
  });
}
```

#### Add crashloggin to all of you try catch part
```
try {
  // Code that might throw an error
} catch (error, stackTrace) {
  CrashLogger.logError(error, stackTrace);
  // Handle the error gracefully
}

```

#### To Get all crash logs you can fetch data calling below mentioned API.
```
final logs = await DioLogger().getAllLogs();
```

#### To start capturing screenshots bind your MaterialApp with ScreenshotWidget
```
return ScreenshotWidget(
  child: YourMaterialApp()
);
```

## Screenshots
![image](/screenshots/Screenshot_1715542769.png?raw=true =250x)
![image](/screenshots/Screenshot_1715542773.png?raw=true =250x)
![image](/screenshots/Screenshot_1715542896.png?raw=true =250x)
![image](/screenshots/Screenshot_1715542902.png?raw=true =250x)
![image](/screenshots/Screenshot_1715542909.png?raw=true =250x)

## TODO
- Generate models for logs response.
- Screenshots every 100ms is still in development. (Issue in release mode) [Pull Request FYI](https://github.com/wolfwithflames/quash_assignment/pull/2)

