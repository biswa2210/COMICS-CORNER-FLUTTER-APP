import 'package:flutter/material.dart';
import 'package:flutter_ecom_project/provider_flutter_ecom/darkTheme_setup.dart';
import 'package:provider/provider.dart';

import '../feedsScreen.dart';
class WishListEmpty extends StatelessWidget {
  const WishListEmpty({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeChange =  Provider.of<DarkThemeSetup>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Container(
            margin: EdgeInsets.only(top: 80),
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.47,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('assets/images/biswaDesigning/whishlist.png'),
              ),
            ),
          ),
        ),
        SizedBox(height: 20,),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Text(
            'Your Wishlist Is Empty',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'FF',
                color: Theme.of(context).textSelectionColor,
                fontSize: 35,
                fontWeight: FontWeight.w600),
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Text(
          'Explore more and please\'t \n shotlist some items',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'FF',
              color: themeChange.darkTheme
                  ? Theme.of(context).disabledColor
                  : Colors.black87,
              fontSize: 26,
              fontWeight: FontWeight.w600),
        ),
        SizedBox(
          height: 30,
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.75,
          height: MediaQuery.of(context).size.height * 0.07,
          child: RaisedButton(
            onPressed: () {
              Navigator.pushNamed(context,FeedsScreen.routeName);
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.red),
            ),
            color: Colors.redAccent,
            child: Text(
              'ADD A WISH'.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                 fontFamily: 'MR',
                  color: Theme.of(context).textSelectionColor,
                  fontSize: 26,
                  fontWeight: FontWeight.w600),
            ),

          ),
        ),
      ],
    );
  }
}
