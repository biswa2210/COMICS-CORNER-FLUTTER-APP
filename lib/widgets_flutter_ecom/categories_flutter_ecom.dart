import 'package:flutter/material.dart';
import 'package:flutter_ecom_project/inner_screens_flutter_ecom/catagories_feeds.dart';
class CategoryList extends StatefulWidget {
  final int index;
  CategoryList({Key? key, required this.index}) : super(key: key);

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  List categories=[
    {
      'categoryName': 'Horror',
      'categoryImagesPath': 'assets/images/catagories/horror.png',
    },
    {
      'categoryName': 'Comedy',
      'categoryImagesPath': 'assets/images/catagories/comedy.png',
    },
    {
      'categoryName': 'Humor',
      'categoryImagesPath': 'assets/images/catagories/humor.png',
    },
    {
      'categoryName': 'Thriller',
      'categoryImagesPath': 'assets/images/catagories/thrill.png',
    },
    {
      'categoryName': 'Sci-Fi',
      'categoryImagesPath': 'assets/images/catagories/syfy.png',
    },
    {
      'categoryName': 'Slice of Life',
      'categoryImagesPath': 'assets/images/catagories/sfs.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
          onTap: (){
             Navigator.of(context).pushNamed(CatagoryFeedsScreen.routeName, arguments: '${categories[widget.index]['categoryName']}');

          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                  image: AssetImage(categories[widget.index]['categoryImagesPath']),
                  fit: BoxFit.cover),
            ),
            margin: EdgeInsets.symmetric(horizontal: 10),
            width: 150,
            height: 150,
          ),
        ),
        Positioned(
          bottom: 0,
          left: 10,
          right: 10,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            color: Theme.of(context).backgroundColor,
            child: Text(
              categories[widget.index]['categoryName'],
              style: TextStyle(
                fontFamily: 'MR',
                fontSize: 18,
                color: Theme.of(context).textSelectionColor,
              ),
            ),
          ),
        )
      ],
    );
  }
}
