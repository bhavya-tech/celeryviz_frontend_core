import 'dart:math';

import 'package:celeryviz_frontend_core/services/navigation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:celeryviz_frontend_core/constants.dart';
import 'package:celeryviz_frontend_core/painters/pane_board.dart';
import 'package:celeryviz_frontend_core/states/pane/pane_bloc.dart';
import 'package:celeryviz_frontend_core/states/pane/pane_state.dart';
import 'package:celeryviz_frontend_core/widgets/pane/panable_area/interactive_area.dart';
import 'package:celeryviz_frontend_core/widgets/pane/task_info/task_info_container.dart';

class PanableArea extends StatelessWidget {
  static const _topPadding = (paneTimestampMultiplier) / 2 - eventDotRadius;

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
                maxScale: paneMaxScale,
                minScale: paneMinScale,
                constrained: false,
                scaleEnabled: false,
                transformationController: transformationController,
                child: BlocBuilder<PaneBloc, PaneState>(
                  builder: (context, state) {
                    double height = _getHeight(
                        state.currentTimestamp!, state.timestampOffset!);
                    double width =
                        _getWidth(state.data.tasks.length) / paneMinScale;
                    transformationController.updateBounds(
                        max(width - constraints.maxWidth, 0),
                        max(height - constraints.maxHeight, 0));
                    return SizedBox(
                      height: height,
                      width: width,
                      child: Padding(
                        padding: const EdgeInsets.only(top: _topPadding),
                        child: CustomPaint(
                          painter: SpawnedTaskLinesPainter(
                            tasks: state.data.tasks,
                            timestampOffset: state.timestampOffset!,
                            currentTimestamp: state.currentTimestamp!,
                          ),
                          child: InteractiveArea(
                            tasksMap: state.data.tasks,
                            timestampOffset: state.timestampOffset!,
                            currentTimestamp: state.currentTimestamp!,
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
    return taskCnt * paneEventMultiplier;
  }

  double _getHeight(double currentTimestamp, double timestampOffset) {
    return (currentTimestamp - timestampOffset) * paneTimestampMultiplier +
        paneTimestampOffsetY;
  }
}

class Naigation extends StatelessWidget {
  final NavigationTransformationController transformationController;
  final Widget child;
  const Naigation(
      {super.key, required this.transformationController, required this.child});

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerSignal: (event) {
        if (event is PointerScrollEvent) {
          transformationController.navigate(event.scrollDelta);
        }
      },
      child: KeyboardListener(
        focusNode: FocusNode(),
        autofocus: true,
        onKeyEvent: (event) {
          transformationController.navigateViaKeyboard(event);
        },
        child: child
       ),
    );
  }
}
