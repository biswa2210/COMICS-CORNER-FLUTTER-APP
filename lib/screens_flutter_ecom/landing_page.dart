import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_ecom_project/globalMethods/service_provide.dart';
import 'package:flutter_ecom_project/inner_screens_flutter_ecom/brands_navigation_rail%20copy_flutter_ecom.dart';
import 'package:flutter_ecom_project/screens_flutter_ecom/BottomBar.dart';
import 'package:flutter_ecom_project/screens_flutter_ecom/auth/sign_up.dart';
import 'package:flutter_ecom_project/screens_flutter_ecom/homePgScreen.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'auth/login.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with TickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isLoading = false;
  ServiceProvideMethods serviceProvideMethods=ServiceProvideMethods();
  List<String> images = [
    'https://firebasestorage.googleapis.com/v0/b/flutter-ecom-project-c8d1d.appspot.com/o/LD-1.jpg?alt=media&token=9993475d-606e-468b-85bf-f73f47f74112',
    'https://firebasestorage.googleapis.com/v0/b/flutter-ecom-project-c8d1d.appspot.com/o/LD-2.jpg?alt=media&token=6be6a8ef-e68d-455a-ab0d-494e4786ad90',
    'https://firebasestorage.googleapis.com/v0/b/flutter-ecom-project-c8d1d.appspot.com/o/LD-3.jpg?alt=media&token=69de1fe4-06de-41dd-8d1e-66d20d107115',
    'https://firebasestorage.googleapis.com/v0/b/flutter-ecom-project-c8d1d.appspot.com/o/LD-4.jpg?alt=media&token=adbf749c-ecee-4e1c-8056-6e7e78ee0c02',
    'https://firebasestorage.googleapis.com/v0/b/flutter-ecom-project-c8d1d.appspot.com/o/LD-5.jpg?alt=media&token=228b58da-3195-4dd7-8f0e-0da0a6e73c1c',
    'https://firebasestorage.googleapis.com/v0/b/flutter-ecom-project-c8d1d.appspot.com/o/LD-6.jpg?alt=media&token=416799fc-6994-455b-9ced-ae4f22b48996'

  ];
  List<Curve> listCurves = [
    Curves.easeInOutCubic,
    Curves.linear,
    Curves.easeInOutCubicEmphasized,
    Curves.easeInOut,
    Curves.bounceInOut,
    Curves.bounceIn
  ];
  final _random = new Random();
  @override
  void initState() {
    super.initState();
    images.shuffle();
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 20));
    _animation =
    CurvedAnimation(parent: _animationController, curve: listCurves[_random.nextInt(listCurves.length)])
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((animationStatus) {
        if (animationStatus == AnimationStatus.completed) {
          _animationController.reset();
          _animationController.forward();
        }
      });
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }


  void _loginAnonymosly() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _auth.signInAnonymously();
    } catch (error) {
      serviceProvideMethods.authErrorHandlebyBiswa(error.toString(), context);
      print('error occured ${error.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  Future<void> _googleSignIn() async{
    final googleSignIn  = GoogleSignIn();
    final googleAccount =await googleSignIn.signIn();
    if(googleAccount!=null){
      final gauth =await googleAccount.authentication;
      if(gauth.accessToken!=null && gauth.idToken !=null){
        try{
          var date=DateTime.now().toString();
          var id = new DateTime.now().millisecondsSinceEpoch;
          var dateParse=DateTime.parse(date);
          var formattedDate="${dateParse.day}-${dateParse.month}-${dateParse.year}";
          var formattedTime="${dateParse.hour}-${dateParse.minute}-${dateParse.second}";
          final authResult = await _auth.signInWithCredential(GoogleAuthProvider.credential(
              idToken:gauth.idToken,accessToken: gauth.accessToken
          ));
          await FirebaseFirestore.instance
              .collection('users')
              .doc(authResult.user?.uid)
              .set({
            'id': authResult.user?.uid,
            'name': authResult.user?.displayName,
            'email': authResult.user?.email,
            'phoneNumber': "",
            'imageUrl': authResult.user?.photoURL,
            'joinedAt': "DATE: " + formattedDate + ", TIME : " + formattedTime,
            'phoneverified':false,
            'googleSignIn':true,
            'address':"",
            'pincode':"",
            'isAdmin':false,
          });
        }
        catch(err){
          serviceProvideMethods.authErrorHandlebyBiswa(err.toString(), context);
          print('Error occured ${err}');
        }
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
          CachedNetworkImage(
            imageUrl: images[1],
            // placeholder: (context, url) => Image.network(
            //   'https://image.flaticon.com/icons/png/128/564/564619.png',
            //   fit: BoxFit.contain,
            // ),
            errorWidget: (context, url, error) => Icon(Icons.error),
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
            alignment: FractionalOffset(_animation.value, 0),
          ),
          Container(
            margin: EdgeInsets.only(top: 80),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    child: DefaultTextStyle(

                      style: const TextStyle(
                        fontSize: 50.0,
                        fontFamily: 'MR',
                        color: Colors.yellowAccent,
                        shadows: <Shadow>[
                          Shadow(
                            blurRadius: 80.0,
                            color: Colors.yellow,
                          ),
                        ],
                      ),
                      child: AnimatedTextKit(
                          animatedTexts: [
                            WavyAnimatedText("Welcome to"),
                            RotateAnimatedText('COMICS\nCORNER'),

                          ],
                       repeatForever: true,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: GlowText(
                    'I find television very educating. Every time somebody turns on the set, I go into the other room and read a book.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'FF',
                      fontSize: 26,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                )
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(

                        style: ButtonStyle(
                            backgroundColor:
                            MaterialStateProperty.all(Colors.deepOrange),
                            shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                side: BorderSide(color: Colors.purple),
                              ),

                            )),
                        onPressed: () {
                          Navigator.pushNamed(context, LoginScreen.routeName);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Login',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 17),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Feather.user,
                              size: 18,
                            )
                          ],
                        )),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                            MaterialStateProperty.all(Colors.deepPurple),
                            shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                side:
                                BorderSide(color: Colors.orange),
                              ),
                            )),
                        onPressed: () {
                          Navigator.pushNamed(context, SignUpScreen.routeName);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Sign up',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 17),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Feather.user_plus,
                              size: 18,
                            )
                          ],
                        )),
                  ),
                  SizedBox(width: 10),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Divider(
                        color: Colors.white,
                        thickness: 2,
                      ),
                    ),
                  ),
                  Text(
                    'Or continue with',
                    style: TextStyle(color: Colors.black),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Divider(
                        color: Colors.white,
                        thickness: 2,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  OutlineButton(
                    onPressed: _googleSignIn,
                    shape: StadiumBorder(),
                    highlightedBorderColor: Colors.red.shade200,
                    borderSide: BorderSide(width: 2, color: Colors.red),
                    child: Text('Google +',style: TextStyle(color: Colors.white),),
                  ),
                  _isLoading
                      ? CircularProgressIndicator():OutlineButton(
                    onPressed: () {
                      _loginAnonymosly();
                      //Navigator.pushNamed(context, BottomBar.routeName);
                    },
                    shape: StadiumBorder(),
                    highlightedBorderColor: Colors.deepPurple.shade200,
                    borderSide: BorderSide(width: 2, color: Colors.deepPurple),
                    child: Text('Sign in as a guest',style: TextStyle(color: Colors.white),),
                  ),
                ],
              ),
              SizedBox(
                height: 40,
              ),
            ],
          ),
        ]));
  }
}
