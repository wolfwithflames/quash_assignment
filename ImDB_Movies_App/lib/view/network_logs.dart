import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:learning_mvvm/data/response/status.dart';
import 'package:learning_mvvm/res/components/shimmer_loading_grid_view.dart';
import 'package:learning_mvvm/utils/utils.dart';
import 'package:learning_mvvm/view%20model/network_logs_view_model.dart';
import 'package:provider/provider.dart';
import 'package:quash_assignment/dio_logger.dart';

class NetworkLogs extends StatefulWidget {
  const NetworkLogs({super.key});

  @override
  State<NetworkLogs> createState() => _NetworkLogsState();
}

class _NetworkLogsState extends State<NetworkLogs> {
  NetworkLogsViewModel _networkLogsViewModel = NetworkLogsViewModel();

  @override
  void initState() {
    _networkLogsViewModel.fetchMoviesList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Network Logs"),
      ),
      persistentFooterButtons: [
        TextButton(
          onPressed: clearLogs,
          child: Text('Clear Logs'),
        ),
      ],
      body: ChangeNotifierProvider<NetworkLogsViewModel>(
        create: (BuildContext context) =>
            _networkLogsViewModel, // Create that object of NetworkLogsViewModel, that we want to use
        child: Consumer<NetworkLogsViewModel>(builder: (context, value, _) {
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
    await DioLogger().clearLogs();
    _networkLogsViewModel.fetchMoviesList();
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
            DateTime.fromMillisecondsSinceEpoch(data[index]['createdAt'])
                .toString(),
          ),
          children: [
            childData("Request", data[index]['request'], index),
            childData("Response", data[index]['response'], index),
          ],
        );
      },
    );
  }

  ExpansionTile childData(String title, dynamic data, int index) {
    return ExpansionTile(
      title: Text(
        title,
      ),
      children: [
        Text(
          getEncodedString(data),
        ),
        TextButton(
          onPressed: () async {
            await Clipboard.setData(ClipboardData(text: "your text"));
            Utils.toastMessage("Copied");
          },
          child: Text("Copy"),
        ),
      ],
    );
  }

  getEncodedString(dynamic value) {
    final JsonEncoder encoder = const JsonEncoder.withIndent("     ");
    return encoder.convert(value);
  }
}
