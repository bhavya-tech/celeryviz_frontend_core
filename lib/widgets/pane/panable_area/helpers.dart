import 'package:next_flower/constants.dart';

double boardYCoord(double timestamp, [double timestampOffset = 0]) {
  return (timestamp - timestampOffset) * paneTimestampMultiplier +
      paneTimestampOffsetY;
}
