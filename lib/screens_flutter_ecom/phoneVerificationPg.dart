import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecom_project/globalMethods/service_provide.dart';
import 'package:flutter_ecom_project/screens_flutter_ecom/landing_page.dart';
import 'package:flutter_ecom_project/screens_flutter_ecom/main_screen.dart';
import 'package:toast/toast.dart';
enum LoginScreen{
  SHOW_MOBILE_ENTER_WIDGET,
  SHOW_OTP_FORM_WIDGET
}
class PhoneVerificationPage extends StatefulWidget {
  const PhoneVerificationPage({Key? key}) : super(key: key);

  @override
  _PhoneVerificationPageState createState() => _PhoneVerificationPageState();
}

class _PhoneVerificationPageState extends State<PhoneVerificationPage> {
  TextEditingController  phoneController = TextEditingController();
  ServiceProvideMethods spm = new ServiceProvideMethods();
  bool isPhoneVerfied=false;
  bool isItGoogleSignIn=false;
  TextEditingController  otpController = TextEditingController();
  LoginScreen currentState = LoginScreen.SHOW_MOBILE_ENTER_WIDGET;
  FirebaseAuth _auth = FirebaseAuth.instance;
  String verificationID = "";
  String phonenum="";



  showMobilePhoneWidget(context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Spacer(),
        Container(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Text("Verify Your Phone Number" , textAlign:TextAlign.center,style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold,fontFamily:'MR'),),
          ),
        ),
        SizedBox(height: 5,),
        Center(
          child:Hero(
              tag: "photo_tag",
              child: Container(child: Image(image: AssetImage("assets/images/biswaDesigning/phone_verify_logo.png"),height: 300))),
        ),
        Center(
          child:       Padding(
            padding: const EdgeInsets.all(30.0),
            child: TextField(
              readOnly: isItGoogleSignIn ? false :true,
              controller: phoneController,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12) ),
                  hintText: "Fetching your phone no..."
              ),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 10),
          child: SizedBox(
            height: 60,
             width: double.infinity,
            child: ElevatedButton(onPressed: ()  async{
             if(validateMobile(phoneController.text)){
               await _auth.verifyPhoneNumber(

                   phoneNumber: "+91${phoneController.text}",
                   verificationCompleted: (phoneAuthCredential) async{


                   },
                   verificationFailed: (verificationFailed){
                     print(verificationFailed);
                     spm.StylishDialogErrorbyBiswa("OTP Sending Failed",verificationFailed.toString(),context);
                   },

                   codeSent: (verificationID, resendingToken) async{
                     setState(() {

                       currentState = LoginScreen.SHOW_OTP_FORM_WIDGET;
                       this.verificationID = verificationID;
                     });
                   },


                   codeAutoRetrievalTimeout: (verificationID) async{

                   }
               );
             }else{
               spm.StylishDialogErrorbyBiswa("Invalid Phone Number","Mobile Number must be of 10 digits",context);
               setState(() {
                 phoneController.text="";
               });
             }
            }, child: Text("Send OTP",style: TextStyle(fontSize: 35,fontFamily: 'STM',fontWeight: FontWeight.bold),)),
          ),
        ),
        Spacer()
      ],
    );
  }


  showOtpFormWidget(context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Spacer(),
        Container(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Text("Enter the otp" , textAlign:TextAlign.center,style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold,fontFamily:'MR'),),
          ),
        ),
        SizedBox(height: 7,),
        Center(
          child:       Padding(
            padding: const EdgeInsets.all(25.0),
            child: TextField(
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
              controller: otpController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12) ),
                  hintText: "Enter Your OTP"
              ),
            ),
          ),
        ),
        Hero(
        tag: "photo_tag",
            child: Container(child: Image(image: AssetImage("assets/images/biswaDesigning/phone_verify_logo.png"),height: 250))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0,vertical: 0),
          child: SizedBox(
            height: 50,
            width: double.infinity,
            child: ElevatedButton(onPressed: () async {
            try{
              if (otpController == null || otpController == '') {
                spm.StylishDialogErrorbyBiswa("Invalid Otp","Please enter 6 digits otp which is sent to ${phonenum}",context);
                return;
              }
              PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(verificationId: verificationID, smsCode: otpController.text);
              await FirebaseAuth.instance.currentUser?.updatePhoneNumber(phoneAuthCredential);
              await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).update({
                'phoneNumber':phoneController.text,
                'phoneverified':true
              });
              spm.StylishDialogSuccessbyBiswa("Verified", "Your phone number is verified,now you can access this application", context);

            }catch(err){
              spm.StylishDialogErrorbyBiswa("Verification Failed",err.toString(),context);
            }

            }, child: Text("Verify",style: TextStyle(fontSize: 35,fontFamily: 'STM',fontWeight: FontWeight.bold),)),
          ),
        ),
        SizedBox(height: 16,),
        Spacer()
      ],
    );
  }
  Future<void> getData() async{ //use a Async-await function to get the data
    final data =await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get();
    setState(() {
      isPhoneVerfied=data['phoneverified'];
      phonenum=data['phoneNumber'].toString();
      isItGoogleSignIn=data['googleSignIn'];
    });

  }
  bool validateMobile(String value) {
    if (value.length != 10){
      Toast.show("${value} this phone number is invalid.Mobile Number must be of 10 digits", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM,
          textColor: Colors.black,backgroundColor: Colors.yellowAccent);
      return false;
    }

    else
      return true;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }
  @override
  Widget build(BuildContext context) {
    getData();
    print("phone number : "+phonenum);
    print("phoneVerified status : "+isPhoneVerfied.toString());
    print("google SignIn  status : "+isItGoogleSignIn.toString());
    setState(() {
      if(!isItGoogleSignIn){
        phoneController.text=phonenum;
     }
    });
    return isPhoneVerfied? MainScreens() : Scaffold(
      resizeToAvoidBottomInset : false,
      body: currentState == LoginScreen.SHOW_MOBILE_ENTER_WIDGET ? showMobilePhoneWidget(context):showOtpFormWidget(context)   ,
    );
  }
}