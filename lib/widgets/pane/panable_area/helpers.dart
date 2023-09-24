import 'package:celery_monitoring_core/constants.dart';

double boardYCoord(double timestamp, [double timestampOffset = 0]) {
  return (timestamp - timestampOffset) * paneTimestampMultiplier +
      paneTimestampOffsetY;
}
