import 'package:flutter/material.dart';
import 'package:flutter_ecom_project/inner_screens_flutter_ecom/product_details_flutter_ecom.dart';
import 'package:flutter_ecom_project/models/fav_attribute_biswa2210.dart';
import 'package:flutter_ecom_project/provider_flutter_ecom/fav_provider_biswa2210.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stylish_dialog/stylish_dialog.dart';
class WishListFull extends StatefulWidget {
  final String productId;

  const WishListFull({required this.productId});
  @override
  _WishListFullState createState() => _WishListFullState();
}

class _WishListFullState extends State<WishListFull> {
  bool switchState=false;
  _getSwitchState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      switchState = prefs.getBool('switchState')?? false;
      print(switchState);
    });
  }
  @override
  Widget build(BuildContext context) {
    final favAttr = Provider.of<FavsAttr>(context);
    final favProvider = Provider.of<FavsProvider>(context);
    return Stack(
      children: <Widget>[
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(right: 30.0, bottom: 10.0),
          child: Material(
            color: Theme.of(context).backgroundColor,
            borderRadius: BorderRadius.circular(5.0),
            elevation: 3.0,
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, ProductDetails.routeName,arguments: widget.productId);
              },
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  children: <Widget>[
                    Container(
                      height: 80,
                      child: Image.network(
                        favAttr.imageUrl
                  ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '${favAttr.title}',
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            '\u{20B9} ${favAttr.price}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18.0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        positionedRemove(favAttr.title),
      ],
    );
  }
  Widget positionedRemove(String title) {
    _getSwitchState();
    final favsProvider = Provider.of<FavsProvider>(context);
    return Positioned(
      top: 20,
      right: 15,
      child: Container(
        height: 30,
        width: 30,
        child: MaterialButton(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          padding: EdgeInsets.all(0.0),
          color: switchState?Colors.deepPurple:Colors.orangeAccent,
          child: Icon(
            Icons.clear,
            color: Colors.white,
          ),
          onPressed: () {
            StylishDialog(
              context: context,
              alertType: StylishDialogType.PROGRESS,
              titleText: "Are you sure to delete ${title}?",
                titleStyle: TextStyle(color: Colors.black),
                confirmPressEvent: () {
              //Dismiss stylish dialog
                  favsProvider.removeItem(widget.productId);
              Navigator.of(context).pop();
                  StylishDialog(
                    context: context,
                    alertType: StylishDialogType.SUCCESS,
                    titleText: "Deleted Successfully",
                    titleStyle: TextStyle(color: Colors.black)
                  ).show();
            },
            ).show();

          },
        ),
      ),
    );
  }
}
