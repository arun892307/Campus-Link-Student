import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:campus_link_student/Registration/signUp.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_notifications/flutter_inapp_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import '/Constraints.dart';
import '../Screens/Main_page.dart';
import 'forgot_password.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {



  bool hide =true;
  //final _key = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final _textStyle = GoogleFonts.alegreya(fontSize: 28, fontWeight: FontWeight.w900,color: Colors.white54,
    shadows: <Shadow>[
      const Shadow(
        offset: Offset(1, 1),
        color: Colors.black,
      ),
    ],
  );
  String errorString="";

  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color.fromRGBO(86, 149, 178, 1),
                // Color.fromRGBO(86, 149, 178, 1),
                const Color.fromRGBO(68, 174, 218, 1),
                //Color.fromRGBO(118, 78, 232, 1),
                Colors.deepPurple.shade300
              ],
            ),
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width * 0.04,
                0,
                MediaQuery.of(context).size.width * 0.04,
                0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                SizedBox(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.07,
                ),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Regcon,
                    border: Border.all(color: Colors.black),
                    boxShadow: const [
                      BoxShadow(
                          blurRadius: 60,
                          blurStyle: BlurStyle.outer,
                          color: Colors.black54,
                          offset: Offset(1, 1)
                      )
                    ],
                    image: const DecorationImage(
                        image: AssetImage("assets/icon/icon.png")),
                  ),
                  height: MediaQuery
                      .of(context)
                      .size
                      .width * 0.3,
                ),
                SizedBox(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.06,
                ),
                AnimatedTextKit(
                  animatedTexts: [
                    WavyAnimatedText('Welcome To Campus Link',

                        textStyle: _textStyle
                    ),

                  ],
                  repeatForever: true,
                ),
                SizedBox(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.07,
                ),

                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                    border: Border.all(color: Colors.black,),
                    boxShadow: const [
                      BoxShadow(
                          blurRadius: 20,
                          blurStyle: BlurStyle.outer,
                          color: Colors.black54,
                          offset: Offset(1, 1)
                      )
                    ],
                  ),
                  child: TextFormField(

                      controller: _email,
                      obscureText: false,
                      enableSuggestions: true,
                      autocorrect: true,
                      cursorColor: Colors.white,
                      style: TextStyle(color: Colors.white.withOpacity(0.9)),
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: (){
                              setState(() {
                                _email.clear();
                              });
                            },
                            icon: const Icon(
                              Icons.clear_outlined,
                              color: Colors.white,
                            ),
                          ),
                          prefixIcon: const Icon(
                            Icons.person_outline,
                            color: Colors.white,
                          ),
                          label: const Text("Enter Email"),
                          labelStyle: TextStyle(
                              color: Colors.white.withOpacity(0.9)),
                          filled: true,
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          fillColor: Colors.black26.withOpacity(0.7),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: const BorderSide(
                                  width: 0, style: BorderStyle.none)
                          )
                      ),
                      keyboardType: TextInputType.emailAddress),
                ),
                SizedBox(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.03,
                ),

                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                    border: Border.all(color: Colors.black,),
                    boxShadow: const [
                      BoxShadow(
                          blurRadius: 20,
                          blurStyle: BlurStyle.outer,
                          color: Colors.black54,
                          offset: Offset(1, 1)
                      )
                    ],
                  ),
                  child: TextFormField(

                      controller: _password,
                      obscureText: hide,
                      enableSuggestions: false,
                      autocorrect: false,
                      cursorColor: Colors.white,
                      style: TextStyle(color: Colors.white.withOpacity(0.9)),
                      decoration: InputDecoration(
                          suffixIcon: hide
                              ?
                          IconButton(onPressed: (){
                            setState(() {
                              hide=!hide;
                            });
                          }, icon: const Icon(
                            Icons.visibility_off_outlined,
                            color: Colors.white,
                          ))
                              :
                          IconButton(onPressed: (){
                            setState(() {
                              hide=!hide;
                            });
                          }, icon: const Icon(
                            Icons.visibility_outlined,
                            color: Colors.white,
                          )),

                          prefixIcon: const Icon(
                            Icons.lock_outline,
                            color: Colors.white,
                          ),
                          label: const Text("Enter Password"),
                          labelStyle: TextStyle(
                              color: Colors.white.withOpacity(0.9)),
                          filled: true,
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          fillColor: Colors.black26.withOpacity(0.7),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: const BorderSide(
                                  width: 0, style: BorderStyle.none)
                          )
                      ),
                      keyboardType: TextInputType.visiblePassword),
                ),
                SizedBox(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.03
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height*0.07,
                  decoration: BoxDecoration(
                      gradient:const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.blue, Colors.purpleAccent],
                      ),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.black54,width: 2)
                  ),
                  child: ElevatedButton(
                    onPressed: () async{
                      final ref=await FirebaseFirestore.instance.collection("Student_record").doc("Email").get();
                      final student_record=ref.data()!["Email"];
                      if( student_record!=null && student_record.contains(_email.text.trim())) {

                        String test = await signin(
                            _email.text.trim(), _password.text.trim());
                        if (!mounted) return;
                        if (test == "1") {
                          Navigator.pushReplacement(
                            context,
                            PageTransition(
                              child: const MainPage(),
                              type: PageTransitionType.rightToLeftJoined,
                              duration: const Duration(milliseconds: 400),
                              alignment: Alignment.bottomCenter,
                              childCurrent: const SignInScreen(),
                            ),
                          );
                          final token = await FirebaseMessaging.instance.getToken();
                          String? userId = FirebaseAuth.instance.currentUser?.email;
                          final userdoc= await FirebaseFirestore.instance.collection("Students").doc(userId).get();



                          List<dynamic> channels= userdoc.data()?["Message_channels"] ?? [];

                          for(var channel in channels){
                            await FirebaseFirestore.instance.collection("Messages")
                                .doc(channel).update(
                                {
                                  "${userdoc["Email"].toString().split("@")[0]}.Token" : FieldValue.arrayUnion([token])
                                }
                            );
                          }


                        }
                        else {
                          InAppNotifications.instance
                            ..titleFontSize = 14.0
                            ..descriptionFontSize = 14.0
                            ..textColor = Colors.black
                            ..backgroundColor = const Color.fromRGBO(190, 190, 190, 1)
                            ..shadow = true
                            ..animationStyle = InAppNotificationsAnimationStyle
                                .scale;
                          InAppNotifications.show(
                              title: 'Failed',
                              duration: const Duration(seconds: 5),
                              description: test,
                              leading: AutoSizeText("!",style: GoogleFonts.gfsDidot(
                                  color: Colors.red,
                                  fontSize: size.height*0.06,
                                  fontWeight: FontWeight.w900
                              ),)
                          );
                        }
                      }
                      else{
                        InAppNotifications.instance
                          ..titleFontSize = 22.0
                          ..descriptionFontSize = 16.0
                          ..textColor = Colors.black
                          ..backgroundColor = const Color.fromRGBO(190, 190, 190, 1)
                          ..shadow = true
                          ..animationStyle = InAppNotificationsAnimationStyle.scale;
                        InAppNotifications.show(
                            title: 'Failed',
                            duration: const Duration(seconds: 5),
                            description: "No such account found",
                            leading: AutoSizeText("!",style: GoogleFonts.gfsDidot(
                                color: Colors.red,
                                fontSize: size.height*0.06,
                                fontWeight: FontWeight.w900
                            ),)
                        );

                      }

                    },



                    style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.black54,
                        elevation: 30

                    ),
                    child: const Text("LOG IN", style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                    ),),
                  ),
                ),
                SizedBox(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.03
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(context,PageTransition(child: const ForgotPassword(), type: PageTransitionType.rightToLeft,duration:const Duration(milliseconds: 350)));
                      },
                      child: const Text("Forgot Password ?", style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          shadows: [
                            Shadow(
                                blurRadius: 30,
                                offset: Offset(3, 3),
                                color: Colors.black54
                            )
                          ]
                      )

                      ),
                    )
                  ],
                ),

                signUpOption(),

              ],
            ),
          ),
        )
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have account?", style: TextStyle(fontWeight: FontWeight.w400,
          color: Colors.black,)
          ,),
        TextButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              PageTransition(
                child: const SignUpScreen(),
                type: PageTransitionType.rightToLeftJoined,
                duration: const Duration(milliseconds: 350),
                childCurrent: const SignInScreen(),
              ),
            );
          },
          child: const Text("Sign Up", style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                    blurRadius: 30,
                    offset: Offset(3, 3),
                    color: Colors.black54
                )
              ]
          )

          ),
        )
      ],
    );
  }

  Future<String> signin(String email, String password) async {
    try {
      await  FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      return "1";
    } on FirebaseAuthException catch (e) {
      print(e.code);
      return e.toString().split(']')[1].trim();
    }
  }
}
