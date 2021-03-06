import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'contact_info.dart';

import '../../../utils/fonts.dart';
import '../../../utils/print.dart';

class ContactListWidget extends StatelessWidget {
  static const String Id = "ContactListPage";
  final List<ContactInfo> mContactsList;

  const ContactListWidget({Key key, this.mContactsList}) : super(key: key);

  void fSortContactList() {
    mContactsList.sort((firstContact, secondContact) {
      if (firstContact.mId > secondContact.mId) {
        return 1;
      } else {
        return -1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print("ContactListPage:build:mContactsList.length=" +
        mContactsList.length.toString());
    fSortContactList();
    return Column(
        children: mContactsList.map((item) => _ContactListItem(item)).toList());
  }
}

class _ContactListItem extends ListTile {
  final ContactInfo contactInfo;

  _ContactListItem(this.contactInfo);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Divider(height: 15, color: gBrownColor),
          fPrintText(contactInfo.mName, gMenuItemTextStyle),
          Padding(padding: EdgeInsets.only(top: 5.0)),
          fBuildDescriptionRow(),
          fBuildTelRow(),
          fBuildEmailRow()
        ],
      ),
    );
  }

  Widget fBuildDescriptionRow() {
    if (contactInfo.mDescription == "" ||
        ["coordinator", "guide"].contains(contactInfo.mDescription)) {
      return fBuildNullWidget();
    }
    return Padding(
        padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
        child: Row(
          children: <Widget>[
            fBuildImage("assets/images/contacts/person.png", 20),
            Padding(padding: EdgeInsets.only(left: 20.0)),
            fPrintText(contactInfo.mDescription)
          ],
        ));
  }

  Widget fBuildTelRow() {
    if (contactInfo.mPhoneNumber == "") {
      return fBuildNullWidget();
    }
    return Padding(
        padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
        child: Row(
          children: <Widget>[
            fBuildImage("assets/images/contacts/phone.png", 20),
            Padding(padding: EdgeInsets.only(left: 20.0)),
            GestureDetector(
              child: fPrintText("tel. " + contactInfo.mPhoneNumber),
              onTap: () => launch("tel://" +
                  contactInfo.mPhoneNumber.replaceAll(new RegExp(r' '), '')),
            ),
          ],
        ));
  }

  Widget fBuildEmailRow() {
    if (contactInfo.mEmail == "") {
      return fBuildNullWidget();
    }
    return Padding(
        padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
        child: Row(
          children: <Widget>[
            fBuildImage("assets/images/contacts/email.png", 20),
            Padding(padding: EdgeInsets.only(left: 20.0)),
            GestureDetector(
                child: fPrintText(contactInfo.mEmail),
                onTap: () => launch("mailto://" + contactInfo.mEmail))
          ],
        ));
  }
}
