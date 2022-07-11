import 'package:flutter/material.dart';
import 'package:stylish_dialog/stylish_dialog.dart';
class ServiceProvideMethods{

  Future<void> showDialogg(
      String title, String subtitle, Function fct, BuildContext context) async {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 6.0),
                  child: Image.network(
                    'https://image.flaticon.com/icons/png/128/564/564619.png',
                    height: 20,
                    width: 20,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(title,style: TextStyle(color: Colors.black),),
                ),
              ],
            ),
            content: Text(subtitle),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel',style: TextStyle(color: Colors.black),)),
              TextButton(
                  onPressed: () {
                    fct();
                    Navigator.pop(context);
                  },
                  child: Text('ok',style: TextStyle(color: Colors.black),))
            ],
          );
        });
  }

  Future<void> authErrorHandlebyBiswa(String text,BuildContext ctx) async {

      return StylishDialog(
        context: ctx,
        alertType: StylishDialogType.ERROR,
        titleText: 'Oops,SignIn Faild',
        contentText: 'Error: '+text,
        titleStyle:TextStyle(color: Colors.black),
        contentStyle: TextStyle(color: Colors.black),

      ).show();
  }
  Future<void> StylishDialogErrorbyBiswa(String texttile,String subtile,BuildContext ctx) async {

    return StylishDialog(
      context: ctx,
      alertType: StylishDialogType.ERROR,
      titleText: texttile,
      contentText: 'Error: '+subtile,
      titleStyle:TextStyle(color: Colors.black),
      contentStyle: TextStyle(color: Colors.black),

    ).show();
  }

  Future<void> StylishDialogSuccessbyBiswa(String texttile,String subtile,BuildContext ctx) async {

    return StylishDialog(
      context: ctx,
      alertType: StylishDialogType.SUCCESS,
      titleText: texttile,
      contentText: 'MSG: '+subtile,
      titleStyle:TextStyle(color: Colors.black),
      contentStyle: TextStyle(color: Colors.black),

    ).show();
  }
  Future<void> authPhotoErrorHandlebyBiswa(String text,BuildContext ctx) async {

    return StylishDialog(
      context: ctx,
      alertType: StylishDialogType.ERROR,
      titleText: 'Please, Pick An Image',
      contentText: 'Error: '+text,
      titleStyle:TextStyle(color: Colors.black),
      contentStyle: TextStyle(color: Colors.black),

    ).show();
  }
  Future<void> SuccessbyBiswa(String text,BuildContext ctx) async {

    return StylishDialog(
      context: ctx,
      alertType: StylishDialogType.SUCCESS,
      titleText: 'Successfully Added',
      contentText: 'MSG: '+text,
      titleStyle:TextStyle(color: Colors.black),
      contentStyle: TextStyle(color: Colors.black),
    ).show();
  }
  Future<void> SuccessPaymentbyBiswa(String text,BuildContext ctx) async {

    return StylishDialog(
      context: ctx,
      alertType: StylishDialogType.SUCCESS,
      titleText: 'Successfully Paid',
      contentText: 'MSG: '+text,
      titleStyle:TextStyle(color: Colors.black),
      contentStyle: TextStyle(color: Colors.black),
    ).show();
  }
  Future<void> ResetLinkSetFailedbyBiswa(String text,BuildContext ctx) async {

    return StylishDialog(
      context: ctx,
      alertType: StylishDialogType.ERROR,
      titleText: 'Sending Failed',
      contentText: 'MSG: '+text,
      titleStyle:TextStyle(color: Colors.black),
      contentStyle: TextStyle(color: Colors.black),
    ).show();
  }
  Future<void> SuccessCodbyBiswa(BuildContext ctx,int amt) async {

    return StylishDialog(
      context: ctx,
      alertType: StylishDialogType.SUCCESS,
      titleText: 'Successfully Approved',
      contentText: 'MSG: Your Payment Method is Cash On Delivery,Your total amount is ${amt} cents,Thanks For Shopping..',
      titleStyle:TextStyle(color: Colors.black),
      contentStyle: TextStyle(color: Colors.black),
    ).show();
  }

}
