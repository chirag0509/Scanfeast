import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:scan_feast/registerPage.dart';
import 'package:scan_feast/routes.dart';
import 'package:scan_feast/welcomePage.dart';

import 'forgot.dart';

class loginPage extends StatefulWidget {
  const loginPage({Key? key}) : super(key: key);

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  final _formKey=GlobalKey<FormState>();
  final TextEditingController emailController=new TextEditingController();
  final TextEditingController passwordController=new TextEditingController();
  final _auth=FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0 ,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>welcomePage()));
          },
          icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
        ),
      ),
      body:
      Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(height:100,),
            Expanded(child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    const Text("Login",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text("Login to your Account",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.bold
                      ),
                    )
                  ],
                ),
                SizedBox(height: 30,),
                Padding(padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Form(
                    key: _formKey,
                    child:Column(
                    children: <Widget>[
                      inputFile(
                        label: "Email",
                        picon : Icon(Icons.email_rounded),
                        controller: emailController,
                        validator:(value){
                          if(value!.isEmpty)
                          {
                            return ("Please Enter Your Email");
                          }
                          if(!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value))
                          {
                            return ("Please Enter a Valid Email");
                          }
                          return null;
                        },
                        onSaved: (value){
                          emailController.text=value!;
                        }
                      ),
                      SizedBox(height: 20,),
                      inputFile(
                          label: "Password",
                          picon : Icon(Icons.lock),
                          controller: passwordController,
                          validator:(value){
                            RegExp regex=new RegExp(r'^.{6,}$');
                            if(value!.isEmpty)
                            {
                              return ("Password is requried for login");
                            }
                            if(!regex.hasMatch(value))
                            {
                              return ("Please enter a valid password(Min. 6 character)");
                            }
                            return null;
                          },
                          onSaved: (value){
                            passwordController.text=value!;
                          },
                          obscureText: true,
                      ),
                    ],
                  ),
                ),
                ),
                SizedBox(height: 10,),
                Column(
                  children: <Widget>[
                   InkWell(
                     onTap: (){
                       Navigator.push(context, MaterialPageRoute(builder: (context)=>forgot()));
                     },
                     child: Container(
                       margin: EdgeInsets.only(right: 50),
                       alignment: Alignment.centerRight,
                       child: const Text("Forgot Password ?",style: TextStyle(color: Colors.black87, fontSize: 17, fontWeight: FontWeight.w400),
                       ),
                     ),
                   )
                  ],
                ),
                SizedBox(height: 30,),
                Padding(padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Container(
                    padding: EdgeInsets.only(top: 3,left: 3,right: 3,bottom: 3),
                    decoration:
                        BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: const Border(
                            bottom: BorderSide(color: Colors.black),
                              top: BorderSide(color: Colors.black),
                              left: BorderSide(color: Colors.black),
                              right: BorderSide(color: Colors.black),
                          ),
                        ),

                    child: MaterialButton(
                      minWidth: double.infinity,
                      height: 55,
                      onPressed: (){
                        signIn(emailController.text, passwordController.text);
                      },
                      color: Colors.orange,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: Colors.white
                        ),
                      ),
                    ),
                  ),
                ),
                // const Text("OR",style:
                // TextStyle(
                //     color: Colors.grey,
                //   fontWeight: FontWeight.bold,
                //   fontSize: 20,
                // ),
                // ),
                // Wrap(
                //   children: List<Widget>.generate(2,
                //           (index){
                //         return Padding(
                //           padding: const EdgeInsets.all(10.0),
                //           child: CircleAvatar(
                //             radius: 25,
                //             backgroundColor: Colors.white,
                //             backgroundImage: AssetImage(
                //                 "img/"+images[index]
                //             ),
                //           ),
                //         );
                //       }
                //   ),
                // ),
                SizedBox(height: 45,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text("Don't have an account?",style: TextStyle(
                        color: Colors.black54,
                        fontSize: 18
                    ),),
                    InkWell(
                      child:
                      const Text(" Sign up",style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 19,
                          color: Colors.orange,
                      ),
                      ),
                      onTap:(){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>registerPage()));
                      },
                    )
                  ],
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }
  void signIn(String email,String password) async
  {
    if(_formKey.currentState!.validate())
    {
      await _auth
          .signInWithEmailAndPassword(email: email,password:password)
          .then((uid) => {
            Fluttertoast.showToast(msg: "Login Successful :)"),
            // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>home())),
           Get.offAllNamed(MyRoutes.home),
          }).catchError((e){
            Fluttertoast.showToast(msg: e!.message);
          }
      );
    }
  } 
}
Widget inputFile({label,picon,controller,validator,onSaved,obscureText=false})
{
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Container(
        child: TextFormField(
          autofocus: false,
          textInputAction: TextInputAction.next,
          controller: controller,
          obscureText: obscureText,
          validator: validator,
          onSaved: onSaved,
          style: TextStyle(
            fontSize: 20,
          ),
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: picon,
            contentPadding: EdgeInsets.symmetric(vertical: 20,horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(20),
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(20)),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.orange, width: 1),
                borderRadius: BorderRadius.circular(20)),
          )
        )
      ),
    ],
  );
}
