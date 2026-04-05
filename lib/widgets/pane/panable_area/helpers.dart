import 'package:celeryviz_frontend_core/config/celeryviz_options.dart';

/// Returns the y-coordinate on the board corresponding to the given timestamp.
double boardYCoord(double timestamp, [double minTimestamp = 0]) {
  return (timestamp - minTimestamp) *
          CeleryvizOptions.config.paneTimestampMultiplier +
      CeleryvizOptions.config.paneTimestampOffsetY;
}
