
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecom_project/inner_screens_flutter_ecom/product_details_flutter_ecom.dart';
import 'package:flutter_ecom_project/provider_flutter_ecom/darkTheme_setup.dart';
import 'package:flutter_ecom_project/provider_flutter_ecom/fav_provider_biswa2210.dart';
import 'package:flutter_ecom_project/provider_flutter_ecom/provider_for_cart.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../provider_flutter_ecom/products_setup.dart';

class FeedDialog extends StatefulWidget {
  final String productId;
  const FeedDialog({required this.productId});

  @override
  State<FeedDialog> createState() => _FeedDialogState();
}

class _FeedDialogState extends State<FeedDialog> {


  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<Products>(context);
    final prodAttr = productsProvider.findById(widget.productId);
    final cartprovider=Provider.of<providerCart>(context);
    final favprovider=Provider.of<FavsProvider>(context);
    List<Product> productList=productsProvider.products;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(
        child: Column(children: [
          Container(
            constraints: BoxConstraints(
                minHeight: 100,
                maxHeight: MediaQuery.of(context).size.height * 0.5),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            child: Image.network(
              prodAttr.imageUrl
            ),
          ),
          Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [ Flexible(
                  child: dialogContent(
                      context,
                      0,
                          () => {
                        favprovider.addAndRemoveFromFav(
                            widget.productId,
                            prodAttr.price,
                            prodAttr.title,
                            prodAttr.imageUrl),
                        Navigator.canPop(context)
                            ? Navigator.pop(context)
                            : null
                      }),
                ),
                Flexible(
                  child: dialogContent(
                      context,
                      1,
                          () => {
                        Navigator.pushNamed(
                            context, ProductDetails.routeName,
                            arguments: prodAttr.id)
                            .then((value) => Navigator.canPop(context)
                            ? Navigator.pop(context)
                            : null),
                      }),
                ),
                Flexible(
                  child: dialogContent(
                    context,
                    2,
                    cartprovider.getCartItems.containsKey(widget.productId)
                        ? () {}
                        : () {
                      cartprovider.addProductToCart(
                          widget.productId,
                          prodAttr.price,
                          prodAttr.title,
                          prodAttr.imageUrl);
                      Navigator.canPop(context)
                          ? Navigator.pop(context)
                          : null;
                    },
                  ),
                ),
                ]),
          ),

          /************close****************/
          Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1.3),
                shape: BoxShape.circle),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(30),
                splashColor: Colors.grey,
                onTap: () =>
                Navigator.canPop(context) ? Navigator.pop(context) : null,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.close, size: 28, color: Colors.white),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget dialogContent(BuildContext context, int index, Function fct) {
    final cart = Provider.of<providerCart>(context);
    final favs = Provider.of<FavsProvider>(context);
    List<IconData> _dialogIcons = [
      favs.getFavsItems.containsKey(widget.productId)
          ? Icons.favorite
          : Icons.favorite_border,
      FontAwesome5.eye,
      FontAwesome5.shopping_cart,
      FontAwesome.trash,
    ];

    List<String> _texts = [
      favs.getFavsItems.containsKey(widget.productId)
          ? 'In wishlist'
          : 'Add to wishlist',
      'View product',
      cart.getCartItems.containsKey(widget.productId) ? 'In Cart ' : 'Add to cart',
    ];
    List<Color> _colors = [
      favs.getFavsItems.containsKey(widget.productId)
          ? Colors.red
          : Theme.of(context).textSelectionColor,

      Theme.of(context).textSelectionColor,
      cart.getCartItems.containsKey(widget.productId)
          ? Colors.red
          : Theme.of(context).textSelectionColor,
    ];
    final themeChange = Provider.of<DarkThemeSetup>(context);
    return FittedBox(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: (){
            fct();
            },
          splashColor: Colors.grey,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.25,
            padding: EdgeInsets.all(4),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        offset: const Offset(0.0, 10.0),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    // inkwell color
                    child: SizedBox(
                        width: 50,
                        height: 50,
                        child: Icon(
                          _dialogIcons[index],
                          color: _colors[index],
                          size: 25,
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: FittedBox(
                    child: Text(
                      _texts[index],
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        //  fontSize: 15,
                        color: themeChange.darkTheme
                            ? Theme.of(context).disabledColor
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
