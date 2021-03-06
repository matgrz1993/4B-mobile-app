import 'package:business_mobile_app/pages/trips/important_info/important_info_las_vegas.dart';
import 'package:business_mobile_app/pages/trips/important_info/important_info_thailand.dart';
import 'package:business_mobile_app/pages/trips/trips_page.dart';
import 'package:business_mobile_app/utils/trips_handlers.dart';
import 'package:flutter/material.dart';
import 'package:business_mobile_app/utils/widgets/silver_page_content.dart';

class ImportantInfoPage extends StatefulWidget {
  static const String Id = "ImporatantInfoPage";
  static const String Title = "Ważne informacje";
  @override
  _ImportantInfoPageState createState() => _ImportantInfoPageState();
}

class _ImportantInfoPageState extends State<ImportantInfoPage> {
  String appBarImageAssetPath;
  var importantInfoWidget;

  _ImportantInfoPageState() {
    if (isLasVegasTrip()) {
      importantInfoWidget = ImportantInfoLasVegasWidget();
      appBarImageAssetPath = "assets/images/imp_info_top_image.png";
    } else if (isThailandTrip()) {
      importantInfoWidget = ImportantInfoThailandWidget();
      appBarImageAssetPath = "assets/images/trips/thailand/appbar.jpg";
    }
  }

  Widget fBuildBody() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: importantInfoWidget.fBuild()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return fBuildSilverPage(
        appBarImageAssetPath, fBuildBody(), TripsPage.drawer);
  }
}
