import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:celeryviz_frontend_core/colors.dart';
import 'package:celeryviz_frontend_core/models/task_info.dart';
import 'package:celeryviz_frontend_core/services/services.dart';
import 'package:celeryviz_frontend_core/states/task_info/task_info_bloc.dart';
import 'package:celeryviz_frontend_core/states/task_info/task_info_event.dart';

class TaskInfoArea extends StatelessWidget {
  final TaskInfo taskInfo;

  const TaskInfoArea({Key? key, required this.taskInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Align(
        alignment: Alignment.topRight,
        child: IconButton(
          onPressed: () {
            BlocProvider.of<TaskInfoBloc>(context).add(const CloseTaskInfo());
          },
          icon: const Icon(Icons.close),
        ),
      ),
      Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FunctionName(name: taskInfo.name ?? '---'),
            TaskId(id: taskInfo.taskId ?? '---'),
            TaskStatusInfo(status: taskInfo.status),
            const Divider(
              height: 30,
            ),
            Timings(
              eta: taskInfo.etaTimestamp,
              startTime: taskInfo.startTimestamp,
              endTime: taskInfo.endTimestamp,
            ),
            const Divider(
              height: 30,
            ),
            CopyableData(title: "Args", data: taskInfo.args),
            CopyableData(title: "Kwargs", data: taskInfo.kwargs),
            CopyableData(title: "Result", data: taskInfo.result),
          ],
        ),
      ),
    ]);
  }
}

class FunctionName extends StatelessWidget {
  final String name;

  const FunctionName({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(name,
        style: const TextStyle(
            fontSize: 23, fontWeight: FontWeight.bold, color: Colors.orange));
  }
}

class TaskId extends StatelessWidget {
  final String id;

  const TaskId({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SelectionArea(
          child: Text(id,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black,
              )),
        ),
        IconButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: id));
              const snackBar = SnackBar(
                content: Text('Copied to clipboard'),
                duration: Duration(milliseconds: 800),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
            icon: const Icon(Icons.copy, size: 12))
      ],
    );
  }
}

class Timings extends StatelessWidget {
  final double? eta;
  final double? startTime;
  final double? endTime;

  const Timings({Key? key, this.eta, this.startTime, this.endTime})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(4),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(1),
          1: FlexColumnWidth(2),
        },
        children: [
          _getTableRow('ETA', _getTime(eta), context),
          _getTableRow('Start Time', _getTime(startTime), context),
          _getTableRow('End Time', _getTime(endTime), context),
        ],
      ),
    );
  }

  String _getTime(double? time) {
    return timestampToHumanReadable(
            time, DateFormat('HH:mm:ss, MMM dd, yyyy')) ??
        '---';
  }

  TableRow _getTableRow(String title, String data, BuildContext context) {
    return TableRow(children: [
      Text(
        title,
        style: TextStyle(
          color: Colors.grey[700],
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        data,
        textAlign: TextAlign.end,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    ]);
  }
}

class CopyableData extends StatelessWidget {
  final String title;
  final String? data;

  const CopyableData({Key? key, required this.title, this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(4),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[200],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.bold,
                  )),
              IconButton(
                constraints: BoxConstraints.tight(
                  const Size(15, 15),
                ),
                padding: EdgeInsets.zero,
                color: Colors.grey[700],
                onPressed: () {
                  if (data == null) return;
                  Clipboard.setData(ClipboardData(text: data!));
                  const snackBar = SnackBar(
                    content: Text('Copied to clipboard'),
                    duration: Duration(milliseconds: 800),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
                icon: const Icon(Icons.copy, size: 15),
              ),
            ],
          ),
          Divider(
            color: Colors.grey[800],
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: SelectionArea(
              child: Text(data ?? '',
                  style: GoogleFonts.sourceCodePro(
                    fontSize: 12,
                    color: Colors.grey[800],
                  )),
            ),
          ),
        ],
      ),
    );
  }
}

class TaskStatusInfo extends StatelessWidget {
  final TaskStatus status;

  const TaskStatusInfo({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(4),
      child: _getStatusWidget(),
    );
  }

  Widget _getStatusWidget() {
    switch (status) {
      case TaskStatus.scheduled:
        return _formatWidget(
            Icons.schedule_rounded, 'Scheduled', TaskStatusColors.scheduled);
      case TaskStatus.running:
        return _formatWidget(
            Icons.play_circle_rounded, 'Running', TaskStatusColors.running);
      case TaskStatus.failed:
        return _formatWidget(
            Icons.error_rounded, 'Failed', TaskStatusColors.failed);
      case TaskStatus.success:
        return _formatWidget(
            Icons.check_circle_rounded, 'Success', TaskStatusColors.success);
    }
  }

  Widget _formatWidget(IconData icon, String status, Color color) {
    return Align(
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          children: [
            WidgetSpan(
              child: Icon(
                icon,
                size: 22,
                color: color,
              ),
            ),
            const WidgetSpan(
              child: SizedBox(width: 5),
            ),
            TextSpan(
              text: status,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
