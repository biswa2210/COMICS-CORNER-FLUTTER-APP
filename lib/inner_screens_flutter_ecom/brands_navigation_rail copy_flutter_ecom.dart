import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecom_project/provider_flutter_ecom/products_setup.dart';
import 'package:provider/provider.dart';

import '../provider_flutter_ecom/darkTheme_setup.dart';
import 'brands_rail_widget_flutter_ecom.dart';

class BrandNavigationRailScreen extends StatefulWidget {
  BrandNavigationRailScreen({Key ? key}) : super(key: key);

  static const routeName = '/brands_navigation_rail';
  @override
  _BrandNavigationRailScreenState createState() =>
      _BrandNavigationRailScreenState();
}

class _BrandNavigationRailScreenState extends State<BrandNavigationRailScreen> {
  int _selectedIndex = 0;
  final padding = 8.0;
  late String routeArgs;
  late String brand;
  @override
  void didChangeDependencies() {
    routeArgs = ModalRoute.of(context)!.settings.arguments.toString();
    _selectedIndex = int.parse(
      routeArgs.substring(1, 2),
    );
    print(routeArgs.toString());
    if (_selectedIndex == 0) {
      setState(() {
        brand = 'Marvel';
      });
    }
    if (_selectedIndex == 1) {
      setState(() {
        brand = 'DC';
      });
    }
    if (_selectedIndex == 2) {
      setState(() {
        brand = 'Dynamite Entertainment';
      });
    }
    if (_selectedIndex == 3) {
      setState(() {
        brand = 'DARK HORSE';
      });
    }
    if (_selectedIndex == 4) {
      setState(() {
        brand = 'NarayanDebnath';
      });
    }

    super.didChangeDependencies();
  }
  final firebaseAuth = FirebaseAuth.instance;
  String ?_uid;
  String ?_name;
  String ?_email;
  String ?_joinedAt;
  String _userImageUrl="";
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
    getData();
    return Scaffold(
      body: Row(
        children: <Widget>[
          LayoutBuilder(
            builder: (context, constraint) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraint.maxHeight),
                  child: IntrinsicHeight(
                    child: NavigationRail(
                      minWidth: 56.0,
                      groupAlignment: 1.0,
                      selectedIndex: _selectedIndex,
                      onDestinationSelected: (int index) {
                        setState(() {
                          _selectedIndex = index;
                          if (_selectedIndex == 0) {
                            setState(() {
                              brand = 'Marvel';
                            });
                          }
                          if (_selectedIndex == 1) {
                            setState(() {
                              brand = 'DC';
                            });
                          }
                          if (_selectedIndex == 2) {
                            setState(() {
                              brand = 'Dynamite Entertainment';
                            });
                          }
                          if (_selectedIndex == 3) {
                            setState(() {
                              brand = 'DARK HORSE';
                            });
                          }
                          if (_selectedIndex == 4) {
                            setState(() {
                              brand = 'Narayan Debnath';
                            });
                          }
                          print(brand);
                        });
                      },
                      labelType: NavigationRailLabelType.all,
                      leading: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: CircleAvatar(
                              radius: 16,
                              backgroundImage: NetworkImage( _userImageUrl ??
                                  "https://cdn1.vectorstock.com/i/thumb-large/62/60/default-avatar-photo-placeholder-profile-image-vector-21666260.jpg"),
                            ),
                          ),
                          SizedBox(
                            height: 80,
                          ),
                        ],
                      ),
                      selectedLabelTextStyle: TextStyle(
                        color: Color(0xffffe6bc97),
                        fontSize: 20,
                        letterSpacing: 1,
                        decoration: TextDecoration.underline,
                        decorationThickness: 2.5,
                      ),
                      unselectedLabelTextStyle: TextStyle(
                        fontSize: 15,
                        letterSpacing: 0.8,
                      ),
                      destinations: [
                        buildRotatedTextRailDestination('Marvel', padding),
                        buildRotatedTextRailDestination("DC", padding),
                        buildRotatedTextRailDestination("Dynamite Entertainment", padding),
                        buildRotatedTextRailDestination("Dark Horse", padding),
                        buildRotatedTextRailDestination("Narayan Debnath", padding),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          // This is the main content.

          ContentSpace(context, brand)
        ],
      ),
    );
  }
}

NavigationRailDestination buildRotatedTextRailDestination(
    String text, double padding) {
  return NavigationRailDestination(
    icon: SizedBox.shrink(),
    label: Padding(
      padding: EdgeInsets.symmetric(vertical: padding),
      child: RotatedBox(
        quarterTurns: -1,
        child: Text(text),
      ),
    ),
  );
}

class ContentSpace extends StatelessWidget {
  // final int _selectedIndex;

  final String brand;
  ContentSpace(BuildContext context, this.brand);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final productBrand = productsData.findbyBrand(brand);
    if(brand=='All'){
      for(int i=0; i<productsData.products.length;i++){
        productBrand.add(productsData.products[i]);
      }
    }
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 0, 0),
        child: MediaQuery.removePadding(
          removeTop: true,
          context: context,
          child: ListView.builder(
            itemCount: productBrand.length,
            itemBuilder: (BuildContext context, int index) =>
                BrandsNavigationRail(
                  themeState: Provider.of<DarkThemeSetup>(context).darkTheme,
                  id: productBrand[index].id,
                  title: productBrand[index].title,
                  description: productBrand[index].description,
                  price: productBrand[index].price,
                  imageUrl: productBrand[index].imageUrl,
                  productCategoryName: productBrand[index].productCategoryName,
                  brand: productBrand[index].brand,
                  quantity: productBrand[index].quantity,
                  isFavorite: productBrand[index].isFavorite,
                  isPopular: productBrand[index].isPopular,
                ),
          ),
        ),
      ),
    );
  }
}
