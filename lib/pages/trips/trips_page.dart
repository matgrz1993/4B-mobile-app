import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:business_mobile_app/pages/trips/news/news_info.dart';
import 'package:business_mobile_app/pages/common/contact/contact_info.dart';
import 'package:business_mobile_app/pages/trips/schedule/day_tile.dart';
import 'package:business_mobile_app/pages/trips/schedule/event_info.dart';

import 'package:business_mobile_app/utils/trips_handlers.dart';

import 'trip_info.dart';
import 'schedule/schedule_page.dart';
import 'news/news_page.dart';
import 'about_country/about_country_page.dart';
import 'visited_places/visited_places_page.dart';
import 'important_info/important_info_page.dart';
import 'contact/contact_page.dart';
import '../home/home_page.dart';
import '../../utils/firebase_data.dart';
import '../../utils/shared_preferences.dart';
import '../../utils/widgets/menu_bar.dart';
import '../../utils/widgets/app_bar.dart';

var gTripsList = List<TripInfo>();
var gCurrentTripIndex = -1;

// ToDo: Do it prettier
List<NewsInfo> fGetNewsList() {
  return gTripsList[gCurrentTripIndex].mNewsList;
}

List<ContactInfo> fGetContactsList() {
  return gTripsList[gCurrentTripIndex].mContactsList;
}

List<DayTile> fGetDayTilesList() {
  return gTripsList[gCurrentTripIndex].mDayTiles;
}

void fGetTripsFromMemory() {
  String tripsJson = gPrefs.getString(gTripsDatabaseKey);
  if (tripsJson != null) {
    gTripsList.addAll(List<TripInfo>.from(jsonDecode(tripsJson)
        .map((aTripInfo) => TripInfo.fromJson(aTripInfo))));
  }
}

List<dynamic> fSortById(List<dynamic> aList) {
  aList.sort((firstItem, secondItem) {
    if (firstItem.mId > secondItem.mId) {
      return 1;
    } else {
      return -1;
    }
  });
  return aList;
}

List<DayTile> fSortDayTileList(List<DayTile> aDayTiles) {
  aDayTiles = fSortById(aDayTiles);
  aDayTiles.forEach((dayTile) {
    fSortById(dayTile.mEventsList);
  });
  return aDayTiles;
}

// ToDo: refactor this to use jsonDecode
void fAddTripToList(aTripId, aTripInfo) {
  int tripId = fGetDatabaseId(aTripId, 2);
  print("FirebaseData:fAddTripToList");
  var dayTiles = List<DayTile>();
  aTripInfo["schedule"].forEach((aDayTileId, aDayTile) {
    var eventInfoList = List<EventInfo>();
    aDayTile.forEach((aEventId, aEventInfo) {
      eventInfoList.add(EventInfo(
          fGetDatabaseId(aEventId, 2),
          aEventInfo['title'],
          DateTime.parse(aEventInfo["start_time"]),
          DateTime.parse(aEventInfo['end_time'])));
    });
    dayTiles.add(DayTile(fGetDatabaseId(aDayTileId, 2),
        fGetDatabaseId(aDayTileId, 2), eventInfoList));
  });
  dayTiles = fSortDayTileList(dayTiles);
  var news = List<NewsInfo>();
  if (aTripInfo["news"] != null) {
    aTripInfo["news"].forEach((aNewsId, aNewsInfo) {
      news.add(NewsInfo(fGetDatabaseId(aNewsId, 3), aNewsInfo['title'],
          aNewsInfo['body'], aNewsInfo['date']));
    });
  }
  news = fSortById(news);
  var contacts = List<ContactInfo>();
  if (aTripInfo["contacts"] != null) {
    aTripInfo["contacts"].forEach((aContactId, aContactInfo) {
      contacts.add(ContactInfo(
          fGetDatabaseId(aContactId, 2),
          aContactInfo['name'],
          aContactInfo['description'],
          aContactInfo['phone_number']));
    });
  }
  var tripInfo = TripInfo(tripId, aTripInfo["title"], aTripInfo["user_name"],
      aTripInfo["password"], dayTiles, news, contacts);
  tripInfo.fLog();
  gTripsList.add(tripInfo);
}

bool fIsTripLoginDataCorrect(String aUserName, String aPassword) {
  if (aUserName.length > 0 && aPassword.length > 0) {
    for (var tripIndex = 0; tripIndex < gTripsList.length; tripIndex++) {
      if (gTripsList[tripIndex].mUserName == aUserName &&
          gTripsList[tripIndex].mPassword == aPassword) {
        gCurrentTripIndex = tripIndex;
        return true;
      }
    }
  }
  return false;
}

class TripsPage extends StatelessWidget {
  static const String Id = "TripsPage";
  static const String Title = "Uczestniku, witamy w aplikacji!";
  static MenuBar drawer = MenuBar(<MenuItem>[
    MenuItem(AboutCountryPage.Id, AboutCountryPage.Title),
    MenuItem(VisitedPlacesPage.Id, VisitedPlacesPage.Title),
    MenuItem(SchedulePage.Id, SchedulePage.Title),
    MenuItem(ImportantInfoPage.Id, ImportantInfoPage.Title),
    MenuItem(NewsPage.Id, NewsPage.Title),
    MenuItem(TripContactPage.Id, TripContactPage.Title),
    MenuItem(HomePage.Id, "Wyloguj się"),
  ]);

  AssetImage fGetBackgroundImage() {
    if (isLasVegasTrip()) {
      return AssetImage("assets/images/trips/las_vegas/background.png");
    } else if (isThailandTrip()) {
      return AssetImage("assets/images/trips/thailand/background_essilor.png");
    }
  }

  Widget fBuildPage() {
    return Scaffold(
      appBar: fGetDefaultAppBar(TripsPage.Title),
      drawer: TripsPage.drawer,
      body: Container(
          decoration: BoxDecoration(
        image: DecorationImage(
          image: fGetBackgroundImage(),
          fit: BoxFit.cover,
        ),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return fBuildWillPopScope(fBuildPage());
  }
}
