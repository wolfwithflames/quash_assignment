import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

/// A class that provides logging functionality for handling crash logs.
///
/// Use the `CrashLogger` class to initialize the logger, log errors with stack traces,
/// retrieve the crash logs, and clear the crash logs.
///
/// Example usage:
///
/// ```dart
/// // Initialize the logger
/// await CrashLogger.initLogger();
///
/// // Log an error with stack trace
/// try {
///   // code that may throw an error
/// } catch (error, stackTrace) {
///   await CrashLogger.logError(error, stackTrace);
/// }
///
/// // Retrieve the crash logs
/// final logs = await CrashLogger.getLogs();
///
/// // Clear the crash logs
/// await CrashLogger.clearCrashLogs();
/// ```
class CrashLogger {
  /// Initializes the logger by initializing Hive and opening the Hive box for crash logs.
  ///
  /// This method should be called before logging any errors with stack traces.
  /// It retrieves the application documents directory and initializes Hive with the directory path.
  /// Then, it opens the Hive box named 'crashLogs' to store the crash logs.
  ///
  /// Throws an exception if there is an error initializing Hive or opening the Hive box.
  ///
  static initLogger() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();

    Hive.init(appDocumentDir.path);

    // Open the Hive box for crash logs
    await Hive.openBox<String>('crashLogs');
  }

  /// Logs an error with the corresponding stack trace to the Hive box for crash logs.
  ///
  /// This method takes in an [error] and a [stackTrace] and creates a log string
  /// in the format "Error: [error]\nStack Trace: [stackTrace]". It then opens the
  /// Hive box named 'crashLogs' and adds the log string to it. Finally, it prints
  /// a debug message indicating that the crash has been logged.
  ///
  /// Throws an exception if there is an error opening the Hive box.
  ///
  static Future<void> logError(dynamic error, StackTrace stackTrace) async {
    final log = 'Error: $error\nStack Trace: $stackTrace';
    // Open the Hive box for crash logs
    final box = await Hive.openBox<String>('crashLogs');
    // Save the log to Hive
    box.add(log);
    debugPrint('Crash logged: $log');
  }

  /// Retrieves the crash logs from the Hive box named 'crashLogs'.
  ///
  /// This method opens the Hive box named 'crashLogs' and retrieves all the values
  /// stored in the box as a list of strings. The crash logs can then be displayed or
  /// processed as needed.
  ///
  /// Returns:
  ///   - A list of strings representing the crash logs.
  ///
  static Future getLogs() async {
    final box = await Hive.openBox<String>('crashLogs');
    final List<String> logs = box.values.toList();
    // Display or process the crash logs as needed
    return logs;
  }

  /// Clears the crash logs stored in the Hive box named 'crashLogs'.
  ///
  /// This method opens the Hive box named 'crashLogs' and clears all the values
  /// stored in the box. It then prints a debug message indicating that the crash logs
  /// have been cleared.
  ///
  /// Throws an exception if there is an error opening the Hive box.
  ///
  static Future<void> clearCrashLogs() async {
    final box = await Hive.openBox<String>('crashLogs');
    await box.clear();
    debugPrint('Crash logs cleared');
  }
}
