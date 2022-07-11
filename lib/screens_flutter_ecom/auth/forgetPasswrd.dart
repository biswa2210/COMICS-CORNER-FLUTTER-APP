import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecom_project/globalMethods/service_provide.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:toast/toast.dart';

class ForgetPassword extends StatefulWidget {
  static const routeName="/ForgetPassword";
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {


  String _emailAddress = '';
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  ServiceProvideMethods serviceProvideMethods=new ServiceProvideMethods();

  void _submitForm() async{
    final isValid = _formKey.currentState?.validate();
    FocusScope.of(context).unfocus();
    setState(() {
      isLoading = true;
    });
    _formKey.currentState!.save();
    try{
       await _auth.sendPasswordResetEmail(email: _emailAddress.trim().toLowerCase());
       Toast.show("Reset link is sent to ${_emailAddress}", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM,
       textColor: Colors.black,backgroundColor: Colors.yellowAccent);

    }
    catch(err){
      serviceProvideMethods.ResetLinkSetFailedbyBiswa(err.toString(), context);
      print('Error occured ${err}');
    }finally{
      setState(() {
        isLoading = false;
      });
    }
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 80,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Forget Password',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold
            ),)),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    key: ValueKey('email'),
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        border: const UnderlineInputBorder(),
                        filled: true,
                        prefixIcon: Icon(Icons.email),
                        labelText: 'Email Address',
                        fillColor: Theme.of(context).backgroundColor),
                    onSaved: (value) {
                      _emailAddress = value!;
                    },
                  ),
                ),
              ),
          SizedBox(height:5 ,),
          SizedBox(
            height: 50,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: isLoading ? Align(
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                  color: Colors.red,
                ),
              ):ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<
                          RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          side: BorderSide(
                              color: Colors.grey),

                        ),

                      )),
                  onPressed: _submitForm,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Send Link',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 22),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Feather.send,
                        size: 20,
                      )
                    ],
                  )),
            ),
          )
        ],
      ),
    );
  }
}
