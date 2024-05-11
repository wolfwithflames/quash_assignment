# quash_assignment

There are saveral usage for this plugin as mentioned below.

## Network Monitor
- Network API calls monitoring and logs data.
- Fetch data and display for your records.

## Crash Monitor
- App crash logging.
- Fetch logged and can be displayed.


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

## TODO
- Generate models for logs response.

