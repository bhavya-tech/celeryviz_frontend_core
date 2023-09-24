import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:next_flower/services/data_source.dart';
import 'package:next_flower/states/pane/pane_bloc.dart';
import 'package:next_flower/states/pane/pane_events.dart';
import 'package:next_flower/states/pane/pane_state.dart';
import 'package:next_flower/widgets/pane/pane_board.dart';

class Pane extends StatelessWidget {
  final DataSource dataSource;

  const Pane({super.key, required this.dataSource});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
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
    );
  }
}
