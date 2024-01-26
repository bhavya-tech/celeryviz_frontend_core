import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:celery_monitoring_core/constants.dart';
import 'package:celery_monitoring_core/painters/pane_board.dart';
import 'package:celery_monitoring_core/states/pane/pane_bloc.dart';
import 'package:celery_monitoring_core/states/pane/pane_state.dart';
import 'package:celery_monitoring_core/widgets/pane/panable_area/interactive_area.dart';
import 'package:celery_monitoring_core/widgets/pane/task_info/task_info_container.dart';

class PanableArea extends StatelessWidget {
  static const _topPadding = (paneTimestampMultiplier) / 2 - eventDotRadius;

  final TransformationController transformationController;
  const PanableArea({
    super.key,
    required this.transformationController,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(children: [
        InteractiveViewer(
          maxScale: paneMaxScale,
          minScale: paneMinScale,
          constrained: false,
          scaleEnabled: false,
          transformationController: transformationController,
          child: BlocBuilder<PaneBloc, PaneState>(
            builder: (context, state) {
              return SizedBox(
                height:
                    _getHeight(state.currentTimestamp!, state.timestampOffset!),
                width: _getWidth(state.data.workers.length) / paneMinScale,
                child: Padding(
                  padding: const EdgeInsets.only(top: _topPadding),
                  child: CustomPaint(
                    painter: SpawnedTaskLinesPainter(
                      workers: state.data.workers,
                      timestampOffset: state.timestampOffset!,
                      currentTimestamp: state.currentTimestamp!,
                    ),
                    child: InteractiveArea(
                      workersMap: state.data.workers,
                      timestampOffset: state.timestampOffset!,
                      currentTimestamp: state.currentTimestamp!,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const TaskInfoContainer(),
      ]),
    );
  }

  double _getWidth(int taskCnt) {
    return taskCnt * paneEventMultiplier;
  }

  double _getHeight(double currentTimestamp, double timestampOffset) {
    return (currentTimestamp - timestampOffset) * paneTimestampMultiplier +
        paneTimestampOffsetY;
  }
}
