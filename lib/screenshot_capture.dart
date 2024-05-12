import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

/// A class that captures screenshots and saves them to the application directory.
///
/// Use the `startScreenshots` method to start capturing screenshots. The screenshots are saved as PNG files in the application directory.
///
/// The `captureScreenshot` method captures a screenshot of the current screen and saves it to the application directory. It uses the provided `GlobalKey` to find the current context and the `path` to determine the save location.
///
/// The `writeFiles` method writes the captured screenshot to a file in the application directory.
///
/// The `groupScreenshotsByHour` method groups the captured screenshots by hour. This method is not implemented and throws an `UnimplementedError`.
///
/// The `stopScreenshots` method stops capturing screenshots. This method is not implemented and throws an `UnimplementedError`.
class ScreenshotCapture {
  /// Starts capturing screenshots using the provided [globalKey] and saves them to the application directory.
  ///
  /// The screenshots are saved as PNG files in the [path] directory.
  ///
  /// This method runs the [captureScreenshot] function in a separate isolate.
  ///
  /// Note: The [globalKey] is used to find the current context and the [path] determines the save location.
  ///
  /// Throws an error if there is an issue capturing the screenshot or saving it to the application directory.
  Future<void> startScreenshots(GlobalKey globalKey) async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path;

    Isolate.run(
      () => captureScreenshot(globalKey, path),
    );
  }

  /// Captures a screenshot using the provided [globalKey] and saves it to the specified [path].
  ///
  /// This method continuously captures screenshots in a loop until stopped. Each screenshot is saved as a PNG file with a unique filename based on the current timestamp.
  ///
  /// The [globalKey] is used to find the current context and the [path] determines the save location.
  ///
  /// The captured screenshots are stored in a list of [FileWriteData] objects, which contain the file and PNG byte data.
  ///
  /// If the number of captured screenshots exceeds 100, the [writeFiles] method is called to write the files to the application directory.
  ///
  /// The method waits for 100 milliseconds between each screenshot capture.
  ///
  /// If an error occurs during the screenshot capture process, an error message is printed to the console.
  ///
  /// Note: This method runs indefinitely until stopped manually.
  ///
  /// Throws an error if there is an issue capturing the screenshot or saving it to the application directory.

  Future<void> captureScreenshot(GlobalKey globalKey, String path) async {
    List<FileWriteData> writeData = [];
    while (true) {
      try {
        // Generate a unique filename based on timestamp
        String fileName = '${DateTime.now().millisecondsSinceEpoch}.png';

        RenderRepaintBoundary boundary = globalKey.currentContext!
            .findRenderObject() as RenderRepaintBoundary;
        ui.Image image = await boundary.toImage(pixelRatio: 1.0);
        ByteData? byteData =
            await image.toByteData(format: ui.ImageByteFormat.png);
        if (byteData != null) {
          Uint8List pngBytes = byteData.buffer.asUint8List();
          // Save the screenshot to the application directory
          File file = File('$path/$fileName');
          // Writting all files later on also can be implemented later on while applicating is in foreground.
          writeData.add(FileWriteData(file: file, pngBytes: pngBytes));

          if (writeData.length > 100) {
            await Future.wait(writeData.map((e) => writeFiles(e)));
          }
        }
        await Future.delayed(const Duration(milliseconds: 100));
      } catch (e) {
        print('Error capturing screenshot: $e');
      }
    }
  }

  /// Writes the provided [FileWriteData] object to a file.
  ///
  /// This method logs the [pngBytes] of the [FileWriteData] object and writes the [pngBytes] to the [file] using the [writeAsBytes] method.
  ///
  writeFiles(FileWriteData file) async {
    await file.file.writeAsBytes(file.pngBytes);
  }

  Future<Map<String, List<Uint8List>>> groupScreenshotsByHour() async {
    // Implement grouping screenshots by hour
    throw UnimplementedError();
  }

  void stopScreenshots() {
    // Implement stopping capturing screenshots
    throw UnimplementedError();
  }
}

class FileWriteData {
  final File file;
  final Uint8List pngBytes;

  FileWriteData({
    required this.file,
    required this.pngBytes,
  });
}
