# bergview Design

BergView, as with any flutter application, is a fun combination of flutter widgets and behind-the-scenes dart. I'm not going to get into the specifics of [dart](dart.dev) and [flutter](flutter.dev), but the quick and dirty of it is that dart is essentially google's souped of programming language that is syntatically very similar to java. The advantage is that I find the documentation great, and community smaller, more tight-knit, and willing to help, and dart makes some things such as asynchronus programming *much* easier than Java does.

## Crash Course in Flutter
Flutter is the framework off which the application actually runs - it is built off of dart, and practically everything is a *widget*. Widgets are placed in a widget tree, and are displayed on the platform (web, android, iOS, macOS, etc.) as they are arranged in the `build` function.
Widgets are divided into *stateful* and *stateless* widgets, with *stateful* widgets keeping track of data of their own while *stateless* widgets hold other widgets and don't keep track of data – aka all variables defined are final.
Flutter comes with a built in collection of [*Cupertino* widgets](https://docs.flutter.dev/development/ui/widgets/cupertino), which is Apple's design language for iOS. Flutter mostly is built for [material apps,](https://material.io/), Google's own design spec, but it works for Cupertino apps as well.

## What I missed

I set out on this project *very* boldly, completely overestimating both my ability and flutter's capability.

### Apple Watch Complication

Frankly I'm not sure exactly what I was thinking. There's a distinct possibility a flutter app has *never* been built with an apple watch complication, and I certainly do not have the expertise to be the first one. Even in a native swift application, communicating with an apple watch can quickly become a disaster, and so I had to abandon my lofty goals.

### Home Screen Widget

I also got my hopes up with this, but I figured it would be slightly easier. Unfortunately, I was incorrect. The main issue was the communication between a widget that must be written in Swift and the Flutter application - it proved to be impossible for me.
There was, in theory, a library that should have made this very easy that I set out to use. However, when I couldn't even get their 'example' application to compile and work properly, I figured I certainly couldn't get to work for my own application.
Ultimately, I'm pretty disappointed with this. I spent a *lot* of time trying code and scouring StackOverflow, however I think the technology is just too new and not commonly used to be documented well. After corrupting the xcode workspace for the 17th time, I decided to just abandon hope and focus on the fundamentals of the application.

## bergview's Layout

As with any flutter project, this is a combination of behind-the-scenes dart and one main flutter-infused dart file.

### File Structure
All in all, there are only four files that I actually modified of the entire project, and they are as follows:
1. authconstants.dart
    - This file simply holds the client ID, since it's good practice to break these out. I'd ordinarily not check these into version control for security reasons, but this isn'ta particularly high-security application of the API.
2. dining_objects.dart
    - This file contains all of the schema for the objects I'm receiving from the dining API, including dining locations, meals, events, etc. The recipe class, for example, was constructed using an online service that takes the JSON returned from an API call and generates a dart class for it, complete with json encoding and decoding *factories* for the objects. 
3. networking.dart
    - This file contains a class for communication with the api, that pulls from authconstants.dart. There is really only one important method, fetchData - this returns a future of the list of dining locations, in which embedded is the list of meals, which contain events, which contain recipes. Ergo, this one function parses all of the information one could possibly need.
4. main.dart
    - This is really the only file that actually uses flutter. There are two different main widgets, with a couple of support widgets.
       - HomePage and HomePageState are what the app renders right off the bat. It automatically displays a loading screen until the data has been completely fetched and parsed, then displays the list of locations along with a date picker on the top that allows you to change the date with a few constraints. 
       - MealPage and MealPageState is another widget that, when given a meal, displays the events of that meal in a nice, pretty list. Each of the events are expanded by default to show all the recipes being served at that meal.
       - BergScaffold is a custom widget that simply helps with the display of the content - note it's a *stateless* widget. It doesn't take care of anything itself, simply serves as a container for other content.
