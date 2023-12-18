import 'package:celery_monitoring_core/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:celery_monitoring_core/services/data_source.dart';
import 'package:celery_monitoring_core/states/pane/pane_bloc.dart';
import 'package:celery_monitoring_core/states/pane/pane_events.dart';
import 'package:celery_monitoring_core/states/pane/pane_state.dart';
import 'package:celery_monitoring_core/widgets/pane/pane_board.dart';

class Pane extends StatelessWidget {
  final DataSource dataSource;

  const Pane({super.key, required this.dataSource});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroudColor,
      child: BlocProvider(
        create: (_) => PaneBloc(dataSource: dataSource),
        child: BlocBuilder<PaneBloc, PaneState>(
          builder: (context, state) {
            switch (state.status) {
              case PaneStateStatus.loading:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case PaneStateStatus.loaded:
                return PaneBoardWrapper(
                  dataSource: state.dataSource,
                );
              case PaneStateStatus.error:
                return const Center(
                  child: Text('Failed to load'),
                );
              case PaneStateStatus.inactive:
                BlocProvider.of<PaneBloc>(context).add(const PaneLoadStart());
                return const Center(
                  child: Text('Inactive'),
                );
              default:
                return const Center(
                  child: Text('Unhandled case'),
                );
            }
          },
        ),
      ),
    );
  }
}
