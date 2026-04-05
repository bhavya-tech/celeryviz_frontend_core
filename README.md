# CeleryViz Frontend Core

> The core Flutter UI library for the [CeleryViz](https://github.com/bhavya-tech/celeryviz) project.

[![pub.dev](https://img.shields.io/badge/pub.dev-celeryviz__frontend__core-blue?logo=dart&logoColor=white)](https://pub.dev/packages/celeryviz_frontend_core)
[![License](https://img.shields.io/badge/license-Apache%202.0-blue?logo=apache&logoColor=white)](https://github.com/bhavya-tech/celeryviz_frontend_core/blob/main/LICENSE)
[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/bhavya-tech/celeryviz_frontend_core)

This package contains the rendering engine and UI logic behind CeleryViz. It consumes Celery events in JSON format and visualises task execution flow — showing tasks, their states, dependencies, and logs — in a clean, interactive interface. It is designed to be wrapped around other data-source projects rather than used standalone.

👉 **[Try the Live Demo](https://bhavya-tech.github.io/celeryviz_demo/)**

📦 **[Part of the CeleryViz ecosystem →](https://github.com/bhavya-tech/celeryviz)**

## Quick Start

Clone and install dependencies:

```bash
git clone https://github.com/bhavya-tech/celeryviz_frontend_core.git
cd celeryviz_frontend_core
flutter pub get
```

Run the recommended example (reads a local `.ndjson` recording — no backend needed):

```bash
cd example/ndjson_example
flutter run
```

Or run against a live backend via Socket.IO:

```bash
cd example/socketio_datasource
flutter run
```

📖 **[Full development setup guide →](https://github.com/bhavya-tech/celeryviz_frontend_core/blob/main/CONTRIBUTING.md#development-environment-setup)**

## What it does

- **Renders task flow:** Visualises Celery tasks, their states, and dependencies from a stream of JSON events
- **Real-time updates:** Connects to a live backend over Socket.IO and renders tasks as they execute
- **Offline replay:** Accepts `.ndjson` recordings so you can replay and inspect past task runs
- **Embeddable:** Designed as a library — wrap it around any data source (Socket.IO, file, custom)
- **Cross-platform:** Built with Flutter; runs on web, Linux, macOS, and Windows

## Examples

Two ready-to-run examples are included in the `example/` folder:

| Example | Description |
|---|---|
| `ndjson_example` | Reads a saved `.ndjson` recording of Celery events and renders the visualisation. Best for UI development. |
| `socketio_datasource` | Connects to a running CeleryViz backend over Socket.IO for live task monitoring. |

## Used by

This library powers **[celeryviz_with_lib](https://github.com/bhavya-tech/celeryviz_with_lib)**, which packages the frontend for the CeleryViz Python library.

## Roadmap

- **Desktop app:** A standalone desktop application for use in development environments or for connecting to remote servers
- **Persistent backend:** A backend that stores Celery events and serves them to the frontend on demand, enabling both real-time monitoring and historical debugging

## Contributing

Contributions are welcome! Please read [CONTRIBUTING.md](https://github.com/bhavya-tech/celeryviz_frontend_core/blob/main/CONTRIBUTING.md) before submitting a PR.

- **Frontend issues** → open an issue [here](https://github.com/bhavya-tech/celeryviz_frontend_core/issues)
- **Python library issues** → open an issue on [celeryviz](https://github.com/bhavya-tech/celeryviz/issues)

## License

[Apache 2.0](https://github.com/bhavya-tech/celeryviz_frontend_core/blob/main/LICENSE)

---

Instances of abusive, harassing, or otherwise unacceptable behavior may be reported to [bhavyapeshavaria@gmail.com](mailto:bhavyapeshavaria@gmail.com). All complaints will be reviewed and investigated promptly and fairly.