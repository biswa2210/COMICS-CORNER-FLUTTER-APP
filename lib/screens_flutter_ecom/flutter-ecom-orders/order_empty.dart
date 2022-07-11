import 'package:flutter/material.dart';
import 'package:flutter_ecom_project/provider_flutter_ecom/darkTheme_setup.dart';
import 'package:flutter_ecom_project/screens_flutter_ecom/feedsScreen.dart';
import 'package:provider/provider.dart';


class OrderEmpty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeSetup>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Container(
            margin: EdgeInsets.only(top: 80),
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.47,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image:AssetImage("assets/images/biswaDesigning/empty_order.png"),
              ),
            ),
          ),
        ),
        SizedBox(height: 20,),
        Text(
          'Your order is Empty',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: 'FF',
              color: themeChange.darkTheme?Colors.white :Colors.black,
              fontSize: 36,
              fontWeight: FontWeight.w600),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          'Looks Like You didn\'t \n order anything yet',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'FF',
              color: themeChange.darkTheme
                  ? Theme.of(context).disabledColor
                  : Colors.red,
              fontSize: 26,
              fontWeight: FontWeight.w600),
        ),
        SizedBox(
          height: 30,
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.7,
          height: MediaQuery.of(context).size.height * 0.06,
          child: RaisedButton(
            onPressed: () { Navigator.of(context).pushNamed(FeedsScreen.routeName);},
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.red),
            ),
            color: Colors.redAccent,
            child: Text(
              'Shop now'.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'FF',
                  color: Theme.of(context).textSelectionColor,
                  fontSize: 30,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}
