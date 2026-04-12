/// All the visualizations are done by Pane
library;

import 'package:celeryviz_frontend_core/services/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:celeryviz_frontend_core/services/data_source.dart';
import 'package:celeryviz_frontend_core/states/pane/pane_bloc.dart';
import 'package:celeryviz_frontend_core/states/pane/pane_events.dart';
import 'package:celeryviz_frontend_core/states/pane/pane_state.dart';
import 'package:celeryviz_frontend_core/states/task_info/task_info_bloc.dart';
import 'package:celeryviz_frontend_core/widgets/pane/panable_area/panable_area.dart';

import 'package:celeryviz_frontend_core/widgets/pane/ruler.dart';
import 'package:celeryviz_frontend_core/widgets/pane/task_name_bar.dart';

/// This widget is used to display the Celeryviz visualization.
///
/// This widget provides all the necessary resources for the widgets in the
/// sub-tree.
///
/// It provides the [PaneBloc] and [TaskInfoBloc] BLoCs to the sub-tree.
/// Also, it handles loading states of the PaneBloc so that the child widget
/// [PaneLayout] is only rendered when the data is ready.
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
          return previous.isStarted != current.isStarted ||
              previous.isFirstEventReceived != current.isFirstEventReceived;
        },
        builder: (context, state) {
          if (state.isStarted && state.isFirstEventReceived) {
            return const PaneLayout();
          } else if (state.isStarted) {
            return const LoadingPage(message: "Waiting for events...");
          } else {
            return const LoadingPage(message: "Starting event stream...");
          }
        },
      ),
    );
  }
}

/// This widget is the main layout for the Celeryviz visualization.
///
/// It provides the [Ruler], [TaskNameBar], and [PanableArea] widgets to the
/// sub-tree.
///
/// It uses [NavigationTransformationController] to control the transformation
/// of the [PanableArea] and [Ruler] widgets.
class PaneLayout extends StatefulWidget {
  const PaneLayout({
    super.key,
  });

  @override
  State<PaneLayout> createState() => _PaneLayoutState();
}

class _PaneLayoutState extends State<PaneLayout>
    with SingleTickerProviderStateMixin {
  late NavigationTransformationController _transformationController;

  @override
  void initState() {
    super.initState();
    _transformationController = NavigationTransformationController(vsync: this);
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Ruler(
          transformationController: _transformationController,
          startTimestamp:
              BlocProvider.of<PaneBloc>(context).state.minTimestamp!,
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
  final String message;
  const LoadingPage({super.key, required this.message});

  Future<void> _start(BuildContext context) async {
    BlocProvider.of<PaneBloc>(context).add(const PaneStart());
  }

  @override
  Widget build(BuildContext context) {
    _start(context);
    // ignore: prefer_const_constructors
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message,
              style: const TextStyle(color: Colors.white, fontSize: 18)),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
