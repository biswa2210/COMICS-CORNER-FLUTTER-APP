import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecom_project/models/product.dart';
import 'package:flutter_ecom_project/provider_flutter_ecom/darkTheme_setup.dart';
import 'package:flutter_ecom_project/provider_flutter_ecom/fav_provider_biswa2210.dart';
import 'package:flutter_ecom_project/provider_flutter_ecom/products_setup.dart';
import 'package:flutter_ecom_project/screens_flutter_ecom/cart/cartPgScreen.dart';
import 'package:flutter_ecom_project/screens_flutter_ecom/wishlist/WishList_flutter_ecom.dart';
import 'package:flutter_ecom_project/widgets_flutter_ecom/feeds_product.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider_flutter_ecom/provider_for_cart.dart';


const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    //'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);
class ProductDetails extends StatefulWidget {
  static const routeName = '/ProductDetails';
  const ProductDetails({Key? key}) : super(key: key);
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
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
    final themeChange = Provider.of<DarkThemeSetup>(context);
    final themeState =  Provider.of<DarkThemeSetup>(context);
    final productsProvider = Provider.of<Products>(context);
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final prodAttr = productsProvider.findById(productId);
    final cartprovider=Provider.of<providerCart>(context);
    final favprovider=Provider.of<FavsProvider>(context);
    List<Product> productList=productsProvider.products;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            foregroundDecoration: BoxDecoration(color: Colors.black12),
            height: MediaQuery.of(context).size.height * 0.45,
            width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0,3,0,33),
                child: Container(
                  child: Image.network(
                    prodAttr.imageUrl,
                      fit: BoxFit.fitHeight,
                  ),
                ),
              )
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.only(top: 16.0, bottom: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 250),
                Container(
                  //padding: const EdgeInsets.all(16.0),
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: Text(
                                '${prodAttr.title}',
                                maxLines: 2,
                                style: TextStyle(
                                  // color: Theme.of(context).textSelectionColor,
                                  fontSize: 28.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              'RS: ${prodAttr.price}/-',
                              style: TextStyle(
                                  color: themeState.darkTheme
                                      ? Theme.of(context).disabledColor
                                      : Colors.black54,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 21.0),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 3.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Divider(
                          thickness: 1,
                          color: Colors.grey,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          '${prodAttr.description}',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 21.0,
                            color: themeState.darkTheme
                                ? Theme.of(context).disabledColor
                                : Colors.black54,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Divider(
                          thickness: 1,
                          color: Colors.grey,
                          height: 1,
                        ),
                      ),
                      _details(themeState.darkTheme, 'Brand: ', '${prodAttr.brand}'),
                      _details(themeState.darkTheme, 'Quantity: ','${prodAttr.quantity}'),
                      _details(themeState.darkTheme, 'Category: ','${prodAttr.productCategoryName}'),
                      _details(themeState.darkTheme, 'Popularity: ','${prodAttr.isPopular}' ),
                      SizedBox(
                        height: 15,
                      ),
                      Divider(
                        thickness: 1,
                        color: Colors.grey,
                        height: 1,
                      ),

                      // const SizedBox(height: 15.0),
                    ],
                  ),
                ),
                // const SizedBox(height: 15.0),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(8.0),
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Text(
                    'Suggested products:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 30),
                  width: double.infinity,
                  height: 355,
                  child: ListView.builder(
                    itemCount: productList.length<7 ? productList.length :7,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext ctx, int index) {
                      return ChangeNotifierProvider.value(
                        value: productList[index],
                        child: Feeds_products(),);
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: true,
                title: Text(
                  "DETAIL",
                  style:
                  TextStyle(fontFamily: 'MR',fontSize: 26.0, fontWeight: FontWeight.normal,color:  themeChange.darkTheme ? Colors.black :switchState? Colors.purple:Colors.orange),
                ),
                actions: <Widget>[
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
                          color: themeChange.darkTheme ? Colors.black :switchState? Colors.purple:Colors.orange,
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
                        FontAwesome5.cart_plus,
                        color: themeChange.darkTheme ? Colors.black :switchState? Colors.purple:Colors.orange,
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed(CartScreen.routeName);
                      },
                    ),
                  ),),
                ]),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Row(children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    height: 50,
                    child: RaisedButton(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(side: BorderSide.none),
                      color: Colors.blue,
                      onPressed:cartprovider.getCartItems.containsKey(productId)?
                        (){}:
                            (){
                        cartprovider.addProductToCart(productId, prodAttr.price, prodAttr.title, prodAttr.imageUrl);
                        flutterLocalNotificationsPlugin.show(  0,
                            "Go,For Checkout",
                            "Your cart is updated, please complete your payment.",
                            NotificationDetails(
                                android: AndroidNotificationDetails(channel.id, channel.name,
                                    importance: Importance.high,
                                    color: Colors.blue,
                                    playSound: true,
                                    icon: "@mipmap/ic_launcher"
                                )));
                      },
                      child: Text(
                        cartprovider.getCartItems.containsKey(productId)
                            ? 'In cart'
                            : 'Add to Cart'.toUpperCase(),
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 50,
                    child: RaisedButton(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(side: BorderSide.none),
                      color: Theme.of(context).backgroundColor,
                      onPressed: () {
                        cartprovider.addProductToCart(productId, prodAttr.price, prodAttr.title, prodAttr.imageUrl);
                        flutterLocalNotificationsPlugin.show(  0,
                            "Cart Updated",
                            "Now, please complete the payment method..",
                            NotificationDetails(
                                android: AndroidNotificationDetails(channel.id, channel.name,
                                    importance: Importance.high,
                                    color: Colors.blue,
                                    playSound: true,
                                    icon: '@mipmap/ic_launcher')));
                        Navigator.pushNamed(context, CartScreen.routeName);
                      },
                      child: Row(
                        children: [
                          Text(
                            'Buy now'.toUpperCase(),
                            style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).textSelectionColor),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.payment,
                            color: Colors.green.shade700,
                            size: 19,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    color: themeState.darkTheme
                        ? Theme.of(context).disabledColor
                        : Colors.black54,
                    height: 50,
                    child: InkWell(
                      splashColor: Colors.black54,
                      onTap: () {
                        favprovider.addAndRemoveFromFav(productId, prodAttr.price, prodAttr.title, prodAttr.imageUrl);
                      },
                      child: Center(
                        child: Icon(
                          Icons.favorite,
                          color:favprovider.getFavsItems.containsKey(productId) ? themeChange.darkTheme ? Colors.black :switchState? Colors.purple:Colors.orange : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ]))
        ],
      ),
    );
  }


Widget _details(bool themeState, String title, String info) {
  return Padding(
    padding: const EdgeInsets.only(top: 15, left: 16, right: 16),
    child: Row(
      //  mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
              color: Theme.of(context).textSelectionColor,
              fontWeight: FontWeight.w600,
              fontSize: 21.0),
        ),
        Text(
          info,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 20.0,
            color: themeState
                ? Theme.of(context).disabledColor
                : Colors.black54,
          ),
        ),
      ],
    ),
  );
}
}
