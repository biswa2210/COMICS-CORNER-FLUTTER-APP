import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecom_project/globalMethods/paymentIntegration.dart';
import 'package:flutter_ecom_project/screens_flutter_ecom/upload_product_form.dart';
import 'package:flutter_ecom_project/screens_flutter_ecom/wishlist/WishList_flutter_ecom.dart';
import 'package:flutter_ecom_project/screens_flutter_ecom/cart/cartPgScreen.dart';
import 'package:flutter_ecom_project/screens_flutter_ecom/feedsScreen.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:provider/provider.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

import '../provider_flutter_ecom/darkTheme_setup.dart';

class BackLayerFlutterEcom extends StatefulWidget {
  final String userImageUrl;
  final bool sw_St;
  const BackLayerFlutterEcom({Key? key,required this.userImageUrl,required this.sw_St}) : super(key: key);

  @override
  State<BackLayerFlutterEcom> createState() => _BackLayerFlutterEcomState();
}

class _BackLayerFlutterEcomState extends State<BackLayerFlutterEcom> {
  final firebaseAuth = FirebaseAuth.instance;
  String ?_uid;
  bool ? isAdmin;
  void getData() async {
    User? user = firebaseAuth.currentUser;
    _uid = user!.uid;

    print('user.displayName ${user.displayName}');
    print('user.photoURL ${user.photoURL}');
    final DocumentSnapshot userDoc = (user.isAnonymous
        ? null
        : await FirebaseFirestore.instance.collection('users').doc(_uid).get()) as DocumentSnapshot<Object?>;
    if (userDoc == null) {
      return;
    } else {
      setState(() {
        isAdmin=userDoc.get('isAdmin');
      });
    }
    print("Is Admin Status : "+isAdmin.toString());
  }
  @override
  Widget build(BuildContext context) {
    getData();
    final themeChange = Provider.of<DarkThemeSetup>(context);
    return Stack(
      fit: StackFit.expand,
      children: [
        Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  themeChange.darkTheme? Colors.black :widget.sw_St?Colors.purpleAccent:Colors.orangeAccent,
                  themeChange.darkTheme? Colors.white :widget.sw_St?Colors.white:Colors.white
                ],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
        ),
        Positioned(
          top: -100.0,
          left: 140.0,
          child: Transform.rotate(
            angle: -0.5,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.white.withOpacity(0.3),
              ),
              width: 150,
              height: 250,
            ),
          ),
        ),
        Positioned(
          bottom: 0.0,
          right: 100.0,
          child: Transform.rotate(
            angle: -0.8,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.white.withOpacity(0.3),
              ),
              width: 150,
              height: 300,
            ),
          ),
        ),
        Positioned(
          top: -50.0,
          left: 60.0,
          child: Transform.rotate(
            angle: -0.5,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.white.withOpacity(0.3),
              ),
              width: 150,
              height: 200,
            ),
          ),
        ),
        Positioned(
          bottom: 10.0,
          right: 0.0,
          child: Transform.rotate(
            angle: -0.8,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.white.withOpacity(0.3),
              ),
              width: 150,
              height: 200,
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            margin: EdgeInsets.all(50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                        color: Theme.of(context).backgroundColor,
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Container(
                      //   clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          image: DecorationImage(
                            image: NetworkImage(widget.userImageUrl ==null?
                            'https://t3.ftcdn.net/jpg/01/83/55/76/240_F_183557656_DRcvOesmfDl5BIyhPKrcWANFKy2964i9.jpg' : widget.userImageUrl),
                            fit: BoxFit.fill,
                          )),
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                content(context, () {
                  navigateTo(context, FeedsScreen.routeName,true);
                }, 'Comics', 0),
                const SizedBox(height: 10.0),
                content(context, () {
                  navigateTo(context, CartScreen.routeName,true);
                }, 'Cart section', 1),
                const SizedBox(height: 10.0),
                content(context, () {
                  navigateTo(context, WishListScreen.routeName,true);
                }, 'Wishlist', 2),
                const SizedBox(height: 10.0),
                content(context, () {
                  navigateTo(context, UploadProductForm.routeName,isAdmin!);
                }, 'Upload a new comic', 3),
              ],
            ),
          ),
        ),
      ],
    );
  }
}



List _contentIcons = [
  FontAwesome5.rss,
  FontAwesome5.shopping_bag,
  FontAwesome5.list,
  FontAwesome5.upload
];
void navigateTo(BuildContext ctx, String routeName,bool isAdmin) {
  print("Admin Status"+isAdmin.toString());
  isAdmin ?
  Navigator.pushNamed(
    ctx,
    routeName
  ) :
  StylishDialog(
    context: ctx,
    alertType: StylishDialogType.ERROR,
    titleText: 'NOT ADMIN',
    contentText: 'MSG: You have not any administrative power.',
    titleStyle:TextStyle(color: Colors.black),
    contentStyle: TextStyle(color: Colors.black),
  ).show();
}

Widget content(BuildContext ctx, Function fct, String text, int index) {
  return InkWell(
    onTap: (){
      fct();
    },
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            text,
            style: TextStyle(fontFamily: 'FF',fontSize: 22,fontWeight: FontWeight.bold),

            textAlign: TextAlign.center,
          ),
        ),
        Icon(_contentIcons[index])
      ],
    ),
  );
}
