import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecom_project/models/product.dart';
import 'package:flutter_ecom_project/provider_flutter_ecom/products_setup.dart';
import 'package:flutter_ecom_project/widgets_flutter_ecom/feeds_product.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
class CatagoryFeedsScreen  extends StatelessWidget {
  static const routeName = '/CatagoriesFeedsPg';


  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<Products>(context,listen: false);
    final catagoryName = ModalRoute.of(context)!.settings.arguments as String;
    final productList=productsProvider.findbyCatagory(catagoryName);

    return Scaffold(
        backgroundColor: Colors.white,
        body: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 240 / 420,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          children: List.generate(productList.length, (index) {
            return ChangeNotifierProvider.value(
              value: productList[index],
              child: Feeds_products(),);
          }),
        ),
    );
  }
}
