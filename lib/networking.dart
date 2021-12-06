import 'dart:convert';

import 'authconstants.dart';
import 'dining_objects.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

const String host = "go.apis.huit.harvard.edu";
const String basePath = "/ats/dining/v3";

class APIConnector {
  //Creates the new client to make requests
  Client c = Client();

  ///Returns a [List] of [DiningLocation]s, which will be populated with [DiningEvent]s and [DiningRecipe]s
  Future<List<DiningLocation>> fetchData({required DateTime date}) async {
    Map<int, DiningLocation> locations = {};
    Map<String, String> dateHeader = {
      "date": DateFormat('MM/dd/yyyy').format(date)
    };
    //Establishes the futures for all of the responses, rethrowing errors as necessary.
    Future<Response> locResponseF = c
        .get(Uri.https(host, basePath + "/locations"),
            headers: AuthConstants.header)
        .onError((error, stackTrace) => throw error!);
    Future<Response> eventResponseF = c
        .get(Uri.https(host, basePath + "/events", dateHeader),
            headers: AuthConstants.header)
        .onError((error, stackTrace) => throw error!);
    Future<Response> recipeResponseF = c
        .get(Uri.https(host, basePath + "/recipes", dateHeader),
            headers: AuthConstants.header)
        .onError((error, stackTrace) => throw error!);

    //LOCATION PARSING
    //Awaits the response for the locations
    Response locResponse = await locResponseF;
    //Confirms proper response
    if (locResponse.statusCode != 200) {
      throw APIConnectorError(200, locResponse.statusCode, "/locations");
    }
    //Decodes the JSON returned from the API
    dynamic locJson = jsonDecode(locResponse.body);
    try {
      //Loops through each location returned in the JSON
      for (dynamic location in locJson) {
        //Tries to parse the json, catching error
        DiningLocation tempLoc = DiningLocation.fromJson(location);
        locations.putIfAbsent(tempLoc.locationNumber, () => tempLoc);
      }
    } on Exception catch (e) {
      //Rethrows a more helpful error if it can't parse
      throw APIParseError("locations", e);
    }

    //EVENT PARSING
    //Awaits response for the events
    Response eventResponse = await eventResponseF;
    if (eventResponse.statusCode != 200) {
      throw APIConnectorError(200, eventResponse.statusCode, "/events");
    }
    dynamic eventJson = jsonDecode(eventResponse.body);
    try {
      for (dynamic event in eventJson) {
        //Decodes the event
        DiningEvent dEvent = DiningEvent.fromJson(event);
        //Grabs the location number for the dining event and grabs the location
        int diningLocId = int.parse(event["location_number"]);
        DiningLocation loc = locations[diningLocId]!;
        //Puts the meal in the map if necessary
        loc.meals.putIfAbsent(
            dEvent.mealId, () => DiningMeal(dEvent.mealId, dEvent.mealName));
        //Adds this event to that locations id
        loc.meals[dEvent.mealId]!.events
            .putIfAbsent(dEvent.menuCategoryId, () => dEvent);
      }
    } on Exception catch (e) {
      throw APIParseError("events", e);
    }
    //RECIPE PARSING
    //Awaits repsonse for recipes
    Response recipeResponse = await recipeResponseF;
    if (recipeResponse.statusCode != 200) {
      throw APIConnectorError(200, recipeResponse.statusCode, "/recipes");
    }
    //Decodes the JSON from the response
    dynamic recipeJson = jsonDecode(recipeResponse.body);
    try {
      for (dynamic jsonRecipe in recipeJson) {
        //Converts the JSON to an object
        DiningRecipe recipe = DiningRecipe.fromJson(jsonRecipe);
        //Grabs the location for this recipe
        DiningLocation loc = locations[recipe.locationNumber]!;
        //Find the event for this recipe
        DiningMeal meal = loc.meals[recipe.mealNumber]!;
        DiningEvent event = meal.events[recipe.menuCategoryNumber]!;
        //Adds this recipe to this list of events
        event.recipes.add(recipe);
      }
    } on Exception catch (e) {
      throw APIParseError("recipes", e);
    }
    return locations.values.toList();
  }
}

///A class respresenting an [Exception] after the [APIConnector] makes a call that doesn't return as expected
class APIConnectorError implements Exception {
  int expectedCode;
  int actualCode;
  String apiCall;

  APIConnectorError(this.expectedCode, this.actualCode, this.apiCall);
  @override
  String toString() {
    return "API call to $apiCall returned unexpected code $actualCode, expected $expectedCode";
  }
}

///A class representing an [Exception] after the [APIConnector] can't parse something
class APIParseError implements Exception {
  String objectParsed;

  Exception parseException;

  APIParseError(this.objectParsed, this.parseException);

  @override
  String toString() =>
      "Error parsing $objectParsed from response: $parseException";
}
