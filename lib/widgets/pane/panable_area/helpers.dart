import 'package:celeryviz_frontend_core/config/celeryviz_options.dart';

double boardYCoord(double timestamp, [double minTimestamp = 0]) {
  return (timestamp - minTimestamp) *
          CeleryvizOptions.config.paneTimestampMultiplier +
      CeleryvizOptions.config.paneTimestampOffsetY;
}
