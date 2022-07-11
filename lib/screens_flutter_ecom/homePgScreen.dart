import 'package:backdrop/backdrop.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecom_project/inner_screens_flutter_ecom/brands_navigation_rail%20copy_flutter_ecom.dart';
import 'package:flutter_ecom_project/provider_flutter_ecom/products_setup.dart';
import 'package:flutter_ecom_project/screens_flutter_ecom/feedsScreen.dart';
import 'package:flutter_ecom_project/widgets_flutter_ecom/backlayer_flutter_ecom.dart';
import 'package:flutter_ecom_project/widgets_flutter_ecom/categories_flutter_ecom.dart';
import 'package:flutter_ecom_project/widgets_flutter_ecom/popular_products.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider_flutter_ecom/darkTheme_setup.dart';
class HomePg extends StatefulWidget {
  static const routeName = '/HomePg';
  @override
  State<HomePg> createState() => _HomePgState();
}
final List<String> _carouselImages = [
  'assets/images/carousel_images/comics-1.jpg',
  'assets/images/carousel_images/comics-2.jpg',
  'assets/images/carousel_images/comics-3.jpg',
  'assets/images/carousel_images/comics-4.jpg',
  'assets/images/carousel_images/comics-5.jpg',
  'assets/images/carousel_images/comics-6.jpg',
  'assets/images/carousel_images/comics-7.jpg',
  'assets/images/carousel_images/comics-8.jpg'
];
final List<Widget> imageSliders = _carouselImages.map((item) => Container(
  child: Container(
    margin: EdgeInsets.all(5.0),
    child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        child: Stack(
          children: <Widget>[
            Image.asset(item, fit: BoxFit.cover, width: double.infinity),
            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(200, 0, 0, 0),
                      Color.fromARGB(0, 0, 0, 0)
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                padding: EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 20.0),
                child: Text(
                  'No. ${(_carouselImages.indexOf(item))+1} poster',
                  style: TextStyle(
                    fontFamily: 'FF',
                    color: Colors.cyanAccent,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        )),
  ),
))
    .toList();
class _HomePgState extends State<HomePg> {
  bool switchState=false;
  _getSwitchState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      switchState = prefs.getBool('switchState')?? false;
      print(switchState);
    });
    getData();
  }

  List _brandImages = [
     'assets/images/brands/marvel.png',
     'assets/images/brands/dc.jpg',
     'assets/images/brands/de.jpg',
     'assets/images/brands/darkH.jpg',
     'assets/images/brands/NarayanDeb.jpg'

  ];


  final firebaseAuth = FirebaseAuth.instance;
  String ?_uid;
  String ?_name;
  String ?_email;
  String ?_joinedAt;
  String  _userImageUrl="";
  String ?_phoneNumber;
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
        _name = userDoc.get('name');
        _email = user.email!;
        _joinedAt = userDoc.get('joinedAt');
        _phoneNumber = userDoc.get('phoneNumber');
        _userImageUrl = userDoc.get('imageUrl');
      });
    }
    // print("name $_name");
  }


  @override
  Widget build(BuildContext context) {
    _getSwitchState();
    final themeChange = Provider.of<DarkThemeSetup>(context);
    final popularProductsData = Provider.of<Products>(context);
    popularProductsData.FetchProducts();
    final popularProducts = popularProductsData.popularProducts_fc;
    return Scaffold(
      backgroundColor: Colors.white,
      body: BackdropScaffold(
        headerHeight: MediaQuery.of(context).size.height * 0.25,
        appBar: BackdropAppBar(
          backgroundColor:themeChange.darkTheme ? Colors.black: switchState? Colors.deepPurple:Colors.orange,
          title: Text("COMICS CORNER",style: TextStyle(fontFamily: 'MR',fontSize:25),),
          leading: BackdropToggleButton(
            icon: AnimatedIcons.home_menu,
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: themeChange.darkTheme?
              [Colors.black,
                Colors.black,
                Colors.black
              ] : switchState? [
                Colors.black12,
                Colors.purpleAccent,
                Colors.black
              ]:[
                Colors.orange,
                Colors.orangeAccent,
                Colors.blueGrey
              ])
            ),
          ),
          actions:  <Widget>[
            IconButton(
                onPressed:(){

            },
           padding: const EdgeInsets.all(5.0),
                iconSize: 20,
                icon: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 17,
                    backgroundImage: NetworkImage(_userImageUrl ??
                        'https://t3.ftcdn.net/jpg/01/83/55/76/240_F_183557656_DRcvOesmfDl5BIyhPKrcWANFKy2964i9.jpg'),

                  ),
                )
            )
          ],
        ),
        backLayer: BackLayerFlutterEcom(userImageUrl: _userImageUrl!,sw_St: switchState),
        frontLayer: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start ,
      children: [
      Container(
      height: 190.0,
          width: double.infinity,
          child: CarouselSlider(
              items: imageSliders,
              options: CarouselOptions(
                aspectRatio: 2.0,
                enlargeCenterPage: true,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                scrollDirection: Axis.vertical,
              )
          )
      ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child:Text(
                  'Comics Categories',
                  style: TextStyle(fontFamily: 'FF',fontWeight: FontWeight.w800, fontSize: 30),
                ),
          ),
      Container(
          width: double.infinity,
          height: 180,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 6,
              itemBuilder: (BuildContext ctx,int i){
            return CategoryList(index: i);
          }),
      ),

      Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text(
                'Popular Brands',
                style: TextStyle(fontFamily: 'FF',fontWeight: FontWeight.w800, fontSize: 30),
              ),
              Spacer(),
              FlatButton(
                onPressed: () {
                  Navigator.pushNamed(
                      context,
                      BrandNavigationRailScreen.routeName,
                      arguments: {0}
                  );
                },
                child: Text(
                  'View all...',
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                      color: Colors.red),
                ),
              )
            ],
          ),
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: Container(
            height: 210,
            width: MediaQuery.of(context).size.width * 0.95,
            child: Swiper(
              itemCount: _brandImages.length,
              autoplay: true,
              viewportFraction: 0.8,
              scale: 0.9,
              onTap: (index){
                Navigator.pushNamed(
                  context,
                  BrandNavigationRailScreen.routeName,
                  arguments: {index}
                );
              },
              itemBuilder: (BuildContext ctx, int index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    color: Colors.blueGrey,
                    child: Image.asset(_brandImages[index], fit: BoxFit.fill,),),
                );
              },
            ),
        ),
      ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text(
                'Popular Products',
                style: TextStyle(fontFamily:'FF',fontWeight: FontWeight.w800, fontSize: 30),
              ),
              Spacer(),
              FlatButton(
                onPressed: () {
                  Navigator.pushNamed(context, FeedsScreen.routeName,arguments: 'popular');
                },
                child: Text(
                  'View all...',
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                      color: Colors.red),
                ),
              )
            ],
          ),
        ),
        Container(
          width: double.infinity,
          height: 285,
          margin: EdgeInsets.symmetric(horizontal: 3),
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: popularProducts.length,
              itemBuilder: (BuildContext ctx,int index){
            return PopularProducts(
               id: popularProducts[index].id,
              title: popularProducts[index].title,
              description: popularProducts[index].description,
              price: popularProducts[index].price,
              imageUrl: popularProducts[index].imageUrl,
              productCategoryName: popularProducts[index].productCategoryName,
              brand: popularProducts[index].brand,
              quantity: popularProducts[index].quantity,
              isFavorite: popularProducts[index].isFavorite,
              isPopular: popularProducts[index].isPopular,
            );
          }),
        )
      ],
    ),
        ),
      )


    );

  }
}
