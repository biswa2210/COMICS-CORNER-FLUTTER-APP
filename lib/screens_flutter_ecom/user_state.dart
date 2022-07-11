
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecom_project/screens_flutter_ecom/VerificationScreen.dart';
import 'package:flutter_ecom_project/screens_flutter_ecom/landing_page.dart';
import 'package:flutter_ecom_project/screens_flutter_ecom/main_screen.dart';

class UserState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),

        // ignore: missing_return
        builder: (context, userSnapshot) {

          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (userSnapshot.connectionState == ConnectionState.active) {
            if (userSnapshot.hasData) {
              print('The user is already logged in');
              //return MainScreens();
              return VerificationPage();
            } else  {
              print('The user didn\'t login yet');
              return LandingPage();
            }
          } else if (userSnapshot.hasError) {
            return Center(
              child: Text('Error occured'),
            );

          }
          else{
            return CircularProgressIndicator();
          }
        });
  }
}
