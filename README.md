# COMIC CORNER E-COMMERCE APPLICATION :star_struck: :email: :iphone: :book:

[![Generic badge](https://img.shields.io/badge/advance-Flutter-red)](https://shields.io/) [![Generic badge](https://img.shields.io/badge/advance-Dart-green)](https://shields.io/) [![Generic badge](https://img.shields.io/badge/Dart-Math-yellow)](https://shields.io/) [![Generic badge](https://img.shields.io/badge/android-ios-yellowgreen)](https://shields.io/) [![Generic badge](https://img.shields.io/badge/Material-UI-blue)](https://shields.io/) [![Generic badge](https://img.shields.io/badge/custom-widgets-orange)](https://shields.io/) [![Generic badge](https://img.shields.io/badge/sdk-%22%3E%3D2.7.0%20%3C3.0.0%22-purple)](https://shields.io/) [![Generic badge](https://img.shields.io/badge/cupertino__icons-%5E0.1.3-maroon)](https://shields.io/) [![Generic badge](https://img.shields.io/badge/splashscreen-%5E1.2.0-blueviolet)](https://shields.io/)

<details>
   <summary> Click to read some points about Comic Corner :point_down: </summary>

 - [x] firebase_auth:
 - [x] firebase_database:
 - [x] toast:
 - [x] delayed_display:
 - [x] connectivity:
 - [x] google_sign_in:
 - [x] outline_material_icons:
 - [x] carousel_pro:
 - [x] firebase_storage:
 - [x] image_picker:
 - [x] cloud_firestore:
 - [x] transparent_image:

</details>

***This new Flutter E-Commerce Application named 'COMIC CORNER' is created by Biswarup Bhattacharjee, student of BTECH, in University of Engineering and Management, Kolkata.***

**Email Id: bbiswa471@gmail.com.** 

**Contact No: 916290272740.** 

<p align="left">
<a href="https://www.facebook.com/profile.php?id=100070395300810" target="blank"><img align="center" src="https://cdn.jsdelivr.net/npm/simple-icons@3.0.1/icons/facebook.svg" alt="biswa2210" height="30" width="40" /></a>
<a href="https://instagram.com/biswarup2210" target="blank"><img align="center" src="https://cdn.jsdelivr.net/npm/simple-icons@3.0.1/icons/instagram.svg" alt="" height="30" width="40" /></a>
<a href="https://github.com/biswa2210/biswa2210" target="blank"><img align="center" src="https://cdn.jsdelivr.net/npm/simple-icons@3.0.1/icons/github.svg" alt="" height="30" width="40" /></a>
</p>

## About COMIC CORNER App :point_down: 

<div align="justified">
 
This comic corner E-Commerce android or iOS application is for comic lovers. It's a platform to explore well known 50 comics of 5 established brands and different genres. Here user can sign in with google account and phone number. User can register using full name, email id and password. He has to do it just for the first time. After that user can logout. After that he has to login using that email and password. Here is an extra security of otp verification. If user forgets the password he can use forget password. After that he will be provided a link in email. There he can reset new password. Here comics can be explored in different categories like Horror, Comedy, Humor, Thriller, Slice of Life, Sci Fi etc. User can also explore comics by different poular brands like Marvel, DC, Dynamite Entertainment, Dark Horse and Narayan Debnath. For each comic here are details like name, brand, description, quantity, category, popularity and an image of the comic. There are options like add to cart, buy now and add to Wishlist. User can increase or decrease quantity and easily buy the product. There are two payment options pay via card and pay on delivery. There is a search engine in the app so that user can easily find out whatever needed. If the user is admin user he or she will be able to upload a new comic. Here title, description, brand, category, quantity, price these details should be added along with a picture of that comic either taken from camera or internal storage of phone. The application have three different theme yellow, purple and dark. For more details watch the demo video of this app.

## COMIC CORNER DEMO VIDEO: :point_right: <a href="https://www.youtube.com/watch?v=ogmO98FlO-k&list=PL0lbDlMJ1h4hiexZec5cbgw8a3F8dE1HH&index=12">Click here to watch</a>

## FLUTTER PLAYLIST: :point_right: <a href="https://www.youtube.com/playlist?list=PL0lbDlMJ1h4hiexZec5cbgw8a3F8dE1HH">Click here to watch</a>

## COMIC CORNER APP DOWNLOAD LINK : :point_right: <a href="https://drive.google.com/file/d/16yDRVa7zAQaQPI7maGc7us4-qEvOGAwD/view" download>Click here to download</a>

</div>

## Purpose Of Making This App :point_down:

<div align="justified">

I have made this app for comic-lovers and those who want to explore comics for any purpose. Here I have gathered many trending comics with all their details. Using this app will save time of searching comics in different websites. This is also very easy to use. 

</div>

## Folder Structure :point_down:
```bash
COMIC-CORNER-FLUTTER-APP
       ????????? lib 
             ????????? consts_flutter_ecom
             |     ????????? theme_data.dart
             ????????? globalmethods
             |     ????????? PaymentIntegration.dart
             |     ????????? service_provide.dart
             ????????? inner_screens_flutter_ecom
             |     ????????? brands_navigation_railcopy_flutter_ecom.dart
             |     ????????? brands_rail_widget_flutter_ecom.dart
             |     ????????? categories_feeds.dart           
             |     ????????? product_details_flutter_ecom.dart
             ????????? models
             |     ????????? cart_attr.dart
             |     ????????? fav_attribute_biswa2210.dart
             |     ????????? order_attr.dart
             |     ????????? product.dart
             ????????? Provider_flutter_ecom
             |     ????????? darkTheme_setup.dart
             |     ????????? fav_provider_biswa2210.dart
             |     ????????? orders_provider.dart
             |     ????????? products_setup.dart
             |     ????????? Provider_for_cart.dart
             ????????? screens_flutter_ecom
             |     ????????? auth
             |     |    ????????? forgetPassword.dart
             |     |    ????????? login.dart
             |     |    ????????? signup.dart
             |     ????????? Cart
             |     |    ????????? CartFullpage.dart
             |     |    ????????? CartPgScreen.dart
             |     |    ????????? emptyCart.dart
             |     ????????? flutter_ecom_orders
             |     |    ????????? order.dart
             |     |    ????????? order_empty.dart
             |     |    ????????? order_full.dart
             |     ????????? wishlist
             |     |    ????????? Wishlist_flutter_ecom.dart
             |     |    ????????? Wishlist_empty_screen(flutter_ecom).dart
             |     |    ????????? Wishlist_full_flutter_ecom.dart
             |     ????????? Bottombar.dart
             |     ????????? SearchPgScreen.dart
             |     ????????? VerificationScreen.dart
             |     ????????? app_properties.dart
             |     ????????? feedScreen.dart
             |     ????????? feeds_dialogue_fecom.dart
             |     ????????? homePgScreen.dart
             |     ????????? landing_page.dart
             |     ????????? main_screen.dart
             |     ????????? PhoneVerificationPg.dart
             |     ????????? upload_product_from.dart
             |     ????????? user_details_pg.dart
             |     ????????? user_state.dart
             ????????? sharedPrefs
             |     ????????? sharedprefs_darkTheme_set.dart
             ????????? widgets_flutter_ecom
             |     ????????? backlayer_flutter_ecom.dart
             |     ????????? categories_flutter_ecom.dart
             |     ????????? categories_flutter_ecom.dart
             |     ????????? feeds_product.dart
             |     ????????? popular_products.dart
             |     ????????? searchby_header.dart
             ????????? main.dart         
 ```                      

## Making Notes Of Cool Cab App :point_down:

<div align="justified">

I have used [FLUTTER](https://flutter.dev/?gclid=Cj0KCQjw38-DBhDpARIsADJ3kjliHdMH2hA97bBGqJtW5ORUUksCxpZ8cnrSWaH__HevGftAmP8AmvIaAhNlEALw_wcB&gclsrc=aw.ds) and [Dart](https://dart.dev/).
I have used [FIREBASE](https://firebase.google.com/) for database and authentication as register, google sign up, login, logout and forget password system.

</div>

## Getting Started with Flutter :point_down: 

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Screenshots Of Cool-Cab:point_down: 

<div align="center">
 
<a href="pics/c1.png"><img src="pics/c1.png" width="250" height= "450"></a> <a href="pics/c2.png"><img src="pics/c2.png" width="250" height= "450"></a> <a href="pics/c3.png"><img src="pics/c3.png" width="250" height= "450"></a>
   
<a href="pics/c4.png"><img src="pics/c4.png" width="250" height= "450"></a> <a href="pics/c5.png"><img src="pics/c5.png" width="250" height= "450"></a> <a href="pics/c6.png"><img src="pics/c6.png" width="250" height= "450"></a>
   
<a href="pics/c7.png"><img src="pics/c7.png" width="250" height= "450"></a> <a href="pics/c8.png"><img src="pics/c8.png" width="250" height= "450"></a> <a href="pics/c9.png"><img src="pics/c9.png" width="250" height= "450"></a>
   
<a href="pics/c10.png"><img src="pics/c10.png" width="250" height= "450"></a> <a href="pics/c11.png"><img src="pics/c11.png" width="250" height= "450"></a> <a href="pics/c12.png"><img src="pics/c12.png" width="250" height= "450"></a>
   
<a href="pics/c13.png"><img src="pics/c13.png" width="250" height= "450"></a> <a href="pics/c14.png"><img src="pics/c14.png" width="250" height= "450"></a> <a href="pics/c15.png"><img src="pics/c15.png" width="250" height= "450"></a>
   
<a href="pics/c16.png"><img src="pics/c16.png" width="250" height= "450"></a> <a href="pics/c17.png"><img src="pics/c17.png" width="250" height= "450"></a> <a href="pics/c18.png"><img src="pics/c18.png" width="250" height= "450"></a>
   
<a href="pics/c19.png"><img src="pics/c19.png" width="250" height= "450"></a> <a href="pics/c20.png"><img src="pics/c20.png" width="250" height= "450"></a> <a href="pics/c21.png"><img src="pics/c21.png" width="250" height= "450"></a>
   
<a href="pics/c22.png"><img src="pics/c22.png" width="250" height= "450"></a> <a href="pics/c23.png"><img src="pics/c23.png" width="250" height= "450"></a> <a href="pics/c24.png"><img src="pics/c24.png" width="250" height= "450"></a>
 

</div>

