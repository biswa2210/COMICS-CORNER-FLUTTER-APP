import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_ecom_project/globalMethods/paymentIntegration.dart';
import 'package:flutter_ecom_project/globalMethods/service_provide.dart';
import 'package:flutter_ecom_project/provider_flutter_ecom/darkTheme_setup.dart';
import 'package:flutter_ecom_project/provider_flutter_ecom/provider_for_cart.dart';
import 'package:flutter_ecom_project/screens_flutter_ecom/cart/cartFullPage.dart';
import 'package:flutter_ecom_project/screens_flutter_ecom/cart/emptyCart.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stylish_dialog/stylish_dialog.dart';
import 'package:uuid/uuid.dart';
const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    //'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);
class CartScreen extends StatefulWidget {
  static const routeName = '/CartPg';
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  ServiceProvideMethods globalMethods = ServiceProvideMethods();
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



  void showDialogForPaymentMethodsChoose(BuildContext context,String title,String subtitle,Function ft1,Function ft2,int i) async{
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
    var codlist=["Cash on delivery","Pay on delivery","Cash On Delivery","Pay On Delivery"];
    var stripelist=["Pay via card","Pay Via Card"];
    final _random = new Random();
    showAnimatedDialog( context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return ClassicGeneralDialogWidget(
          titleText: title,
          contentText: subtitle,
          actions: [
            TextButton(onPressed:  () async{ await ft1();Navigator.of(context).pop();}, child:Text(stripelist[_random.nextInt(stripelist.length)]) ),
            TextButton(onPressed:  () async{await ft2();Navigator.of(context).pop();}, child:Text(codlist[_random.nextInt(codlist.length)]) )
          ],
        );
      },
      animationType: Animations[_random.nextInt(Animations.length)],
      curve: Curves.fastOutSlowIn,
      duration: Duration(seconds: 1),
    );
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    StripeService.init();
  }
  var response;
  Future<void> payWithCard({required int amount}) async {
    ProgressDialog dialog = ProgressDialog(context);
    dialog.style(message: 'Please wait...');
    await dialog.show();
    response = await StripeService.payWithNewCard(
        currency: 'USD', amount: amount.toString());
    await dialog.hide();
    print('response : ${response.success}');
  }
  @override
  Widget build(BuildContext context) {
    _getSwitchState();
    final cartprovider=Provider.of<providerCart>(context);
    List products=[];
    final themeChange =  Provider.of<DarkThemeSetup>(context);
    return cartprovider.getCartItems.isEmpty ? Scaffold(body: CartEmpty(),):Scaffold(
        bottomSheet: checkoutSection(context,cartprovider.totalAmount),
        appBar: AppBar(
          backgroundColor: switchState?Colors.deepPurple : Colors.orange,
          title: Text('Your Cart (${cartprovider.getCartItems.length})'),
          actions: [
            IconButton(
              onPressed: () {
               showDialog(context, "Confirmation","It is not a joke,are you serious about clear your cart?",()=>{
                  cartprovider.clearCart()
                }, 2);
               flutterLocalNotificationsPlugin.show(  0,
                   "Empty Cart",
                   "Now your cart is empty.Lets buy some commics",
                   NotificationDetails(
                       android: AndroidNotificationDetails(channel.id, channel.name,
                           importance: Importance.high,
                           color: Colors.blue,
                           playSound: true,
                           icon: '@mipmap/ic_launcher')));
              },
              icon: Icon(Icons.delete),
            )
          ],
        ),
        body: Container(
          margin: EdgeInsets.only(bottom: 60),
          child: ListView.builder(itemCount: cartprovider.getCartItems.length,itemBuilder: (BuildContext ctx, int index){
            return ChangeNotifierProvider.value(
              value:cartprovider.getCartItems.values.toList()[index],
              child: CartFull(
                productId: cartprovider.getCartItems.keys.toList()[index],
                //id: cartprovider.getCartItems.values.toList()[index].id,
                //productId: cartprovider.getCartItems.keys.toList()[index],
                //price: cartprovider.getCartItems.values.toList()[index].price,
                //title: cartprovider.getCartItems.values.toList()[index].title,
                //imageUrl: cartprovider.getCartItems.values.toList()[index].imageUrl,
                //quatity: cartprovider.getCartItems.values.toList()[index].quantity,
              ),
            );
          }),
        ));
  }

  Widget checkoutSection(BuildContext ctx,double subtotal) {
    final cartProvider = Provider.of<providerCart>(context);
    var uuid = Uuid();
    final FirebaseAuth _auth = FirebaseAuth.instance;
    return Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.grey, width: 0.5),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            /// mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Material(
                  borderRadius: BorderRadius.circular(30),
                  color: switchState? Colors.deepPurple:Colors.orangeAccent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                 onTap: () async {

                   double amountInCents = subtotal * 1000;
                   int intengerAmount = (amountInCents / 10).ceil();
                   showDialogForPaymentMethodsChoose(context,"Choose Payment Method", "please choose a payment method for continue the order placing portion.",
                       () async{
                         await payWithCard(amount: intengerAmount);
                         if (response.success == true) {
                           User? user = _auth.currentUser;
                           final _uid = user?.uid;
                           cartProvider.getCartItems
                               .forEach((key, orderValue) async {
                             final orderId = uuid.v4();
                             try {
                               await FirebaseFirestore.instance
                                   .collection('order')
                                   .doc(orderId)
                                   .set({
                                 'orderId': orderId,
                                 'userId': _uid,
                                 'productId': orderValue.productid,
                                 'title': orderValue.title,
                                 'price': orderValue.price * orderValue.quantity,
                                 'imageUrl': orderValue.imageUrl,
                                 'quantity': orderValue.quantity,
                                 'orderDate': Timestamp.now(),
                               }).then((value) =>cartProvider.clearCart() );

                               globalMethods.SuccessPaymentbyBiswa(cartProvider.getCartItems.length==1?"Your order is placed.":"Your orders are placed."+"Your Payment ${intengerAmount} cents is successfully paid through stripe.Response code is 200.This HTTP 200 OK success status response code indicates that the request has succeeded ", context);
                               flutterLocalNotificationsPlugin.show(  0,
                                   "Successfully Order Placed",
                                   "Please ensure that your shipping address and pincode is not empty and valid.",
                                   NotificationDetails(
                                       android: AndroidNotificationDetails(channel.id, channel.name,
                                           importance: Importance.high,
                                           color: Colors.blue,
                                           playSound: true,
                                           icon: '@mipmap/ic_launcher')));
                             } catch (err) {
                               print('error occured $err');
                             }
                           });
                         } else {
                           globalMethods.authErrorHandlebyBiswa(
                               'Please enter your true information', context);
                         }
                       }, (){
                         User? user = _auth.currentUser;
                         final _uid = user?.uid;
                         cartProvider.getCartItems
                             .forEach((key, orderValue) async {
                           final orderId = uuid.v4();
                           try {
                             await FirebaseFirestore.instance
                                 .collection('order')
                                 .doc(orderId)
                                 .set({
                               'orderId': orderId,
                               'userId': _uid,
                               'productId': orderValue.productid,
                               'title': orderValue.title,
                               'price': orderValue.price * orderValue.quantity,
                               'imageUrl': orderValue.imageUrl,
                               'quantity': orderValue.quantity,
                               'orderDate': Timestamp.now(),
                             }).then((value) =>cartProvider.clearCart() );
                             globalMethods.SuccessCodbyBiswa(ctx, intengerAmount);
                             flutterLocalNotificationsPlugin.show(  0,
                                 "Successfully Order Placed",
                                 "Please ensure that your shipping address and pincode is not empty and valid.",
                                 NotificationDetails(
                                     android: AndroidNotificationDetails(channel.id, channel.name,
                                         importance: Importance.high,
                                         color: Colors.blue,
                                         playSound: true,
                                         icon: '@mipmap/ic_launcher')));
                           } catch (err) {
                             print('error occured $err');
                           }
                         });

                       },3);

                 },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        switchState?'Place Order':'Checkout',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: switchState ? Colors.white : Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ),
              Spacer(),
              Text(
                'Total: ',
                style: TextStyle(
                    color: Theme.of(ctx).textSelectionColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                '\$${subtotal.toStringAsFixed(2)}',
                //textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ));
  }
}
