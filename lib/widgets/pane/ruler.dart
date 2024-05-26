import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:celeryviz_frontend_core/constants.dart';
import 'package:celeryviz_frontend_core/painters/ruler_marking_painter.dart';
import 'package:celeryviz_frontend_core/services/services.dart';

class Ruler extends StatefulWidget {
  /// This widget is used to display the ruler on the left side of the pane board.

  /// This has been made stateful because we need to listen to the transformation
  /// controller to update the ruler markings when the pane is translated or scaled.

  final double startTimestamp;
  final TransformationController transformationController;
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<double> _scaleNotifier = ValueNotifier(1.0);

  Ruler({
    Key? key,
    required this.startTimestamp,
    required this.transformationController,
  }) : super(key: key);

  @override
  State<Ruler> createState() => _RulerState();
}

class _RulerState extends State<Ruler> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withAlpha(20),
      width: rulerWidth,
      margin: const EdgeInsets.only(top: tasknameBarHeight),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        controller: widget._scrollController,
        itemBuilder: (context, index) {
          final timestamp = widget.startTimestamp + index;
          return ValueListenableBuilder<double>(
            valueListenable: widget._scaleNotifier,
            builder: (BuildContext context, double scale, Widget? child) {
              return RulerMarking(
                timestamp: timestamp,
                scale: scale,
              );
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    widget.transformationController.removeListener(_onPaneTranslate);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    widget.transformationController.addListener(_onPaneTranslate);
  }

  void _onPaneTranslate() {
    widget._scrollController.jumpTo(
      -widget.transformationController.value.getTranslation().y,
    );
    widget._scaleNotifier.value =
        widget.transformationController.value.getMaxScaleOnAxis();
  }
}

class RulerMarking extends StatelessWidget {
  final double timestamp;
  final double scale;

  const RulerMarking({
    Key? key,
    required this.timestamp,
    required this.scale,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final date = timestampToHumanReadable(
      timestamp,
      DateFormat('MMM dd, yyyy'),
    );
    final time = timestampToHumanReadable(
      timestamp,
      DateFormat('HH:mm:ss'),
    );
    return SizedBox(
      height: paneTimestampMultiplier * scale,
      width: rulerWidth,
      child: CustomPaint(
        painter: RulerMarkingPainter(),
        child: Tooltip(
          message: date,
          child: Center(
            child: Text(
              time!,
              textAlign: TextAlign.end,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Colors.white.withAlpha(150)),
            ),
          ),
        ),
      ),
    );
  }
}
