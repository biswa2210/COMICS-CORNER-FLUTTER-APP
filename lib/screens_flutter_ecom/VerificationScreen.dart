import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecom_project/screens_flutter_ecom/main_screen.dart';
import 'package:flutter_ecom_project/screens_flutter_ecom/phoneVerificationPg.dart';

import 'app-properties.dart';


class VerificationPage extends StatefulWidget {
  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  bool isemailVerified = false;
  bool canResendEmail =false;
  Timer ? timer;

  TextEditingController email = TextEditingController(text: 'example@email.com');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    isemailVerified=FirebaseAuth.instance.currentUser!.emailVerified;
    if(!isemailVerified){
        timer=Timer.periodic(
          Duration(seconds: 3),
            (_)=>checkEmailVerified(),
        );
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer?.cancel();
    super.dispose();
  }

Future checkEmailVerified() async{
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isemailVerified=FirebaseAuth.instance.currentUser!.emailVerified;
    });
  }

  Future sendVerificationEmail() async{
    try{
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      setState(() {
        canResendEmail=false;
      });
      await Future.delayed(Duration(seconds: 5));
      setState(() {
        canResendEmail=true;
      });
    }catch(err){
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(err.toString()),
        duration: Duration(milliseconds: 3000),
      ));
    }

  }
  @override
  Widget build(BuildContext context) {
    Widget title = Text(
        'Welcome to Verification Page',
      style: TextStyle(
          color: Colors.white,
          fontFamily: 'MR',
          fontSize: 34.0,
          fontWeight: FontWeight.bold,
          shadows: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.15),
              offset: Offset(0, 5),
              blurRadius: 10.0,
            )
          ]),
    );

    Widget subTitle = Padding(
        padding: const EdgeInsets.only(right: 56.0),
        child: Text(
          'Verify your email address by pressing the button "Verify Email" which is shown below,this verification step is compulsory and important to enter and access our shop',
          style: TextStyle(
            fontFamily: 'FF',
            color: Colors.white,
            fontSize: 18.0,
          ),
        ));

    Widget registerButton = Positioned(
      left: MediaQuery.of(context).size.width / 4,
      bottom: 40,
      child: InkWell(
        onTap: () async{
          await sendVerificationEmail();
        },
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          height: 80,
          child: Center(
              child: new Text(canResendEmail?"Resend Email" : "Verify Email",
                  style: const TextStyle(
                      color: const Color(0xfffefefe),
                      fontFamily: 'FF',
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                      fontSize: 30.0))),
          decoration: BoxDecoration(
              gradient: mainButton,
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.16),
                  offset: Offset(0, 5),
                  blurRadius: 10.0,
                )
              ],
              borderRadius: BorderRadius.circular(9.0)),
        ),
      ),
    );

    Widget registerForm = Container(
      height: 250,
      child: Stack(
        children: <Widget>[
          Container(
            height: 170,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(left: 32.0, right: 12.0),
            decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 0.8),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 15,),
                  child: Text(
                    'USER INFORMATONS',
                    style: TextStyle(fontSize: 25.0,fontWeight: FontWeight.bold,fontFamily: 'MR'),

                  ),
                ),
                Divider(color: Colors.black,),SizedBox(height: 2,),
                Padding(
                  padding: const EdgeInsets.only(top: 0,),
                  child: Text(
                    '${FirebaseAuth.instance.currentUser!.displayName}',
                    style: TextStyle(fontSize: 20.0,fontFamily: 'FF',fontWeight: FontWeight.bold),

                  ),
                ),
                SizedBox(height: 12,),
                Padding(
                  padding: const EdgeInsets.only(top: 0,),
                  child: Text(
                    '${FirebaseAuth.instance.currentUser!.email}',
                    style: TextStyle(fontSize: 20.0,fontFamily: 'FF',fontWeight: FontWeight.bold),

                  ),
                ),



              ],
            ),
          ),
          registerButton,
        ],
      ),
    );



    return FirebaseAuth.instance.currentUser!.isAnonymous ? MainScreens() : isemailVerified? PhoneVerificationPage():Scaffold(

      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage('assets/background.jpg'),
                    fit: BoxFit.cover)
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: transparentYellow,

            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 28.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Spacer(flex:3),
                title,
                Spacer(),

                subTitle,
                Spacer(flex:2),

                registerForm,
                Spacer(flex:2),

              ],
            ),
          ),

        ],
      ),
    );
  }
}
