import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:celery_monitoring_core/services/data_source.dart';
import 'package:celery_monitoring_core/states/pane/pane_bloc.dart';
import 'package:celery_monitoring_core/states/pane/pane_events.dart';
import 'package:celery_monitoring_core/states/pane/pane_state.dart';
import 'package:celery_monitoring_core/states/task_info/task_info_bloc.dart';
import 'package:celery_monitoring_core/widgets/pane/panable_area/panable_area.dart';

import 'package:celery_monitoring_core/widgets/pane/ruler.dart';
import 'package:celery_monitoring_core/widgets/pane/task_name_bar.dart';

class Pane extends StatelessWidget {
  const Pane({
    super.key,
    required this.dataSource,
  });

  final DataSource dataSource;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PaneBloc>(
          create: (_) => PaneBloc(dataSource: dataSource),
        ),
        BlocProvider<TaskInfoBloc>(create: (_) => TaskInfoBloc()),
      ],
      child: BlocBuilder<PaneBloc, PaneState>(
        buildWhen: (previous, current) {
          return previous.isStarted != current.isStarted;
        },
        builder: (context, state) {
          if (state.isStarted) {
            return PaneLayout();
          } else {
            return const LoadingPage();
          }
        },
      ),
    );
  }
}

class PaneLayout extends StatelessWidget {
  PaneLayout({
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
              BlocProvider.of<PaneBloc>(context).state.timestampOffset!,
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
    BlocProvider.of<PaneBloc>(context).add(const PaneStart());
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
