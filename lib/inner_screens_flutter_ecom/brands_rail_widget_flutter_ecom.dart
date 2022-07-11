import 'package:flutter/material.dart';
import 'package:flutter_ecom_project/inner_screens_flutter_ecom/product_details_flutter_ecom.dart';
import 'package:flutter_ecom_project/provider_flutter_ecom/products_setup.dart';
import 'package:provider/provider.dart';

class BrandsNavigationRail extends StatefulWidget {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final String productCategoryName;
  final String brand;
  final int quantity;
  final bool isFavorite;
  final bool isPopular;
  final bool themeState;

  const BrandsNavigationRail({Key? key, required this.id, required this.title,required this.themeState,
    required this.description, required this.price, required this.imageUrl,
    required this.productCategoryName, required this.brand, required this.quantity,
    required this.isFavorite, required this.isPopular}) : super(key: key);
  @override
  State<BrandsNavigationRail> createState() => _BrandsNavigationRailState();
}

class _BrandsNavigationRailState extends State<BrandsNavigationRail> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, ProductDetails.routeName,arguments: widget.id);
      },
      child: Container(
        color: Color.fromRGBO(255, 0, 0, 0.0),
        padding: EdgeInsets.only(left: 5.0, right: 5.0),
        margin: EdgeInsets.only(right: 20.0, bottom: 5, top: 18),
        constraints: BoxConstraints(
            minHeight: 150, minWidth: double.infinity, maxHeight: 180),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  image: DecorationImage(
                      image: NetworkImage(
                   widget.imageUrl  ),
                      fit: BoxFit.fill),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  boxShadow: [
                    BoxShadow(
                        color: widget.themeState ? Color.fromRGBO(155, 155, 155, 0): Colors.grey,
                        offset: Offset(2.0, 2.0),
                        blurRadius: 50.0)
                  ],
                ),
              ),
            ),
            FittedBox(
              child: Container(
                margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
                decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(10.0),
                        topRight: Radius.circular(10.0)),
                    boxShadow: [
                      BoxShadow(
                          color:widget.themeState ? Color.fromRGBO(155, 155, 155, 0): Colors.grey,
                          offset: Offset(5.0, 5.0),
                          blurRadius: 10.0)
                    ]),
                width: 160,
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.title,
                      maxLines: 8,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: widget.themeState ? Colors.purpleAccent: Colors.black),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    FittedBox(
                      child: Text('\$${widget.price}/-',
                          maxLines: 1,
                          style: TextStyle(
                            fontFamily: 'FF',
                            color: widget.themeState ? Colors.yellowAccent: Colors.red,
                            fontSize: 30.0,
                          )),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text('${widget.productCategoryName}',
                        style: TextStyle(color: widget.themeState ? Colors.orange: Colors.grey, fontSize: 18.0)),
                    SizedBox(
                      height: 20.0,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
