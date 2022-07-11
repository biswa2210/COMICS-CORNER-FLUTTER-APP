// @dart=2.9
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ecom_project/consts_flutter_ecom/theme_data.dart';
import 'package:flutter_ecom_project/inner_screens_flutter_ecom/brands_navigation_rail%20copy_flutter_ecom.dart';
import 'package:flutter_ecom_project/inner_screens_flutter_ecom/catagories_feeds.dart';
import 'package:flutter_ecom_project/inner_screens_flutter_ecom/product_details_flutter_ecom.dart';
import 'package:flutter_ecom_project/provider_flutter_ecom/orders_providers.dart';
import 'package:flutter_ecom_project/screens_flutter_ecom/auth/forgetPasswrd.dart';
import 'package:flutter_ecom_project/screens_flutter_ecom/flutter-ecom-orders/order.dart';
import 'package:flutter_ecom_project/screens_flutter_ecom/upload_product_form.dart';
import 'package:flutter_ecom_project/provider_flutter_ecom/darkTheme_setup.dart';
import 'package:flutter_ecom_project/provider_flutter_ecom/fav_provider_biswa2210.dart';
import 'package:flutter_ecom_project/provider_flutter_ecom/products_setup.dart';
import 'package:flutter_ecom_project/provider_flutter_ecom/provider_for_cart.dart';
import 'package:flutter_ecom_project/screens_flutter_ecom/BottomBar.dart';
import 'package:flutter_ecom_project/screens_flutter_ecom/wishlist/WishList_flutter_ecom.dart';
import 'package:flutter_ecom_project/screens_flutter_ecom/auth/login.dart';
import 'package:flutter_ecom_project/screens_flutter_ecom/auth/sign_up.dart';
import 'package:flutter_ecom_project/screens_flutter_ecom/cart/cartPgScreen.dart';
import 'package:flutter_ecom_project/screens_flutter_ecom/feedsScreen.dart';
import 'package:flutter_ecom_project/screens_flutter_ecom/homePgScreen.dart';
import 'package:flutter_ecom_project/screens_flutter_ecom/landing_page.dart';
import 'package:flutter_ecom_project/screens_flutter_ecom/main_screen.dart';
import 'package:flutter_ecom_project/screens_flutter_ecom/user_details_pg.dart';
import 'package:flutter_ecom_project/screens_flutter_ecom/user_state.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';


const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    //'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A bg message just showed up :  ${message.messageId}');
}


Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((value) {
    runApp(MyApp());
  });

}
Map<String, WidgetBuilder> routes = {
 // "/": (context) => LandingPage(),//BottomBar(),
  "/HomePg":(context) => HomePg(),
  "/BottomBar":(context)=>BottomBar(),
  "/brands_navigation_rail": (context) => BrandNavigationRailScreen(),
  "/FeedsPg":(context)=>FeedsScreen(),
  "/CartPg":(context)=>CartScreen(),
  "/WishListPg":(context)=>WishListScreen(),
  "/ProductDetails":(context)=>ProductDetails(),
  "/CatagoriesFeedsPg":(context)=>CatagoryFeedsScreen(),
  "/LoginScreen":(context)=>LoginScreen(),
  "/SignUpScreen":(context)=>SignUpScreen(),
  "/UploadProductForm":(context)=>UploadProductForm(),
  "/ForgetPassword":(context)=>ForgetPassword(),
  OrderScreen.routeName: (ctx) => OrderScreen(),

};
class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  DarkThemeSetup themeSet = DarkThemeSetup();

  void getCurrentAppTheme() async{
    themeSet.darkTheme = await themeSet.darkprefs.getTheme();
  }
  @override
  void initState() {
    // TODO: implement initState

    getCurrentAppTheme();
    super.initState();


    //Notification Integration
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher',
              ),
            ));
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification.android;
      if (notification != null && android != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification.title ?? ""),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(notification.body ?? "")],
                  ),
                ),
              );
            });
      }
    });
  }
  final Future<FirebaseApp> _initialize= Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {

    return FutureBuilder<Object>(
      future: _initialize,
      builder: (context, snapshot) {
        if(snapshot.connectionState==ConnectionState.waiting){
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
        else if(snapshot.hasError){
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text("Error Occured")
              ),
            ),
          );
        }
        return MultiProvider(providers: [
          ChangeNotifierProvider(create: (_){
            return themeSet;
          }),
          ChangeNotifierProvider(create :(_) =>
              Products(),
          ),
          ChangeNotifierProvider(create: (_)=>
              providerCart(),
          ),
          ChangeNotifierProvider(create: (_)=>
            FavsProvider()
          ),
          ChangeNotifierProvider(
            create: (_) => OrdersProvider(),
          ),
        ],

        child: Consumer<DarkThemeSetup>(
            builder: (context, themeData,child) {
              return MaterialApp(
                title: 'Flutter Demo',
                home: UserState(),
                theme: Styles.themeData(themeSet.darkTheme, context),
                  routes : routes,
                //initialRoute: "/",
              );

            }
        ),);
      }
    );

  }
}

