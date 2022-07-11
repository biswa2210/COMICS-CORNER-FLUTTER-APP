import 'package:flutter/material.dart';
import 'package:flutter_ecom_project/provider_flutter_ecom/darkTheme_setup.dart';
import 'package:flutter_ecom_project/provider_flutter_ecom/fav_provider_biswa2210.dart';

import 'package:flutter_ecom_project/screens_flutter_ecom/wishlist/wishlist_empty_screen(fllutter_ecom).dart';
import 'package:flutter_ecom_project/screens_flutter_ecom/wishlist/wishlist_full_flutter_ecom.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WishListScreen extends StatefulWidget {
  static const routeName = '/WishListPg';
  @override
  State<WishListScreen> createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
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
    _getSwitchState();
    final favsProvider =Provider.of<FavsProvider>(context);
    final themeChange =  Provider.of<DarkThemeSetup>(context);
    return favsProvider.getFavsItems.isEmpty? Scaffold(body: WishListEmpty(),):Scaffold(
      appBar: AppBar(
        backgroundColor: switchState?Colors.deepPurple:Colors.orangeAccent,
        title: Text(switchState?'Wishlist (${favsProvider.getFavsItems.length})':'Favourites (${favsProvider.getFavsItems.length})',style: TextStyle(color:switchState?Colors.white:Colors.black),),
      ),
      body: ListView.builder(
        itemCount: favsProvider.getFavsItems.length,
        itemBuilder: (BuildContext ctx, int index) {
          return ChangeNotifierProvider.value(
              value: favsProvider.getFavsItems.values.toList()[index],
              child: WishListFull(
                productId: favsProvider.getFavsItems.keys.toList()[index],
              ));;
        },
      ),
    );
  }
}

