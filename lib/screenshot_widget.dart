import 'package:flutter/material.dart';
import 'package:quash_assignment/screenshot_capture.dart';

class ScreenshotWidget extends StatefulWidget {
  const ScreenshotWidget({super.key, required this.child});
  final Widget child;

  @override
  State<ScreenshotWidget> createState() => _ScreenshotWidgetState();
}

class _ScreenshotWidgetState extends State<ScreenshotWidget> {
  ScreenshotCapture screenshotCapture = ScreenshotCapture();

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      screenshotCapture.startScreenshots(globalKey);
    });
    super.initState();
  }

  GlobalKey globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: globalKey,
      child: widget.child,
    );
  }
}
