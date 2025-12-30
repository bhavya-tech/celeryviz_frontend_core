import 'package:celeryviz_frontend_core/constants.dart';

double boardYCoord(double timestamp, [double minTimestamp = 0]) {
  return (timestamp - minTimestamp) * paneTimestampMultiplier +
      paneTimestampOffsetY;
}
