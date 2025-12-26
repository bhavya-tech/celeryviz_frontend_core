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
              previous.timestampOffset != current.timestampOffset;
        },
        builder: (context, state) {
          if (state.isStarted && state.timestampOffset != null) {
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

class PaneLayout extends StatefulWidget {
  const PaneLayout({
    Key? key,
  }) : super(key: key);

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
  final String message;
  const LoadingPage({Key? key, required this.message}) : super(key: key);

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
