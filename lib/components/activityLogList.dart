import 'package:easeinapp/api/handlers.dart';
import 'package:easeinapp/components/easein_strings.dart';
import 'package:easeinapp/components/empty_state.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

List activityLogListBuilder(BuildContext context, activityLogList) {
  final DateFormat formatter = DateFormat('dd MMMM h:mm a ');
  Size size = MediaQuery.of(context).size;
  int i = 0;
  return activityLogList != null &&  activityLogList.length > 0
      ? activityLogList.map((item) {
          i++;
          Map<String, dynamic> _user = item["user"];
          Map<String, dynamic> _business = item["business"];
          return item['isBusiness'] == true
              ? userInfoCardForBusiness(
                  item, size, _business, _user, formatter, i)
              : businessInfoCardForUser(
                  item, size, _business, _user, formatter, i);
        }).toList()
      : [emptyState(EaseinString.noActivityLogs,null)];
}

Widget userInfoCardForBusiness(item, size, _business, _user, formatter, i) {
  return Card(
      elevation: 20,
      color: Colors.deepPurpleAccent,
      shadowColor: Colors.black38,
      borderOnForeground: true,
      child: Container(
        margin: EdgeInsets.only(top: 10, right: 5, left: 5),
        padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  EaseinString.visitor,
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.white54,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  formatter
                      .format(new DateTime.fromMicrosecondsSinceEpoch(
                          int.parse(item["createdAt"]) * 1000))
                      .toString(),
                  style: TextStyle(fontSize: 12, color: Colors.white70),
                ),
              ],
            ),
            SizedBox(height: 10,),
            Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.brown.shade800,
                  child: Text(
                    avatarImage(_business["shopName"]),
                    key: new Key("avt_" + i.toString()),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Container(
                    width: size.width - 100,
                    child: Text(
                      _user["name"] == null ? "-" : _user["name"],
                      style: TextStyle(fontSize: 16, color: Colors.white),
                      overflow: TextOverflow.fade,
                    ))
              ],
            ),
            Row(
              children: <Widget>[
                SizedBox(
                  width: 60,
                ),
                Container(
                    width: size.width - 100,
                    child: Text(
                      _user["address"] != null ? _user["address"] : "NA",
                      style: TextStyle(fontSize: 14, color: Colors.white54),
                      overflow: TextOverflow.fade,
                    ))
              ],
            ),

          ],
        ),
      ));
}

Widget businessInfoCardForUser(item, size, _business, _user, formatter, i) {
  return Card(
      elevation: 20,
      color: Colors.green.shade600,
      shadowColor: Colors.black38,
      borderOnForeground: true,
      child: Container(
        margin: EdgeInsets.only(top: 10, right: 5, left: 5),
        padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  EaseinString.visited,
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.white54,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  formatter
                      .format(new DateTime.fromMicrosecondsSinceEpoch(
                          int.parse(item["createdAt"]) * 1000))
                      .toString(),
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.deepPurple,
                  child: Text(
                    avatarImage(_business["shopName"]),
                    style: TextStyle(color: Colors.white),
                    key: new Key("avt_" + i.toString()),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Container(
                    width: size.width - 100,
                    child: Text(
                      _business["shopName"] == null
                          ? "-"
                          : _business["shopName"],
                      style: TextStyle(fontSize: 18, color: Colors.white),
                      overflow: TextOverflow.fade,
                    ))
              ],
            ),
            SizedBox(
              height: 1,
            ),
            Row(
              children: <Widget>[
                SizedBox(
                  width: 60,
                ),
                Container(
                    width: size.width - 100,
                    child: Text(
                      _business["address"] != null
                          ? _business["address"]
                          : "NA",
                      style: TextStyle(fontSize: 14, color: Colors.white),
                      overflow: TextOverflow.fade,
                    ))
              ],
            ),
          ],
        ),
      ));
}

