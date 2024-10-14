import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:celeryviz_frontend_core/constants.dart';
import 'package:celeryviz_frontend_core/states/pane/pane_bloc.dart';
import 'package:celeryviz_frontend_core/states/pane/pane_state.dart';

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
      height: tasknameBarHeight,
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
                return const SizedBox(width: paneEventMultiplier);
              }
            },
          );
        },
      ),
    );
  }
}

class TaskNameBarItem extends StatelessWidget {
  final String taskId;

  const TaskNameBarItem({Key? key, required this.taskId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: tasknameBarHeight,
      width: paneEventMultiplier,
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
