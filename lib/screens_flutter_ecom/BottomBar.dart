import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecom_project/provider_flutter_ecom/darkTheme_setup.dart';
import 'package:flutter_ecom_project/screens_flutter_ecom/SearchPgScreen.dart';
import 'package:flutter_ecom_project/screens_flutter_ecom/cart/cartPgScreen.dart';
import 'package:flutter_ecom_project/screens_flutter_ecom/feedsScreen.dart';
import 'package:flutter_ecom_project/screens_flutter_ecom/homePgScreen.dart';
import 'package:flutter_ecom_project/screens_flutter_ecom/user_details_pg.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
class BottomBar extends StatefulWidget {
  static const routeName = '/BottomBar';
  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  late List<Map<String, Widget>> _pages;
  int _selectedPageIndex = 0;
  bool switchState=false;
  DarkThemeSetup themeSet = DarkThemeSetup();

  void getCurrentAppTheme() async{
    themeSet.darkTheme = await themeSet.darkprefs.getTheme();
  }
  Future<bool> saveSwitchSate(bool switchOn) async{
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences prefs = await _prefs;
    await prefs.setBool('switchState', switchOn);
    return prefs.commit();
  }
  void changeSwitchState(bool state){
    setState(() {
        switchState= !switchState;
      saveSwitchSate(switchState);
    });
  }
  _getSwitchState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      switchState = prefs.getBool('switchState')?? false;
      print(switchState);
    });
  }
  @override
  void initState() {

    print(switchState);
    _pages = [
      {
        'page': HomePg(),
      },
      {
        'page': FeedsScreen(),
      },
      {
        'page': SearchScreen(),
      },
      {
        'page': CartScreen(),
      },
      {
        'page': UserScreen(),
      },
    ];
    super.initState();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeSetup>(context);
    getCurrentAppTheme();
    _getSwitchState();
    return Scaffold(
      body: _pages[_selectedPageIndex]['page'],
      bottomNavigationBar: switchState ?  CurvedNavigationBar(
        height: 60.0,
        items: <Widget>[
        Icon(FontAwesome5.home,size: 28,color:Colors.white),
        Icon(FontAwesome5.rss,size: 28,color:Colors.white),
        Icon(FontAwesome5.search,size: 28,color:Colors.white,),
        Icon(FontAwesome5.shopping_bag,size: 28,color: Colors.white,),
        Icon(FontAwesome.user,size: 28,color:Colors.white),
      ],
        color: themeChange.darkTheme ? Colors.black:Colors.deepPurple,
        buttonBackgroundColor: themeChange.darkTheme ? Colors.black: Colors.deepPurple,
        backgroundColor: Colors.white,
        animationCurve: Curves.easeInOutCubicEmphasized,
        animationDuration: Duration(milliseconds: 600),
        onTap: _selectPage,)
          :
      Container(
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
                color:themeChange.darkTheme ? Colors.black : Colors.orange,
                blurRadius: 15.0,
                offset: Offset(0.0, 0.75)
            )
          ],
        ),
        child: ConvexAppBar(

          items: [
            TabItem(icon: Icon(FontAwesome5.home,color: Colors.black,), title: 'Home',activeIcon: Icon(FontAwesome5.home,size: 35,color: Colors.white,)),
            TabItem(icon: Icon(FontAwesome5.rss,color: Colors.black,), title: 'Feeds',activeIcon: Icon(FontAwesome5.rss,size: 35,color: Colors.white)),
            TabItem(icon: Icon(FontAwesome5.search,color: Colors.black), title: 'Search',activeIcon: Icon(FontAwesome5.search,size: 35,color: Colors.white,)),
            TabItem(icon: Icon(FontAwesome5.shopping_bag,color: Colors.black), title: 'Cart',activeIcon: Icon(FontAwesome5.shopping_bag,size: 35,color: Colors.white,)),
            TabItem(icon: Icon(FontAwesome5.user,color: Colors.black), title: 'User',activeIcon: Icon(FontAwesome5.user,size: 35,color: Colors.white,)),
          ],
          onTap: _selectPage, 
          activeColor:themeChange.darkTheme? Colors.black : Colors.orange,
          backgroundColor: Colors.white,
          color: Colors.black,
        ),
      )
            ,

        floatingActionButtonLocation:FloatingActionButtonLocation.endFloat,
        floatingActionButton: Padding(
          padding: EdgeInsets.fromLTRB(0,0,0,20),
          child: Switch(
            value: switchState,
            activeColor:themeSet.darkTheme ? Colors.black:Colors.deepPurple ,
            activeTrackColor:Colors.grey,
            inactiveThumbColor: themeSet.darkTheme ? Colors.black:Colors.orange,
            inactiveTrackColor: Colors.grey,
            onChanged: changeSwitchState,
          ),
        )
    );




  }
}
