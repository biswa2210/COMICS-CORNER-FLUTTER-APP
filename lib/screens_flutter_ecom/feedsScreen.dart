import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecom_project/models/product.dart';
import 'package:flutter_ecom_project/provider_flutter_ecom/products_setup.dart';
import 'package:flutter_ecom_project/screens_flutter_ecom/cart/cartPgScreen.dart';
import 'package:flutter_ecom_project/widgets_flutter_ecom/feeds_product.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider_flutter_ecom/darkTheme_setup.dart';
import '../provider_flutter_ecom/fav_provider_biswa2210.dart';
import '../provider_flutter_ecom/provider_for_cart.dart';
import 'wishlist/WishList_flutter_ecom.dart';
class FeedsScreen  extends StatefulWidget {
static const routeName = '/FeedsPg';

  @override
  State<FeedsScreen> createState() => _FeedsScreenState();
}

class _FeedsScreenState extends State<FeedsScreen> {
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
final productsProvider = Provider.of<Products>(context);
productsProvider.FetchProducts();
final popular = ModalRoute.of(context)!.settings.arguments as String;
List<Product> productList=productsProvider.products;
if(popular=='popular'){
      productList=productsProvider.popularProducts_fc;
}
final cartprovider=Provider.of<providerCart>(context);
final favprovider=Provider.of<FavsProvider>(context);

final themeChange =  Provider.of<DarkThemeSetup>(context);
return Scaffold(
      appBar: AppBar(
            backgroundColor: themeChange.darkTheme? Colors.black :switchState?Colors.deepPurple : Colors.orangeAccent,
            title: Text("Feeds Screen"),
            actions: [
                  Consumer<FavsProvider>(
                        builder:(_,favs,ch)=>Badge(
                              badgeColor: Colors.red,
                              animationType: BadgeAnimationType.slide,
                              toAnimate: true,
                              position: BadgePosition.topEnd(top: 5,end: 7),
                              badgeContent: Text(favprovider.getFavsItems.length.toString(),style: TextStyle(
                                  color: Colors.white
                              ),),
                              child: IconButton(
                                    icon: Icon(
                                          Icons.list,
                                          color: Colors.white,
                                    ),
                                    onPressed: () {
                                          Navigator.pushNamed(context,WishListScreen.routeName);
                                    },
                              ),
                        ),
                  ),
                  Consumer<providerCart>(
                        builder:(_,favs,ch)=>Badge(
                              badgeColor: Colors.red,
                              animationType: BadgeAnimationType.slide,
                              toAnimate: true,
                              position: BadgePosition.topEnd(top: 5,end: 7),
                              badgeContent: Text(cartprovider.getCartItems.length.toString(),style: TextStyle(
                                  color: Colors.white
                              ),),
                              child: IconButton(
                                    icon: Icon(
                                          FontAwesome5.shopping_cart,
                                          color: Colors.white,
                                    ),
                                    onPressed: () {
                                          Navigator.of(context).pushNamed(CartScreen.routeName);
                                    },
                              ),
                        ),)
            ],
      ),
  backgroundColor: Colors.white,
    body: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 240/420,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          children: List.generate(productList.length, (index) {
                return ChangeNotifierProvider.value(
                      value: productList[index],
                      child: Feeds_products(),);
          }),
    ),
);
}
}
