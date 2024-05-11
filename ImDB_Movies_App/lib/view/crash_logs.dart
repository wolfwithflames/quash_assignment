import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:learning_mvvm/data/response/status.dart';
import 'package:learning_mvvm/res/components/shimmer_loading_grid_view.dart';
import 'package:learning_mvvm/utils/utils.dart';
import 'package:learning_mvvm/viewModel/crash_logs_view_model.dart';
import 'package:provider/provider.dart';
import 'package:quash_assignment/crash_logger.dart';

class CrashLogs extends StatefulWidget {
  const CrashLogs({super.key});

  @override
  State<CrashLogs> createState() => _CrashLogsState();
}

class _CrashLogsState extends State<CrashLogs> {
  CrashLogsViewModel _CrashLogsViewModel = CrashLogsViewModel();

  @override
  void initState() {
    _CrashLogsViewModel.fetchCrashLogs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Crash Logs"),
      ),
      persistentFooterButtons: [
        TextButton(
          onPressed: clearLogs,
          child: Text('Clear Logs'),
        ),
      ],
      body: ChangeNotifierProvider<CrashLogsViewModel>(
        create: (BuildContext context) =>
            _CrashLogsViewModel, // Create that object of CrashLogsViewModel, that we want to use
        child: Consumer<CrashLogsViewModel>(builder: (context, value, _) {
          debugPrint(value.apiResponse.status.toString());
          switch (value.apiResponse.status) {
            case Status.LOADING:
              return ShimmerLoadingGridView();
            case Status.ERROR:
              Utils.toastMessage(value.apiResponse.message.toString());
              return Container();

            case Status.COMPLETED:
              return logDataView(value.apiResponse.data!);
            default:
              return Container();
          }
        }),
      ),
    );
  }

  Future<void> clearLogs() async {
    await CrashLogger.clearCrashLogs();
    _CrashLogsViewModel.fetchCrashLogs();
  }

  Widget logDataView(List data) {
    if (data.isEmpty) {
      return Center(
        child: Text("No logs available"),
      );
    }
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return ExpansionTile(
          title: Text(
            "${index + 1}",
          ),
          children: [
            Text(data[index]),
            TextButton(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: data[index]));
                Utils.toastMessage("Copied");
              },
              child: Text("Copy"),
            ),
          ],
        );
      },
    );
  }
}
