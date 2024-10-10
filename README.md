# Celeryviz Frontend Core Library

This package is the part of [celeryviz](https://github.com/bhavya-tech/celeryviz) project.

This is the core library for the Celeryviz UI. It contains the code for rendering the visualisations and the logic for the frontend. This package can be used to wrap around other functional projects.


## Features
This package can take the celery events in JSON format and render the visualisation of the tasks and their dependencies. It can also show the task details and the logs of the tasks.

[**Live Demo**](https://bhavya-tech.github.io/celeryviz_demo/)

![demo](https://github.com/user-attachments/assets/67d1b4a3-653a-43da-8028-a8437424f70a)


## Getting started

This library is meant to be wrapped around other projects. Two examples are added in the `example` folder.

1. **ndjson_example**: This example shows how to use the library with the ndjson file. The ndjson file is the celery events in JSON format. The example reads the ndjson file and renders the visualisation.

2. **socketio_datasource**: This example shows how to use the library with the socketio connection with a running backend server. The backend server should be sending the celery events in JSON format. The example connects to the server and renders the visualisation.


## Usage
Check the [contributing guide](CONTRIBUTING.md/#development-environment-setup) for the setup and usage details.


## Additional information

Currently, this is used in [celeryviz_with_lib](https://github.com/bhavya-tech/celeryviz_with_lib) which is used to build packaged frontend for the Celeryviz python library. 

Further plan is to make a desktop application using this package. It will be a standalone application that can be used on development environment or connect to remote servers for monitoring them.

One more venture is to make a backend which can store the celery events and provide the data to the frontend as requested. This can be used to monitor the celery tasks in real-time and also to debug the past issues.