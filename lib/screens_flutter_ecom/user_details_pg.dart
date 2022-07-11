import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_ecom_project/globalMethods/service_provide.dart';
import 'package:flutter_ecom_project/provider_flutter_ecom/darkTheme_setup.dart';
import 'package:flutter_ecom_project/screens_flutter_ecom/wishlist/WishList_flutter_ecom.dart';
import 'package:flutter_ecom_project/screens_flutter_ecom/cart/cartPgScreen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:list_tile_switch/list_tile_switch.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'flutter-ecom-orders/order.dart';
class UserScreen extends StatefulWidget {
  @override
  State<UserScreen> createState() => _UserScreenState();
}
const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    //'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);


class _UserScreenState extends State<UserScreen> {


  final firebaseAuth = FirebaseAuth.instance;
  String ?_uid;
  String ?_name;
  String ?_email;
  String ?_joinedAt;
  String ?_userImageUrl;
  String ?_phoneNumber;
  ScrollController ?_scrollController;
  File? _pickedImage;
  String? url;
  String ? _shippingAddress;
  String ? _pincode;
  var top = 0.0;
  bool switchState=false;
  _getSwitchState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      switchState = prefs.getBool('switchState')?? false;
      print(switchState);
    });
    getData();
  }
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
        _pincode = userDoc.get('pincode');
        _shippingAddress=userDoc.get('address');
      });
    }
    // print("name $_name");
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   // print(widget.switchState);
    _scrollController =ScrollController();
    _scrollController!.addListener(() {setState(() {

    });});

  }






  @override
  Widget build(BuildContext context) {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    _getSwitchState();
    final themeChange = Provider.of<DarkThemeSetup>(context);
    return Scaffold(
      backgroundColor: Colors.white,

      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: <Widget>[
              SliverAppBar(
                automaticallyImplyLeading: false,
                elevation: 4,
                expandedHeight: 200,
                pinned: true,
                backgroundColor: themeChange.darkTheme? Colors.black : switchState ? Colors.deepPurple :  Colors.orange,
                flexibleSpace: LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                      top = constraints.biggest.height;
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                                themeChange.darkTheme? Colors.black :switchState ? Colors.deepPurple : Colors.orangeAccent,
                                themeChange.darkTheme? Colors.black  :switchState ? Colors.deepPurple : Colors.orangeAccent,
                              ],
                              begin: const FractionalOffset(0.0, 0.0),
                              end: const FractionalOffset(1.0, 0.0),
                              stops: [0.0, 1.0],
                              tileMode: TileMode.clamp),
                        ),
                        child: FlexibleSpaceBar(
                          collapseMode: CollapseMode.parallax,
                          centerTitle: true,
                          title: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              //  mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                AnimatedOpacity(
                                  duration: Duration(milliseconds: 300),
                                  opacity: top <= 110.0 ? 1.0 : 0,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 12,
                                      ),
                                      Container(
                                        height: kToolbarHeight / 1.8,
                                        width: kToolbarHeight / 1.8,
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.white,
                                              blurRadius: 1.0,
                                            ),
                                          ],
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image: NetworkImage(_userImageUrl ??
                                                'https://t3.ftcdn.net/jpg/01/83/55/76/240_F_183557656_DRcvOesmfDl5BIyhPKrcWANFKy2964i9.jpg'),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 12,
                                      ),
                                      Text(
                                        // 'top.toString()',
                                         _name == null ? 'Guest' : _name!,
                                        style: TextStyle(
                                            fontSize: 22.0, color: Colors.white,fontFamily: 'PALADINS',),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          background: Image(
                            image: NetworkImage(_userImageUrl ??
                                'https://t3.ftcdn.net/jpg/01/83/55/76/240_F_183557656_DRcvOesmfDl5BIyhPKrcWANFKy2964i9.jpg'),
                            fit: BoxFit.fill,
                          ),
                        ),
                      );
                    }),
              ),
              SliverToBoxAdapter(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: userTitle('User Bag',switchState,themeChange.darkTheme)),
                    Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        splashColor: Theme.of(context).splashColor,
                        child: ListTile(
                          onTap: () => Navigator.of(context).pushNamed(
                              WishListScreen.routeName
                          ),
                          title: Text('Wishlist',style: TextStyle(color: themeChange.darkTheme ? Colors.black :switchState? Colors.deepPurpleAccent:Colors.deepOrange,fontFamily: 'TCE',fontSize: 25)),
                          trailing: Icon(Icons.chevron_right_rounded,color: themeChange.darkTheme ? Colors.black :switchState? Colors.purple:Colors.orange),
                          leading: Icon(FontAwesome5.list,color: themeChange.darkTheme ? Colors.black :switchState? Colors.purple:Colors.orange,),
                        ),
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        splashColor: Theme.of(context).splashColor,
                        child: ListTile(
                          onTap: () => Navigator.of(context).pushNamed(
                              CartScreen.routeName
                          ),
                          title: Text('Cart',style: TextStyle(color: themeChange.darkTheme ? Colors.black :switchState? Colors.deepPurpleAccent:Colors.deepOrange,fontFamily: 'TCE',fontSize: 25)),
                          trailing: Icon(Icons.chevron_right_rounded,color: themeChange.darkTheme ? Colors.black :switchState? Colors.purple:Colors.orange),
                          leading: Icon(FontAwesome5.shopping_cart,color: themeChange.darkTheme ? Colors.black :switchState? Colors.purple:Colors.orange),
                        ),
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        splashColor: Theme.of(context).splashColor,
                        child: ListTile(
                          onTap: () => Navigator.of(context)
                              .pushNamed(OrderScreen.routeName),
                          title: Text('My Orders',style: TextStyle(color:themeChange.darkTheme ? Colors.black :switchState? Colors.deepPurpleAccent:Colors.deepOrange,fontFamily: 'TCE',fontSize: 25),),
                          trailing: Icon(Icons.chevron_right_rounded,color: themeChange.darkTheme ? Colors.black :switchState? Colors.purple:Colors.orange,),
                          leading: Icon(FontAwesome5.shopping_bag,color:themeChange.darkTheme ? Colors.black :switchState? Colors.purple:Colors.orange),
                        ),
                      ),
                    ),
                    Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                    Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: userTitle('User Informations',switchState,themeChange.darkTheme)),
                    Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                    userListTile('Email',_email ?? '', 0,switchState, context),
                    userListTile('Phone Number', _phoneNumber.toString() ?? '', 1, switchState,context),
                    userListTile('Joind At', _joinedAt ?? '', 3, switchState,context),
                    userListTile('Shipping Address', _shippingAddress ?? '', 2,switchState, context),
                    userListTile('Pincode', _pincode ?? '', 2,switchState, context),
                    Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: userTitle('User settings',switchState,themeChange.darkTheme),
                    ),
                    Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                    ListTileSwitch(
                      value: themeChange.darkTheme,
                      leading: Icon(themeChange.darkTheme ?  FontAwesome5.sun :FontAwesome5.moon ,color:themeChange.darkTheme ? Colors.yellowAccent : Colors.yellow,),
                      onChanged: (value) {
                        setState(() {
                          themeChange.darkTheme = value;
                        });
                      },
                      visualDensity: VisualDensity.comfortable,
                      switchType: SwitchType.cupertino,
                      switchActiveColor: Colors.indigo,
                      title: Text(themeChange.darkTheme ? 'Light theme' : 'Dark theme',style:TextStyle(color:Colors.black,fontFamily: 'TCE',fontSize: 25)),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        splashColor: Theme.of(context).splashColor,
                        child: ListTile(
                          onTap: () async{
                            showDialog(
                                context: context,
                                builder: (BuildContext ctx) {
                                  return AlertDialog(
                                    title: Row(
                                      children: [
                                        Padding(
                                          padding:
                                          const EdgeInsets.only(right: 6.0),
                                          child:Image(
                                            image: AssetImage("assets/images/icons/signout-error.png"),
                                            width: 20,
                                            height: 20,
                                          )
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text('Sign out',style: TextStyle(fontFamily: 'PALADINS',fontSize: 20),),
                                        ),
                                      ],
                                    ),
                                    content: Text('Do you wanna Sign out?'),
                                    actions: [
                                      TextButton(
                                          onPressed: () async {
                                            flutterLocalNotificationsPlugin.show(  0,
                                                "Thanks",
                                                "For cancelling logout",
                                                NotificationDetails(
                                                    android: AndroidNotificationDetails(channel.id, channel.name,
                                                        importance: Importance.high,
                                                        color: Colors.blue,
                                                        playSound: true,
                                                        icon: '@mipmap/ic_launcher')));
                                            Navigator.pop(context);
                                          },
                                          child: Text('Cancel')),
                                      TextButton(
                                          onPressed: () async {
                                            await firebaseAuth.signOut().then((value) => Navigator.pop(context));
                                          },
                                          child: Text('Ok', style: TextStyle(color: Colors.red),))
                                    ],
                                  );
                                });
                          },
                          title: Text('Logout',style: TextStyle(color: Colors.blue  ,fontFamily: 'TCE' ,fontSize: 25),),
                          leading: Icon(Icons.exit_to_app_rounded,color: themeChange.darkTheme?  Colors.black : Colors.blue,),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          _buildFabFlutterEcom(context)
        ],
      ),
    );

  }



  void _pickImageCamera() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.camera, imageQuality: 10);
    final pickedImageFile = File(pickedImage!.path);
    setState(() {
      _pickedImage = pickedImageFile;
    });
    Navigator.pop(context);
    final User? user = FirebaseAuth.instance.currentUser;
    final ref = await FirebaseStorage.instance
        .ref()
        .child('usersImages')
        .child(_name!+(user!.uid).toString()+'.jpg');
    await ref.putFile(_pickedImage!);
    url = await ref.getDownloadURL();
    final _uid = user!.uid;
    print(_uid);
    user.updateProfile(photoURL: url,displayName: _name!);
    user.reload();
    await FirebaseFirestore.instance.collection('users').doc(_uid).update({
      'imageUrl': url
    });

  }

  void _pickImageGallery() async{
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.gallery);
    final pickedImageFile = File(pickedImage!.path);
    setState(() {
      _pickedImage = pickedImageFile;
    });
    Navigator.pop(context);
    final User? user = FirebaseAuth.instance.currentUser;
    final ref = await FirebaseStorage.instance
        .ref()
        .child('usersImages')
        .child(_name!+(user!.uid).toString()+'.jpg');
    await ref.putFile(_pickedImage!);
    url = await ref.getDownloadURL();
    final _uid = user!.uid;
    print(_uid);
    user.updateProfile(photoURL: url,displayName: _name!);
    user.reload();
    await FirebaseFirestore.instance.collection('users').doc(_uid).update({
      'imageUrl': url
    });

  }







  Widget _buildFabFlutterEcom(BuildContext context) {
    //starting fab position
    final themeChange = Provider.of<DarkThemeSetup>(context);

    final double defaultTopMargin = 200.0 - 4.0;
    //pixels from top where scaling should start
    final double scaleStart = 160.0;
    //pixels from top where scaling should end
    final double scaleEnd = scaleStart / 2;

    double top = defaultTopMargin;
    double scale = 1.0;
    if (_scrollController!.hasClients) {
      double offset = _scrollController!.offset;
      top -= offset;
      if (offset < defaultTopMargin - scaleStart) {
        //offset small => don't scale down
        scale = 1.0;
      } else if (offset < defaultTopMargin - scaleEnd) {
        //offset between scaleStart and scaleEnd => scale down
        scale = (defaultTopMargin - scaleEnd - offset) / scaleEnd;
      } else {
        //offset passed scaleEnd => hide fab
        scale = 0.0;
      }
    }

    return  Positioned(
      top: top,
      right: 16.0,
      child:  Transform(
        transform:  Matrix4.identity()..scale(scale),
        alignment: Alignment.center,
        child:  FloatingActionButton(
          heroTag: "btn1",
          splashColor: Colors.cyan,
          backgroundColor:themeChange.darkTheme? Colors.black : switchState ? Colors.deepPurple :  Colors.orange,
          onPressed: (){
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                      'Choose option',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: 'PALADINS',
                          color: Colors.blue),
                    ),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: [
                          InkWell(
                            onTap:_pickImageCamera,
                            splashColor: Colors.purpleAccent,
                            child: Row(
                              children: [
                                Padding(
                                  padding:
                                  const EdgeInsets.all(8.0),
                                  child: Icon(
                                    FontAwesome5.camera,
                                    color: themeChange.darkTheme? Colors.black : switchState ? Colors.deepPurple :  Colors.orange,
                                  ),
                                ),
                                Text(
                                  'Camera',
                                  style: TextStyle(
                                      fontSize: 18,
                                    fontFamily: 'PALADINS',
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                  ),
                                )
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: _pickImageGallery,
                            splashColor: Colors.purpleAccent,
                            child: Row(
                              children: [
                                Padding(
                                  padding:
                                  const EdgeInsets.all(8.0),
                                  child: Icon(
                                    FontAwesome5.images,
                                    color: Colors.purpleAccent,
                                  ),
                                ),
                                Text(
                                  'Gallery',
                                  style: TextStyle(
                                      fontFamily: 'PALADINS',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });

          },
          child:  Icon(FontAwesome5.camera,color:Colors.white ,),
        ),
      ),
    );
  }
}

List<IconData> _userTileIcons = [
  Icons.email,
  Icons.phone,
  Icons.local_shipping,
  Icons.watch_later,
  Icons.exit_to_app_rounded
];

Widget userListTile(
    String title, String subTitle, int index,bool switchState, BuildContext context)
{
  ServiceProvideMethods spm =new ServiceProvideMethods();
  final themeChange = Provider.of<DarkThemeSetup>(context);
  return Material(
    color: Colors.transparent,
    child: InkWell(
      splashColor: Theme.of(context).splashColor,
      child: ListTile(
        onTap: () {
          if(index==2){
            TextEditingController _addressController = TextEditingController();
            TextEditingController _pinController = TextEditingController();
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Add a shipping address',style: TextStyle(fontFamily: 'TCE',fontSize: 30,color: themeChange.darkTheme? Colors.black : switchState ? Colors.deepPurple :  Colors.orange),),
                  content: Container(
                    height: 100,
                    child: Column(
                      children: [
                        TextField(
                          controller: _addressController,
                          decoration: InputDecoration(
                              hintText: "Your shipping address",
                              hintStyle: TextStyle(
                                fontFamily: 'QH',
                                fontSize: 22
                              )

                          ),
                        ),
                        TextField(
                          controller: _pinController,
                          decoration: InputDecoration(
                              hintText: "Your pin code",
                              hintStyle: TextStyle(
                                  fontFamily: 'QH',
                                  fontSize: 22
                              )),
                        ),
                      ],
                    ),
                  ),

                  actions: <Widget>[
                    FlatButton(
                      child: Text('CANCEL'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    FlatButton(
                      child: Text('OK'),
                      onPressed: () async {
                        if(_pinController.text.isEmpty){
                          spm.StylishDialogErrorbyBiswa("Enter Pin Code", "please enter your proper pin code or postal code.",context);
                        }
                        if(_addressController.text.isEmpty){
                          spm.StylishDialogErrorbyBiswa("Enter Address", "please enter your proper address.",context);
                        }
                        else{
                          await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).update({
                            'address':_addressController.text,
                                'pincode':_pinController.text
                          });
                          Navigator.pop(context);
                        }

                      },
                    ),
                  ],
                );
              },
            );
          }
        },
        title: Text(title,style: TextStyle(color:themeChange.darkTheme ? Colors.black :switchState? Colors.deepPurpleAccent:Colors.deepOrange ,fontFamily: 'TCE',fontSize: 25)),
        subtitle: Text(subTitle,style: TextStyle(color:themeChange.darkTheme?  Colors.black : Colors.black54 ,fontSize: 20),) ,
        leading: Icon(_userTileIcons[index],size: 35,color: themeChange.darkTheme ? Colors.black : switchState? Colors.purple:Colors.orange,),
      ),
    ),
  );
}

Widget userTitle(String title,bool switchState,bool darkTheme) {
  return Padding(
    padding: const EdgeInsets.all(14.0),
    child: Text(
      title,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28,color: darkTheme ? Colors.black :switchState? Colors.purple:Colors.orange,fontFamily: 'MR'),
    ),
  );
}