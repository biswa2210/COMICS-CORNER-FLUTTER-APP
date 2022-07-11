import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecom_project/inner_screens_flutter_ecom/product_details_flutter_ecom.dart';
import 'package:flutter_ecom_project/models/product.dart';
import 'package:flutter_ecom_project/provider_flutter_ecom/fav_provider_biswa2210.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:provider/provider.dart';

import '../provider_flutter_ecom/provider_for_cart.dart';
class PopularProducts extends StatelessWidget {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final String productCategoryName;
  final String brand;
  final int quantity;
  final bool isFavorite;
  final bool isPopular;
  const PopularProducts({Key? key, required this.id,required this.title,required this.description,
    required this.price,required this.imageUrl,required this.productCategoryName, required this.brand,
    required this.quantity,required this.isFavorite,required this.isPopular}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartprovider=Provider.of<providerCart>(context);
    final favsprovider=Provider.of<FavsProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 250,
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.only(
            bottomLeft:  Radius.circular(10.0),
            bottomRight: Radius.circular(10.0)
          ),
        ),
          child:Material(
            child: InkWell(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10.0),
                bottomRight: Radius.circular(10)
              ),
              onTap: (){
                Navigator.pushNamed(context, ProductDetails.routeName,arguments: id);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 170,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(imageUrl),
                            fit: BoxFit.fill
                          )
                        ),
                      ),
                      Positioned(
                        right: 12,
                        top:10,
                        child: Icon(
                          Entypo.star,
                          color: favsprovider.getFavsItems.containsKey(id)?Colors.red:Colors.grey.shade800,
                        ),
                      ),
                      Positioned(
                          right: 12,
                          bottom: 32,
                          child: Container(
                            padding: EdgeInsets.all(10.0),
                            color:Theme.of(context).backgroundColor,
                            child: Text(
                              '\$${price}',
                              style: TextStyle(
                                color: Theme.of(context).textSelectionColor
                              ),
                            ),
                          )
                      )
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    //color: Colors.white54,
                    decoration: BoxDecoration(
                      boxShadow:  [
                        BoxShadow(
                          color: Colors.black12,
                          offset: const Offset(
                            5.0,
                            5.0,
                          ),
                          blurRadius: 10.0,
                          spreadRadius: 2.0,
                        ), //BoxShadow
                        BoxShadow(
                          color: Colors.white,
                          offset: const Offset(0.0, 0.0),
                          blurRadius: 0.0,
                          spreadRadius: 0.0,
                        ), //BoxShadow
                      ]
                    ),
                    child: Column(
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 5,
                              child: Text(
                                description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: cartprovider.getCartItems.containsKey(id)?
                                    (){}:
                                    (){
                                  cartprovider.addProductToCart(id, price,title, imageUrl);
                                },
                                borderRadius: BorderRadius.circular(30),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child:
                                  Icon(
                                    cartprovider.getCartItems.containsKey(id)?
                                    FontAwesome5.check_square:
                                    FontAwesome5.cart_plus,
                                    size:25,
                                    color: Colors.black,
                                  ),
                                ),

                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ),
    );
  }
}
