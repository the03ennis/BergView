# bergview

A flutter application built for iOS designed to be a simple and easy way to see what is being served at Harvard's dining hall for the day.

[Dart Documentation can be found here.](https://the03ennis.github.io/bergview/doc/api/)

[Youtube video can be found here.](https://youtu.be/utfXvKBDICM)

## Application Use

Upon launching the app, you can see that it's a pretty simple thing: the main screen lists all of the dining locations for the day.
If you select any of the locations, you will be presented with a dropdown menu for each of the meals being served. Clicking on any of the meals will bring you to another screen, where the actual food items being served are delineated by what category they're in.

### Platform Adaptability

The cool thing about flutter is the fact that you can write one codebase and build it for different platforms.
While I've only looked at iOS, the codebase can in theory – with very few changes – simply be deployed to an android emulator. It may look a little odd because it's not normal to use the cupertino themes on android, but it is still functional.
The app can *very* easily be deployed to an iPad instead of a phone, and is platform-aware.

## Building the App

I have a feeling you may want to build and deploy the app yourself, so here's what you're going to do:

 - Download and install flutter either with brew or with [these instructions](https://docs.flutter.dev/get-started/install/macos).
 - Check your installation by running `flutter doctor` - fix any issues it comes up with, the documentation online is phenomenal. I've also found that the easiest way to install most dependencies is also through brew.
 - Download the flutter extension(s) for VS Code and open the project
 - open up `main.dart`, then in the bottom right select "start and ios simulator" from the device menu
 - Hit run and debug, and the app will build and deploy to the newly started simulator.

No configuration is really necessary beyond the initial setup of the VS code environment and the download and installation of XCode.
