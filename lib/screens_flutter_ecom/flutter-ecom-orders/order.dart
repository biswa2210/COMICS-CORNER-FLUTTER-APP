
import 'package:flutter/material.dart';
import 'package:flutter_ecom_project/globalMethods/service_provide.dart';
import 'package:flutter_ecom_project/provider_flutter_ecom/orders_providers.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

import '../../globalMethods/paymentIntegration.dart';
import '../../provider_flutter_ecom/darkTheme_setup.dart';
import 'order_empty.dart';
import 'order_full.dart';

class OrderScreen extends StatefulWidget {
  //To be known 1) the amount must be an integer 2) the amount must not be double 3) the minimum amount should be less than 0.5 $
  static const routeName = '/OrderScreen';

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    StripeService.init();
  }

  void payWithCard({required int amount}) async {
    ProgressDialog dialog = ProgressDialog(context);
    dialog.style(message: 'Please wait...');
    await dialog.show();
    var response = await StripeService.payWithNewCard(
        currency: 'USD', amount: amount.toString());
    await dialog.hide();
    print('response : ${response.message}');
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(response.message),
      duration: Duration(milliseconds: response.success == true ? 1200 : 3000),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final themeChange =  Provider.of<DarkThemeSetup>(context);
    ServiceProvideMethods globalMethods = ServiceProvideMethods();
    final orderProvider = Provider.of<OrdersProvider>(context);
    // final cartProvider = Provider.of<CartProvider>(context);
    // print('orderProvider.getOrders length ${orderProvider.getOrders.length}');
    return FutureBuilder(
        future: orderProvider.fetchOrders(),
        builder: (context, snapshot) {
          return orderProvider.getOrders.isEmpty
              ? Scaffold(body: OrderEmpty())
              : Scaffold(
              appBar: AppBar(
                foregroundColor: themeChange.darkTheme?Colors.white: Colors.black,
                backgroundColor: Theme.of(context).backgroundColor,
                title: Text('Orders (${orderProvider.getOrders.length})',style: TextStyle(color:themeChange.darkTheme?Colors.white: Colors.black,),),
                actions: [
                  IconButton(
                    onPressed: () {
                      // globalMethods.showDialogg(
                      //     'Clear cart!',
                      //     'Your cart will be cleared!',
                      //     () => cartProvider.clearCart(),
                      //     context);
                    },
                    icon: Icon(FontAwesome5.trash_alt,color:themeChange.darkTheme?Colors.white: Colors.black,),
                  )
                ],
              ),
              body: Container(
                margin: EdgeInsets.only(bottom: 60),
                child: ListView.builder(
                    itemCount: orderProvider.getOrders.length,
                    itemBuilder: (BuildContext ctx, int index) {
                      return ChangeNotifierProvider.value(
                          value: orderProvider.getOrders[index],
                          child: OrderFull());
                    }),
              ));
        });
  }
}
