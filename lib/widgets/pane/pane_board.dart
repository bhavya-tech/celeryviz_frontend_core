import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider<PaneBoardBloc>(
          create: (_) => PaneBoardBloc(dataSource: dataSource),
        ),
        BlocProvider<TaskInfoBloc>(create: (_) => TaskInfoBloc()),
      ],
      child: BlocBuilder<PaneBoardBloc, PaneBoardState>(
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
    return Row(
      children: [
        Ruler(
          transformationController: _transformationController,
          startTimestamp:
              BlocProvider.of<PaneBoardBloc>(context).state.timestampOffset!,
        ),
        Expanded(
          child: Column(
            children: [
              TaskNameBar(
                transformationController: _transformationController,
              ),
              PanableArea(
                transformationController: _transformationController,
              ),
            ],
          ),
        ),
      ],
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
