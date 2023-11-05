

import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../Constraints.dart';
import '../Registration/registration.dart';
//TextEditingController _Controller=TextEditingController();
bool profile_update=false;


class Profile_page extends StatefulWidget {
  const Profile_page({super.key});


  @override
  State<Profile_page> createState() => _Profile_pageState();
}

class _Profile_pageState extends State<Profile_page> {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          elevation: 0,
          iconTheme: const IconThemeData(
            color: Colors.white,

          ),
          backgroundColor: const Color.fromRGBO(40, 130, 146, 1),
          title: AutoSizeText(
            "My Profile",
            style: GoogleFonts.gfsDidot(
              fontWeight: FontWeight.w700,
              fontSize: size.height * 0.03,
              color: Colors.white,
            ),
          ),
          // actions: [
          //   Container(
          //
          //         height: size.height*0.01,
          //       width: size.height*0.09,
          //       decoration: const BoxDecoration(
          //           color: Colors.white,
          //         borderRadius: BorderRadius.all(Radius.circular(30))
          //       ),
          //       child: IconButton(onPressed: (){},
          //           icon:const Icon(
          //             Icons.edit,
          //           ),
          //       ),
          //   ),
          // ],
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(


            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromRGBO(120, 149, 150, 1),
                    Color.fromRGBO(120, 149, 150, 1),

                         Colors.white,
                    Color.fromRGBO(120, 149, 150, 1),
                    Color.fromRGBO(120, 149, 150, 1),




                  ]

              )
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  child: Column(
                      children: [
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        Stack(
                           children: [
                             Center(
                               child: CircleAvatar(
                                 radius: size.height * 0.07,

                                 backgroundImage: usermodel["Profile_URL"] != null
                                     ? NetworkImage(usermodel["Profile_URL"])
                                     : null,
                                 backgroundColor: Colors.grey,
                                 child: usermodel["Profile_URL"] == null
                                     ? AutoSizeText(
                                   usermodel["Name"].toString().substring(0, 1),
                                   style: GoogleFonts.exo(
                                       fontSize: size.height * 0.05,
                                       fontWeight: FontWeight.w600),
                                 )
                                     : null,
                               ),
                             ),
                             Positioned(
                                 bottom: -5,
                                 left: 220,
                                 child: IconButton(
                                     icon: Icon(Icons.camera_alt_rounded,size:size.height*0.03 ,color: Colors.white,),
                                     onPressed: () async {

                                       ImagePicker imagePicker=ImagePicker();
                                       print(imagePicker);
                                       XFile? file=await imagePicker.pickImage(source: ImageSource.gallery);
                                       print(file?.path);

                                       setState(() {
                                         profile_update=true;
                                       });
                                       // Create reference of Firebase Storage

                                       Reference reference=FirebaseStorage.instance.ref();

                                       // Create Directory into Firebase Storage

                                       Reference image_directory=reference.child("User_profile");


                                       Reference image_folder=image_directory.child("${usermodel["Email"]}");

                                       await image_folder.putFile(File(file!.path)).whenComplete(() async {


                                         String download_url=await image_folder.getDownloadURL();
                                         print("uploaded");
                                         print(download_url);
                                         await FirebaseFirestore.instance.collection("Students").doc(FirebaseAuth.instance.currentUser?.email).update({
                                           "Profile_URL":download_url,
                                         }).whenComplete(() async {
                                           await FirebaseFirestore.instance.collection("Students").doc(FirebaseAuth.instance.currentUser!.email).get().then((value){

                                             setState(() {
                                               usermodel=value.data()!;
                                             });
                                           }).whenComplete(() {
                                             setState(() {
                                               profile_update=false;
                                             });
                                           });

                                         });
                                         setState(() {
                                           profile_update=false;
                                         });
                                       },
                                       );}))
                           ],
                        ),
                        Padding(
                          padding: EdgeInsets.all(size.height * 0.022),
                          child: AutoSizeText(
                            usermodel["Name"],
                            style: GoogleFonts.exo(
                                fontSize: size.height * 0.023,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(size.height * 0.001),
                          child: AutoSizeText(
                            usermodel["Email"],
                            style: GoogleFonts.exo(
                                fontSize: size.height * 0.023,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        SizedBox(
                      height: size.height * 0.022),
                      ]),
                ),
                Container(
                  padding: EdgeInsets.all(size.height * 0.01),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // TextField(
                      //     decoration: const InputDecoration(border: UnderlineInputBorder()),
                      //     autofocus: true,
                      //     keyboardType: TextInputType.multiline,
                      //     maxLines: null,
                      //     controller: _Controller
                      // ),
                      SizedBox(
                        height: size.height * 0.13,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(size.height * 0.01),
                              child: AutoSizeText("University :",
                                  style: GoogleFonts.exo(
                                    fontSize: size.height * 0.02,
                                    fontWeight: FontWeight.w400,
                                  )),
                            ),
                            Padding(
                              padding: EdgeInsets.all(size.height * 0.01),
                              child: AutoSizeText(
                                usermodel["University"],
                                style: GoogleFonts.exo(
                                    fontSize: size.height * 0.023,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            Divider(
                              color: Colors.black,
                              thickness: size.height * 0.0014,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.13,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(size.height * 0.01),
                              child: AutoSizeText("College :",
                                  style: GoogleFonts.exo(
                                    fontSize: size.height * 0.02,
                                    fontWeight: FontWeight.w400,
                                  )),
                            ),
                            Padding(
                              padding: EdgeInsets.all(size.height * 0.01),
                              child: AutoSizeText(
                                usermodel["College"],
                                style: GoogleFonts.exo(
                                    fontSize: size.height * 0.023,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            Divider(
                              color: Colors.black,
                              thickness: size.height * 0.0014,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.13,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(size.height * 0.01),
                              child: AutoSizeText("Branch",
                                  style: GoogleFonts.exo(
                                    fontSize: size.height * 0.02,
                                    fontWeight: FontWeight.w400,
                                  )),
                            ),
                            Padding(
                              padding: EdgeInsets.all(size.height * 0.01),
                              child: AutoSizeText(
                                usermodel["Branch"],
                                style: GoogleFonts.exo(
                                    fontSize: size.height * 0.023,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            Divider(
                              color: Colors.black,
                              thickness: size.height * 0.0014,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.13,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(size.height * 0.01),
                              child: AutoSizeText("Year ",
                                  style: GoogleFonts.exo(
                                    fontSize: size.height * 0.02,
                                    fontWeight: FontWeight.w400,
                                  )),
                            ),
                            Padding(
                              padding: EdgeInsets.all(size.height * 0.01),
                              child: AutoSizeText(
                                usermodel["Year"],
                                style: GoogleFonts.exo(
                                    fontSize: size.height * 0.023,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            Divider(
                              color: Colors.black,
                              thickness: size.height * 0.0014,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.13,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(size.height * 0.01),
                              child: AutoSizeText("Subjects ",
                                  style: GoogleFonts.exo(
                                    fontSize: size.height * 0.02,
                                    fontWeight: FontWeight.w400,
                                  )),
                            ),
                            Padding(
                              padding: EdgeInsets.all(size.height * 0.01),
                              child: AutoSizeText(
                                usermodel["Subject"][0],
                                style: GoogleFonts.exo(
                                    fontSize: size.height * 0.023,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            Divider(
                              color: Colors.black,
                              thickness: size.height * 0.0014,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.only(right: size.height * 0.04),
          width: size.width,
          height: size.height * 0.08,
          decoration: const BoxDecoration(
              color:  Color.fromRGBO(40, 130, 146, 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                width: size.width * 0.2,
                height: size.height * 0.05,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const StudentDetails(),
                          ));
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      backgroundColor: Colors.white,
                    ),
                    child: AutoSizeText(
                      "Edit",
                      style: GoogleFonts.exo(
                          fontSize: 18, fontWeight: FontWeight.w600,
                      color: const Color.fromRGBO(40, 130, 146, 1),),

                    )),
              ),
            ],
          ),
        ));
  }

}
