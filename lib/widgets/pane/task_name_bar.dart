/// Houses the widgets needed to show the horizontal task name bar above the
/// pane.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:celeryviz_frontend_core/config/celeryviz_options.dart';
import 'package:celeryviz_frontend_core/states/pane/pane_bloc.dart';
import 'package:celeryviz_frontend_core/states/pane/pane_state.dart';

/// This widget is used to display the horizontal task name bar above the pane.
///
/// This widget uses [PaneBloc] to listen for new tasks and shows each task
/// id using [TaskNameBarItem]. It also listens to the transformation controller
/// from the [PaneLayout] to update the scroll position of the task name bar.
///
/// This has been made stateful because we need the init and dispose lifecycle
/// methods to add and remove the subscription to the transformation controller.
class TaskNameBar extends StatefulWidget {
  final TransformationController transformationController;
  final ScrollController _scrollController = ScrollController();

  TaskNameBar({
    Key? key,
    required this.transformationController,
  }) : super(key: key);

  @override
  State<TaskNameBar> createState() => _TaskNameBarState();
}

class _TaskNameBarState extends State<TaskNameBar> {
  void _onPan() {
    widget._scrollController.jumpTo(
      -widget.transformationController.value.getTranslation().x,
    );
  }

  @override
  void initState() {
    super.initState();
    widget.transformationController.addListener(_onPan);
  }

  @override
  void dispose() {
    super.dispose();
    widget.transformationController.removeListener(_onPan);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withAlpha(20),
      height: CeleryvizOptions.config.tasknameBarHeight,
      child: BlocBuilder<PaneBloc, PaneState>(
        buildWhen: (previous, current) {
          return previous.data.taskIds != current.data.taskIds;
        },
        builder: (context, state) {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            controller: widget._scrollController,
            itemBuilder: (context, index) {
              if (index < state.data.taskIds.length) {
                return TaskNameBarItem(taskId: state.data.taskIds[index]);
              } else {
                return SizedBox(
                    width: CeleryvizOptions.config.paneEventMultiplier);
              }
            },
          );
        },
      ),
    );
  }
}

/// Widget for displaying task id in the task name bar.
///
/// This widget displays the first 8 characters of the task id.
class TaskNameBarItem extends StatelessWidget {
  final String taskId;

  const TaskNameBarItem({Key? key, required this.taskId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: CeleryvizOptions.config.tasknameBarHeight,
      width: CeleryvizOptions.config.paneEventMultiplier,
      child: Center(
        child: Text(
          taskId.substring(0, 8),
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .bodySmall!
              .copyWith(color: Colors.white.withAlpha(150)),
        ),
      ),
    );
  }
}
