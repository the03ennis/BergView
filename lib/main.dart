import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'dining_objects.dart';
import 'networking.dart';

void main() {
  runApp(const ViewApp());
}

///The main application for the ViewApp, creates a [HomePage] for the user.
class ViewApp extends StatelessWidget {
  const ViewApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Wraps this in a MaterialApp in order to let the expansionpanel work.
    return const MaterialApp(
      title: "BergView",
      home: HomePage(),
    );
  }
}

///The HomePage for the widget, displaying today's food.
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

///A [State] for [HomePage], a [StatefulWidget]. This contains the actual build information.
///Uses a [FutureBuilder] built off of the [Future] of a [List] of [DiningLocation]s from the [APIConnector].
class _HomePageState extends State<HomePage> {
  ///A [Future] for the [List] of [DiningLocation]s that are fetched with the [APIConnector].
  ///Date initially defaults to today's date.
  Future<List<DiningLocation>> responseMap =
      APIConnector().fetchData(date: DateTime.now());
  @override
  Widget build(BuildContext context) {
    return BergScaffold(
        //The date picker to change the date for the menu
        middle: CupertinoDatePicker(
            //Only choose a date
            mode: CupertinoDatePickerMode.date,
            //Can't go more than 2 days in the past
            minimumDate: DateTime.now().subtract(const Duration(days: 2)),
            //Can't go more than 10 days in the future
            maximumDate: DateTime.now().add(const Duration(days: 10)),
            //Refresh the data when the date changes
            onDateTimeChanged: (date) => setState(() {
                  responseMap = APIConnector().fetchData(date: date);
                })),
        //A futurebuilder off of responseMap
        child: FutureBuilder<List<DiningLocation>>(
            future: responseMap,
            builder: (context, snapshot) {
              //If the call has already returned the data
              if (snapshot.hasData) {
                List<DiningLocation> locs = snapshot.data!;
                //If there are no locations, meaning there's no data for the day
                if (locs.isEmpty) {
                  return const Center(
                    child: Text("No data for today!"),
                  );
                }
                ScrollController scrollController = ScrollController();
                //Filter out locations with no meals listed, we don't want them shown
                locs.removeWhere((loc) => loc.meals.isEmpty);
                //Wraps the whole view to add the scrollview, with a common scrollcontroller
                return CupertinoScrollbar(
                  controller: scrollController,
                  child: SingleChildScrollView(
                    controller: scrollController,
                    //Lets each of the locations have a dropdown for meals
                    child: ExpansionPanelList(
                      //Called when a tile is tapped, changes the expansion state
                      expansionCallback: (panelIndex, isExpanded) {
                        setState(() {
                          snapshot.data![panelIndex].isExpanded = !isExpanded;
                        });
                      },
                      //Maps each location to an ExpansionPanel, generating the list
                      children: locs.map<ExpansionPanel>((DiningLocation loc) {
                        return ExpansionPanel(
                            canTapOnHeader: true,
                            isExpanded: loc.isExpanded,
                            headerBuilder: (context, isExpanded) {
                              //The main body is just the name of the location
                              return ListTile(title: Text(loc.locationName));
                            },
                            body: Column(
                              //When tapped, generate a ListTile for each meal
                              children: loc.meals.values
                                  .map<ListTile>((DiningMeal m) => ListTile(
                                        title: Text(m.mealName),
                                        //When the tile is tapped, take the meal, generate a MealPage, and present it to the user.
                                        onTap: () => Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                                builder: (context) =>
                                                    MealPage(meal: m))),
                                      ))
                                  .toList(),
                            ));
                      }).toList(),
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                //If the future has returned an error
                return Text(snapshot.error!.toString());
              } else {
                //If it's still loading
                return const Center(
                    child: CircularProgressIndicator.adaptive());
              }
            }));
  }
}

///A widget that uses an [ExpansionPanelList] to display information about the meal.
class MealPage extends StatefulWidget {
  const MealPage({Key? key, required this.meal}) : super(key: key);

  final DiningMeal meal;

  @override
  //unnecessary linting since it's not actually logic
  // ignore: no_logic_in_create_state
  _MealPageState createState() => _MealPageState(meal);
}

///A [State] for [MealPage]
class _MealPageState extends State<MealPage> {
  _MealPageState(this.meal);
  final DiningMeal meal;
  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();
    //Wraps everything in a BergScaffold to make life easier
    return BergScaffold(
      title: meal.mealName,
      //Same setup as HomePage
      child: CupertinoScrollbar(
        controller: scrollController,
        child: SingleChildScrollView(
          controller: scrollController,
          child: ExpansionPanelList(
            expansionCallback: (panelIndex, isExpanded) => setState(() =>
                meal.events.values.toList()[panelIndex].isExpanded =
                    !isExpanded),
            children: meal.events.values.map<ExpansionPanel>((DiningEvent e) {
              return ExpansionPanel(
                  isExpanded: e.isExpanded,
                  headerBuilder: (context, isExpanded) {
                    return ListTile(
                      title: Text(e.menuCategory),
                    );
                  },
                  body: Column(
                    children: e.recipes.map<ListTile>((DiningRecipe r) {
                      return ListTile(
                        title: Text(r.recipeName!),
                      );
                    }).toList(),
                  ));
            }).toList(),
          ),
        ),
      ),
    );
  }
}

///A helper [StatelessWidget] that simply includes a [CupertinoPageScaffold] and a [CupertinoNavigationBar].
///This way, we don't have to add them for each widget.
///The [SafeArea] keeps the content from disappearing under the nav bar.
class BergScaffold extends StatelessWidget {
  const BergScaffold(
      {Key? key, required this.child, this.title = "BergView", this.middle})
      : super(key: key);

  final Widget child;
  final String title;
  final Widget? middle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: middle ?? Text(title),
        ),
        child: SafeArea(child: child),
      ),
    );
  }
}
