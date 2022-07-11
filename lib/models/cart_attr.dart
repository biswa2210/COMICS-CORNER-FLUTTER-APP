import 'package:flutter/material.dart';
class CartAttr with ChangeNotifier{
  final String id;
  final String productid;
  final String title;
  final int quantity;
  final double price;
  final String imageUrl;
  CartAttr({required this.id,required this.productid,required this.title,required this.quantity,required this.price,required this.imageUrl});
}