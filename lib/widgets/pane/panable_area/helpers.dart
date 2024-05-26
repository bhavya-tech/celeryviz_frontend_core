import 'package:celeryviz_frontend_core/constants.dart';

double boardYCoord(double timestamp, [double timestampOffset = 0]) {
  return (timestamp - timestampOffset) * paneTimestampMultiplier +
      paneTimestampOffsetY;
}
