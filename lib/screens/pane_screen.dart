import 'package:celeryviz_frontend_core/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:celeryviz_frontend_core/services/data_source.dart';
import 'package:celeryviz_frontend_core/states/pane_screen/pane_screen_bloc.dart';
import 'package:celeryviz_frontend_core/states/pane_screen/pane_screen_events.dart';
import 'package:celeryviz_frontend_core/states/pane_screen/pane_screen_state.dart';
import 'package:celeryviz_frontend_core/widgets/pane/pane.dart';

class PaneScreen extends StatelessWidget {
  final DataSource dataSource;

  const PaneScreen({super.key, required this.dataSource});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroudColor,
      child: BlocProvider(
        create: (_) => PaneScreenBloc(dataSource: dataSource),
        child: BlocBuilder<PaneScreenBloc, PaneScreenState>(
          builder: (context, state) {
            switch (state.status) {
              case PaneScreenStateStatus.loading:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case PaneScreenStateStatus.loaded:
                return Pane(
                  dataSource: state.dataSource,
                );
              case PaneScreenStateStatus.error:
                return const Center(
                  child: Text('Failed to load'),
                );
              case PaneScreenStateStatus.inactive:
                BlocProvider.of<PaneScreenBloc>(context)
                    .add(const PaneScreenLoadStart());
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
