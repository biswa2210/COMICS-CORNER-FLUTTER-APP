import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecom_project/inner_screens_flutter_ecom/product_details_flutter_ecom.dart';
import 'package:flutter_ecom_project/models/product.dart';
import 'package:flutter_ecom_project/provider_flutter_ecom/products_setup.dart';
import 'package:flutter_ecom_project/provider_flutter_ecom/provider_for_cart.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider_flutter_ecom/darkTheme_setup.dart';
import '../screens_flutter_ecom/feeds_dialog_fecom.dart';
class Feeds_products extends StatefulWidget {

  const Feeds_products({Key? key}) : super(key: key);

  @override
  _Feeds_productsState createState() => _Feeds_productsState();
}

class _Feeds_productsState extends State<Feeds_products> {
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
    final cartProvider = Provider.of<providerCart>(context);
    final themeChange = Provider.of<DarkThemeSetup>(context);
    final productsAttributes = Provider.of<Product>(context);
    final productAttributes = Provider.of<Product>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: (){
          Navigator.pushNamed(context, ProductDetails.routeName,arguments: productAttributes.id);
        },
        child: Container(
          width: 250,
          height: 350,
          decoration: BoxDecoration(
               boxShadow:  [
                 BoxShadow(
                   color: themeChange.darkTheme ? Colors.white : switchState ? Colors.purple : Colors.deepOrange,
                   offset: const Offset(
                     5.0,
                     5.0,
                   ),
                   blurRadius: 10.0,
                   spreadRadius: 2.0,
                 ), //BoxShadow
                 BoxShadow(
                   color: themeChange.darkTheme ? Colors.white :switchState ? Colors.purple : Colors.deepOrange,
                   offset: const Offset(0.0, 0.0),
                   blurRadius: 0.0,
                   spreadRadius: 0.0,
                 ), //BoxShadow
               ],
              borderRadius: BorderRadius.circular(6),
              color: Theme.of(context).backgroundColor),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Column(
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: Container(
                            width: double.infinity,
                            height : MediaQuery.of(context).size.height * 0.3,
                            child: Image.network(
                                  productAttributes.imageUrl,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Badge(
                            toAnimate: true,
                            shape: BadgeShape.square,
                            badgeColor: Colors.pink,
                            borderRadius:
                            BorderRadius.only(bottomRight: Radius.circular(8)),
                            badgeContent:
                            Text('New', style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(left: 5),
                  margin: EdgeInsets.only(left: 5, bottom: 2, right: 3),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 4,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          productAttributes.title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                            fontFamily: 'FF',
                              fontSize: 15,
                              color: themeChange.darkTheme ? Colors.white :switchState ? Colors.purple : Colors.deepOrange,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            '\$${productAttributes.price}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                              fontFamily: 'FF',
                                fontSize: 20,
                                color: themeChange.darkTheme ? Colors.white :switchState ? Colors.purple : Colors.deepOrange,
                                fontWeight: FontWeight.w900),
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Quantity: ${productAttributes.quantity}',
                              style: TextStyle(
                                fontFamily: 'QH',
                                  fontSize: 18,
                                  color: themeChange.darkTheme ? Colors.white :switchState ? Colors.purple : Colors.deepOrange,
                                  fontWeight: FontWeight.w600),
                            ),

                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                  onTap:
                                        () async {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              FeedDialog(
                                                productId: productAttributes.id,
                                              ));

                                  },
                                  borderRadius: BorderRadius.circular(18.0),
                                  child: Icon(
                                    Icons.more_horiz,
                                    color: Colors.grey,
                                  )),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
}
}
