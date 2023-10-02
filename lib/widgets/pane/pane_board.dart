import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:celery_monitoring_core/constants.dart';
import 'package:celery_monitoring_core/services/data_source.dart';
import 'package:celery_monitoring_core/states/pane_board/pane_board_bloc.dart';
import 'package:celery_monitoring_core/states/pane_board/pane_board_events.dart';
import 'package:celery_monitoring_core/states/pane_board/pane_board_state.dart';
import 'package:celery_monitoring_core/states/task_info/task_info_bloc.dart';
import 'package:celery_monitoring_core/widgets/pane/panable_area/panable_area.dart';

import 'package:celery_monitoring_core/widgets/pane/ruler.dart';
import 'package:celery_monitoring_core/widgets/pane/task_name_bar.dart';

class PaneBoardWrapper extends StatelessWidget {
  const PaneBoardWrapper({
    super.key,
    required this.dataSource,
  });

  final DataSource dataSource;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: MultiBlocProvider(
        providers: [
          BlocProvider<PaneBoardBloc>(
            create: (_) => PaneBoardBloc(dataSource: dataSource),
          ),
          BlocProvider<TaskInfoBloc>(create: (_) => TaskInfoBloc()),
        ],
        child: const StartPage(),
      ),
    );
  }
}

class PaneBoard extends StatelessWidget {
  PaneBoard({
    Key? key,
  }) : super(key: key);

  final TransformationController _transformationController =
      TransformationController();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      final widgetHeight = constraints.maxHeight;
      final widgetWidth = constraints.maxWidth;
      return Row(
        children: [
          SizedBox(
            width: rulerWidth,
            child: Ruler(
              transformationController: _transformationController,
              startTimestamp: BlocProvider.of<PaneBoardBloc>(context)
                  .state
                  .timestampOffset!,
            ),
          ),
          SizedBox(
            width: widgetWidth - rulerWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TaskNameBar(
                  transformationController: _transformationController,
                ),
                SizedBox(
                  height: widgetHeight - tasknameBarHeight,
                  width: widgetWidth - rulerWidth,
                  child: PanableArea(
                    transformationController: _transformationController,
                    areaHeight: widgetHeight - tasknameBarHeight,
                    areaWidth: widgetWidth - rulerWidth,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}

class StartPage extends StatelessWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaneBoardBloc, PaneBoardState>(
      buildWhen: (previous, current) {
        return previous.isStarted != current.isStarted;
      },
      builder: (context, state) {
        if (state.isStarted) {
          return PaneBoard();
        } else {
          return const LoadingPage();
        }
      },
    );
  }
}

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  Future<void> _start(BuildContext context) async {
    BlocProvider.of<PaneBoardBloc>(context).add(const PaneBoardStart());
  }

  @override
  Widget build(BuildContext context) {
    _start(context);
    return const Center(
      child: CircularProgressIndicator(
        color: Colors.white,
      ),
    );
  }
}
