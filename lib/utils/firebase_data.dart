import 'dart:async';
import 'dart:convert';
import 'shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:business_mobile_app/pages/home/contact/contact_page.dart';
import 'package:business_mobile_app/pages/trips/trips_page.dart';

const String gContactsDatabaseKey = "contacts";
const String gTripsDatabaseKey = "trips";

class FirebaseData {
  StreamController<bool> mStreamController;
  StreamSubscription<Event> mSubscription;
  DatabaseReference mRef;

  FirebaseData(String aDatabaseKey, dynamic aFunction, dynamic globalVariable) {
    mStreamController = new StreamController.broadcast();
    mRef = FirebaseDatabase.instance.reference().child(aDatabaseKey);
    mSubscription = mRef.onValue.listen((Event event) {
      print("FirebaseDataController:fSubscribe:listen:" + aDatabaseKey);
      globalVariable.clear();
      event.snapshot.value.forEach(aFunction);
      String globalVariableJson = jsonEncode(globalVariable);
      gPrefs.setString(aDatabaseKey, globalVariableJson);
      mStreamController.add(true);
    });
  }

  void fClose() {
    mStreamController.close();
    mSubscription.cancel();
  }
}

Map<String, FirebaseData> gFirebaseDataMap = new Map<String, FirebaseData>();

void fInitFirebaseData() {
  gFirebaseDataMap[gTripsDatabaseKey] =
      FirebaseData(gTripsDatabaseKey, fAddTripToList, gTripsList);
  gFirebaseDataMap[gContactsDatabaseKey] =
      FirebaseData(gContactsDatabaseKey, fAddContactToList, gContactsList);
}

Stream<bool> fGetStream(String key) {
  return gFirebaseDataMap[key].mStreamController.stream;
}

void fCloseStream(String key) {
  gFirebaseDataMap[key].mStreamController.close();
}

int fGetDatabaseId(dynamic aDatabaseId, int aDecimalsNumber) {
  String databaseIdString = aDatabaseId.toString();
  return int.parse(
      databaseIdString.substring(databaseIdString.length - aDecimalsNumber));
}
