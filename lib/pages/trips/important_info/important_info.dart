import 'package:business_mobile_app/utils/expansion_tile.dart';
import 'package:business_mobile_app/utils/fonts.dart';
import 'package:business_mobile_app/utils/print.dart';
import 'package:business_mobile_app/utils/widgets/expand_all_tiles.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

const String gAirConnectionTitle = "Połączenia lotnicze";
const String gAirLineTitle = "Linia lotnicza";

abstract class ImportantInfoWidget {
  var mExpansionTileKeyList = List<GlobalKey<AppExpansionTileState>>();
  var mExpansionTileList = List<Widget>();

  void fAddExpansionTileToList(String aTitle, List<Widget> aChildrens) {
    mExpansionTileKeyList.add(GlobalKey());
    mExpansionTileList.add(fBuildExpansionTile(
        mExpansionTileKeyList[mExpansionTileKeyList.length - 1],
        aTitle,
        aChildrens));
  }

  Padding fBuildInsuranceRow(String aText) {
    return Padding(
      padding: EdgeInsets.only(top: 5, bottom: 5),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
      fPrintOkSign(),
      Padding(padding: EdgeInsets.only(left: 15)),
      Expanded(child: fPrintText(aText))
    ]));
  }

  Row fBuildShoppingRow(String aText, String aUrl) {
    return Row(
      children: <Widget>[
        fPrintOkSign(),
        Padding(padding: EdgeInsets.only(left: 15)),
        GestureDetector(
            onTap: () => launch(aUrl),
            child: Text(
              aText,
              style: TextStyle(
                  color: gBrownColor,
                  fontSize: 16,
                  decoration: TextDecoration.underline),
            )),
      ],
    );
  }

  Row fBuildFreeTimeRow(String aTitle, String aBody) {
    return Row(
      children: <Widget>[
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.black,
              ),
              children: <TextSpan>[
                TextSpan(
                    text: aTitle,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: aBody),
              ],
            ),
          ),
        )
      ],
    );
  }

  List<Widget> fBuildSimpleTextTile(String aAirLine) {
    return <Widget>[
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
        Expanded(child: fPrintText(aAirLine)),
      ])
    ];
  }

  Column fBuildInfoTiles();

  List<Widget> fBuild() {
    return <Widget>[
      Padding(padding: EdgeInsets.only(top: 10)),
      fPrintHeadingText("Ważne informacje"),
      Padding(padding: EdgeInsets.only(top: 10)),
      ExpandAllTilesWidget(mExpansionTileKeyList),
      Padding(padding: EdgeInsets.all(10)),
      fBuildInfoTiles(),
      Padding(padding: EdgeInsets.only(top: 20)),
    ];
  }
}
