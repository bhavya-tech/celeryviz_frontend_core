/// The panable area handles the user interactions to move around the view.
library;

import 'dart:math';

import 'package:celeryviz_frontend_core/services/navigation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:celeryviz_frontend_core/config/celeryviz_options.dart';
import 'package:celeryviz_frontend_core/painters/pane_board.dart';
import 'package:celeryviz_frontend_core/states/pane/pane_bloc.dart';
import 'package:celeryviz_frontend_core/states/pane/pane_state.dart';
import 'package:celeryviz_frontend_core/widgets/pane/panable_area/interactive_area.dart';
import 'package:celeryviz_frontend_core/widgets/pane/task_info/task_info_container.dart';

/// Provides the [InteractiveViewer] widget with along with other widgets for
/// the user interaction.
///
/// - The [InteractiveViewer] widget is used to pan and zoom the view.
/// - The [Naigation] widget is used to handle movements in other forms like
///   mousewheel and keyboard.
/// - The [TaskInfoContainer] is the sidesheet to display task information.
///
/// This widget listens to the [PaneBloc] for new events to re-render the celery
/// task columns for the new events. (This can be optimised to only re-render
/// the task column for the event received)
///
/// Also, it paints the curved lines from the parent's task produced event to
/// child's task received event using [SpawnedTaskLinesPainter]. (It needs to be
/// here because the lines are drawn between two different task columns)
class PanableArea extends StatelessWidget {
  static double get _topPadding =>
      (CeleryvizOptions.config.paneTimestampMultiplier) / 2 -
      CeleryvizOptions.config.eventDotRadius;

  final NavigationTransformationController transformationController;
  const PanableArea({
    super.key,
    required this.transformationController,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(children: [
            Naigation(
              transformationController: transformationController,
              child: InteractiveViewer(
                maxScale: CeleryvizOptions.config.paneMaxScale,
                minScale: CeleryvizOptions.config.paneMinScale,
                constrained: false,
                scaleEnabled: false,
                transformationController: transformationController,
                child: BlocBuilder<PaneBloc, PaneState>(
                  builder: (context, state) {
                    double height =
                        _getHeight(state.maxTimestamp!, state.minTimestamp!);
                    double width = _getWidth(state.data.tasks.length) /
                        CeleryvizOptions.config.paneMinScale;
                    transformationController.updateBounds(
                        max(width - constraints.maxWidth, 0),
                        max(height - constraints.maxHeight, 0));
                    return SizedBox(
                      height: height,
                      width: width,
                      child: Padding(
                        padding: EdgeInsets.only(top: _topPadding),
                        child: CustomPaint(
                          painter: SpawnedTaskLinesPainter(
                            tasks: state.data.tasks,
                            minTimestamp: state.minTimestamp!,
                            maxTimestamp: state.maxTimestamp!,
                          ),
                          child: InteractiveArea(
                            tasksMap: state.data.tasks,
                            minTimestamp: state.minTimestamp!,
                            maxTimestamp: state.maxTimestamp!,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const TaskInfoContainer(),
          ]);
        },
      ),
    );
  }

  double _getWidth(int taskCnt) {
    return taskCnt * CeleryvizOptions.config.paneEventMultiplier;
  }

  double _getHeight(double maxTimestamp, double minTimestamp) {
    return (maxTimestamp - minTimestamp) *
            CeleryvizOptions.config.paneTimestampMultiplier +
        CeleryvizOptions.config.paneTimestampOffsetY;
  }
}

/// Handles the navigation events in other methods other than panning the
/// InteractiveViewer.
///
/// - Mouse scroll wheel to scroll vertically (and horizontally if mouse has
///   horizontal scroll)
class Naigation extends StatelessWidget {
  final NavigationTransformationController transformationController;
  final Widget? child;
  const Naigation(
      {super.key, required this.transformationController, this.child});

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerSignal: (event) {
        if (event is PointerScrollEvent) {
          transformationController.navigate(event.scrollDelta);
        }
      },
      child: child,
    );
  }
}
