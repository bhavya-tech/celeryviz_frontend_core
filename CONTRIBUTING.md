# Contributing to CeleryViz

## Welcome to the Project! 🎉

Hey there! We are **thrilled** that you're thinking about contributing to our project. Your ideas, code, and feedback help make this even better, and we're excited to see what you'll bring to the table! 😄


## How to Get Started 🚀

Contributing is easy! Just follow these steps:


### Reporting Bugs

If you find a bug, please open an issue on GitHub with the following information:
- A clear and descriptive title.
- A detailed description of the problem, including steps to reproduce.
- Any relevant logs or screenshots.


### Suggesting Features

Got a wild idea? We want to hear it! Don’t hesitate to suggest cool new features or improvements. 🌈💡

Open an issue on GitHub with the following information:
- A clear and descriptive title.
- A detailed description of the enhancement, including use cases and benefits.


### Where to report
  - If the issue to be reported is on the frontend, report it on this repository. ([celeryviz_frontend_core](https://github.com/bhavya-tech/celeryviz_frontend_core/issues))

  - If the issue to be reported is in the python library, report it on [celeryviz](https://github.com/bhavya-tech/celeryviz).


### Submitting Pull Requests

1. 🍴 **Fork the repository**  
   Make a copy of this project under your GitHub account. You can do this by clicking the **Fork** button at the top right of the repo page.

2. 🖇️ **Clone your forked repository**

    Time to get the code on your local machine! Run this command:

    ```bash
    git clone https://github.com/your-username/celeryviz_frontend_core.git
    ```

3. 🖊️ **Create a branch**  

   Now that you have a copy, it's time to make some magic happen!  
   Create a new branch to work on your feature or bugfix:
    ```bash
    git checkout -b feature-branch
    ```

4. 🔨 **Make your changes**

   Get creative! Add your feature or fix that pesky bug. And remember: no idea is too small we appreciate everything!

5. 🧪 **Test your changes**

    ```bash
    pytest
    ```

6. 📬 **Send your changes to us**
    ```bash
    git commit -m "Description of your changes"
    git push origin feature-branch
    ```

7. 🔄 **Open a pull request on GitHub**  
   You're almost there! Head over to GitHub and open a pull request (PR) from your branch to the main repository.  

   Tell us about your awesome contribution, and we'll review it ASAP! 🚀  

   Don't forget to give it a nice title and description so we know what it’s all about. 😉


## First Time Contributing? No Worries! 😄
We know getting started can feel a bit overwhelming, we all have been there. But we've got your back! Follow our handy step-by-step guide above, and you'll be contributing like a pro in no time. And if you hit a snag, don't hesitate to ask for help — we're here to support you!


## Code of Conduct 👩‍💻👨‍💻
We want to keep our community as warm and welcoming as a cup of cutting chai on a rainy day! ☕🌧️🍵 Please take a moment to read and follow our [Code of Conduct](CODE_OF_CONDUCT.md) to help us maintain a respectful and positive environment for all contributors. ✨

⚠️ **Note:** The Code of Conduct will be strictly enforced. Any violations will be taken seriously, and appropriate action will be taken to maintain a safe and respectful community.


## Development Environment Setup

1. Clone this repository:
    ```bash
    git clone https://github.com/bhavya-tech/celeryviz_frontend_core.git
    ```

2. Run pub get to install dependencies:
    ```bash
    flutter pub get
    ```

3. Now for testing the changes, there are two ways:
    - It is better to use the flutter extension in vscode for running the examples. Also their debugging tools are very helpful.

    - Running on native platform is generally optimised and faster than running on web. i.e. if your OS is windows, then run the windows app, if on ubuntu, then run the linux app.

    - Though once the changes are tested on the native platform, it is better to test them on the web platform as well.
  

    1. Run the ndjson_example app. (Recommended)
        - This is faster and more convenient for testing changes, especially UI changes. It runs the saved `assets/recording.ndjson` file.

        ```bash
        cd example/ndjson_example
        flutter run
        ```

    2. Run the `socketio_datasource` example app.
        - This is to be used only when some changes are made to the socketio datasource related code.
        - This requires the backend to be running. (Refer to the [celeryviz](https://github.com/bhavya-tech/celeryviz?tab=readme-ov-file#usage))

        ```bash
        cd example/socketio_datasource
        flutter run
        ```


# Thank You! 🙌
You rock! 🤘 Thank you for contributing and helping us make this project even more awesome. We can't wait to see what you'll create!