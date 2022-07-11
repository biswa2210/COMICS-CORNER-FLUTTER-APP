import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_ecom_project/inner_screens_flutter_ecom/product_details_flutter_ecom.dart';
import 'package:flutter_ecom_project/models/cart_attr.dart';
import 'package:flutter_ecom_project/provider_flutter_ecom/darkTheme_setup.dart';
import 'package:flutter_ecom_project/provider_flutter_ecom/provider_for_cart.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
class CartFull extends StatefulWidget {
  final String productId;

  const CartFull({required this.productId});
  //final String id;
  //final String productId;
  //final double price;
  //final int quatity;
  //final String title;
  //final String imageUrl;

   //const CartFull(
      //{required this.id,
      //required this.productId,
      //required this.price,
      //required this.quatity,required this.title,required this.imageUrl});

  @override
  _CartFullState createState() => _CartFullState();
}

class _CartFullState extends State<CartFull> {



  bool switchState=false;
  _getSwitchState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      switchState = prefs.getBool('switchState')?? false;
      print(switchState);
    });
  }
  var SlidingAnimations= [DialogTransitionType.slideFromBottom,DialogTransitionType.slideFromTop,DialogTransitionType.slideFromRight,DialogTransitionType.slideFromLeft];
  var RotatingAnimations=[DialogTransitionType.scaleRotate,DialogTransitionType.rotate3D,DialogTransitionType.fadeRotate];
  var ScaleAnimations=[DialogTransitionType.fadeScale,DialogTransitionType.scale];
  void showDialog(BuildContext context,String title,String subtitle,Function ft,int i){
    var Animations=[];
    switch(i) {
      case 1: {
        Animations=SlidingAnimations;
      }
      break;

      case 2: {
        Animations=RotatingAnimations;
      }
      break;
      case 3: {
        Animations=ScaleAnimations;
      }
      break;
      default: {
        Animations=[DialogTransitionType.rotate3D,DialogTransitionType.slideFromBottom];
      }
      break;
    }
    var Yeslist=["Yes","Agree","Confirm","Absolutely"];
    var Nolist=["No","Cancel","No,Quit","No,Exit"];
    final _random = new Random();
    showAnimatedDialog( context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return ClassicGeneralDialogWidget(
          titleText: title,
          contentText: subtitle,
          actions: [
            TextButton(onPressed:  ()=>{ft(),Navigator.of(context).pop()}, child: Text(Yeslist[_random.nextInt(Yeslist.length)])),
            TextButton(onPressed:  ()=>{Navigator.of(context).pop()}, child: Text(Nolist[_random.nextInt(Nolist.length)]))
          ],
        );
      },
      animationType: Animations[_random.nextInt(Animations.length)],
      curve: Curves.fastOutSlowIn,
      duration: Duration(seconds: 1),
    );
  }
  @override
  Widget build(BuildContext context) {
    _getSwitchState();
    final themeChange = Provider.of<DarkThemeSetup>(context);
    final cartAttr = Provider.of<CartAttr>(context);
    final cartProvider = Provider.of<providerCart>(context);
    double subTotal = cartAttr.price * cartAttr.quantity;
    return InkWell(
      onTap: ()=>Navigator.pushNamed(context, ProductDetails.routeName,
      arguments: widget.productId
      ),
      child: Container(
        height: 135,
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomRight: const Radius.circular(16.0),
            topRight: const Radius.circular(16.0),
          ),
          color: Theme.of(context).backgroundColor,
        ),
        child: Row(
          children: [
            Container(
              width: 130,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(cartAttr.imageUrl),
                  //fit: BoxFit.fill,
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            '${cartAttr.title}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 15),
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(32.0),
                            // splashColor: ,
                            onTap: () {
                             showDialog(context,"Confirm Delete", "Are you sure to delete ${cartAttr.title}?",()=>cartProvider.removeItem(widget.productId),1);
                             // cartProvider.removeItem(widget.productId);
                            },
                            child: Container(
                              height: 50,
                              width: 50,
                              child: Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 22,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text('Price:'),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          '\$${cartAttr.price}',// \u{20B9} ---> for rupees
                          style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text('Sub Total:'),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          '\$${subTotal.toStringAsFixed(2)}',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color:switchState?Colors.deepPurple : Colors.orangeAccent),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'Ships Free',
                          style: TextStyle(
                              color:switchState?Colors.deepPurple : Colors.orangeAccent),
                        ),
                        Spacer(),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(4.0),
                            // splashColor: ,
                            onTap: cartAttr.quantity<2 ? null :() {
                              cartProvider.reduceItemByOne(
                                  widget.productId,
                                  cartAttr.price,
                                  cartAttr.title,
                                  cartAttr.imageUrl);
                            },
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Icon(
                                  Icons.remove,
                                  color: Colors.red,
                                  size: 22,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Card(
                          elevation: 12,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.12,
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                switchState?Colors.purpleAccent : Colors.white,
                                switchState?Colors.white:Colors.orangeAccent
                              ], stops: [
                                0.0,
                                0.7
                              ]),
                            ),
                            child: Text(cartAttr.quantity.toString(), textAlign: TextAlign.center,),
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(4.0),
                            // splashColor: ,
                            onTap: () {
                              cartProvider.addProductToCart(
                                  widget.productId,
                                  cartAttr.price,
                                  cartAttr.title,
                                  cartAttr.imageUrl);
                            },
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Icon(
                                  Icons.add,
                                  color: Colors.green,
                                  size: 22,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
