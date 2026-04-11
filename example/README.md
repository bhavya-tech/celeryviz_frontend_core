# celeryviz_frontend_core Examples

This directory contains example Flutter apps demonstrating how to integrate
`celeryviz_frontend_core` into your own project.

## Quick Start

Each example is a standalone Flutter app. To run any of them:

```bash
cd example/<example_name>
flutter pub get
flutter run
```

---

## Examples

### 1. `ndjson_example`

**What it does:** Reads Celery events from a local `.ndjson` file and renders
the task visualization, no running backend is needed.

**Best for:** Offline development, testing with recorded event data, or
exploring the visualization without setting up a server.

**How to run:**
```bash
cd example/ndjson_example
flutter pub get
flutter run
```

If you need to run custom ndjson file, place your `.ndjson` file (Celery events in JSON format, one event per line)
in the app's assets folder and update the path in the app config.

---

### 2. `socketio_datasource`

**What it does:** Connects to a live backend server via Socket.IO and renders
the Celery task visualization in real-time as events stream in.

**Best for:** Monitoring a live Celery deployment, or testing with the
[celeryviz](https://github.com/bhavya-tech/celeryviz) Python backend.

**How to run:**
```bash
cd example/socketio_datasource
flutter pub get
flutter run
```

Make sure your backend server is running and emitting Celery events in JSON
format. Update the server URL in the app config before running if its not on localhost or standard port 9095.

---

## Minimal Integration Example

To use `celeryviz_frontend_core` in your own Flutter app:

**`pubspec.yaml`**
```yaml
dependencies:
  celeryviz_frontend_core: ^0.0.4
```

**`main.dart`**
```dart
import 'package:flutter/material.dart';
import 'package:celeryviz_frontend_core/celeryviz_frontend_core.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CeleryVizApp(
        dataSource: YourDataSource(), // plug in your own data source
      ),
    );
  }
}
```

See the individual example apps above for complete implementations using
an ndjson file or a Socket.IO connection.

---

## Related

- [celeryviz](https://github.com/bhavya-tech/celeryviz) : Python backend that
  emits Celery events consumed by this library.
- [celeryviz_with_lib](https://github.com/bhavya-tech/celeryviz_with_lib) :
  Packaged frontend built on top of this library.
- [Live Demo](https://bhavya-tech.github.io/celeryviz_demo/)