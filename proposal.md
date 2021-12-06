# Proposal

## What will (likely) be the title of your project?

BergView

## In just a sentence or two, summarize your project. (E.g., "A website that lets you buy and sell stocks.")

Will provide an iOS and Apple Watch Widget to see what is being served at berg for the day.

## In a paragraph or more, detail your project. What will your software do? What features will it have? How will it be executed?

Using Google's flutter framework and swift, the app will communicate with [Harvard's dining API](https://portal.apis.huit.harvard.edu/docs/ats-dining/1/overview) to provide a [new widget](https://itnext.io/develop-an-ios-14-widget-in-flutter-with-swiftui-e98eaff2c606) for users to place on their home screen. Additionally, an [apple watch complication](https://flutter.dev/docs/development/platform-integration/apple-watch) will also provide what is on the menu. 

This will be done using a fun mixture of swift and dart - google's language for development. The nice thing about using flutter is that it can later be developed for android, adding in an android widget, while using the same underlying codebase for fetching information. That's a story for another time, though. 
I've already found an initial guide on building a widget with swift. The background processes are going to be interesting - I'm not exactly sure how to make that happen, but I think there's a scheulder feature. This will allow the widget to update every morning with the new information. Frankly, if you live in quincy, tough luck.
I'm going to need to register my application to get access to the API and use postman to test out my calls, but the website was being a little whacky when i just tried.


### In a sentence (or list of features), define a GOOD outcome for your final project. I.e., what WILL you accomplish no matter what?

An app that can be opened to display what is being served for the day.

### In a sentence (or list of features), define a BETTER outcome for your final project. I.e., what do you THINK you can accomplish before the final project's deadline?

A functional widget for the application on the home screen.

### In a sentence (or list of features), define a BEST outcome for your final project. I.e., what do you HOPE to accomplish before the final project's deadline?

Perhaps the aforementioned apple watch complication.

## In a paragraph or more, outline your next steps. What new skills will you need to acquire? What topics will you need to research? If working with one of two classmates, who will do what?

I am already familiar with dart and flutter, but I need to learn some more swift in order to get the widget or the complication doing.
Frankly, i have no clue how to program for the apple watch but maybe I'll figure it out (and maybe i won't).
