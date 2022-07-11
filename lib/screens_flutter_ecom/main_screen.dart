

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecom_project/screens_flutter_ecom/phoneVerificationPg.dart';
import 'package:flutter_ecom_project/screens_flutter_ecom/upload_product_form.dart';
import 'package:flutter_ecom_project/screens_flutter_ecom/BottomBar.dart';





class MainScreens extends StatefulWidget {
  @override
  State<MainScreens> createState() => _MainScreensState();
}

class _MainScreensState extends State<MainScreens> {
  final firebaseAuth = FirebaseAuth.instance;
  String ?_uid;
  bool isAdmin = false;
  void getData() async {
    User? user = await firebaseAuth.currentUser;
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
    return isAdmin! ? PageView(
      children: [BottomBar(), UploadProductForm()],
    ) : BottomBar();
  }
}
