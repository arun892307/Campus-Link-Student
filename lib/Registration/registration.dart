import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:campus_link_student/Registration/database.dart';
import 'package:campus_link_student/Screens/loadingscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_notifications/flutter_inapp_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:searchfield/searchfield.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../Constraints.dart';
import 'Login.dart';

class StudentDetails extends StatefulWidget {
  const StudentDetails({Key? key}) : super(key: key);

  @override
  State<StudentDetails> createState() => _StudentDetailsState();
}

class _StudentDetailsState extends State<StudentDetails> {
  final TextEditingController rollno = TextEditingController();

  final TextEditingController universityController = TextEditingController();
  final FocusNode univf = FocusNode();
  List<dynamic> university = [];

  final TextEditingController collegeController = TextEditingController();
  final FocusNode colf = FocusNode();
  List<dynamic> college = [];
  final TextEditingController courseController = TextEditingController();
  final FocusNode corsef = FocusNode();
  List<dynamic> course = [];

  final TextEditingController yearController = TextEditingController();
  final FocusNode yearf = FocusNode();
  List<String> year = ['1', '2', '3', '4', '5'];

  final TextEditingController branchController = TextEditingController();
  final FocusNode branchf = FocusNode();
  List<dynamic> branch = [];

  final TextEditingController sectionController = TextEditingController();
  final FocusNode sectionf = FocusNode();
  List<String> section = ['A', 'B', 'C', 'D', 'E'];

  List<TextEditingController> subjectlist = [TextEditingController()];
  List<FocusNode> subjectf = [FocusNode()];
  List<dynamic> subjects = [];

  List<String> subject = [];


  @override
  void initState() {
    // TODO: implement initState
    fetchuniversity();
    super.initState();
  }

//ar firebaseDB= FirebaseFirstore.instance.collection("").doc("").Snapshots();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height * 1,
        width: size.width * 1,
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
          scrollDirection: Axis.vertical,
          child: Form(
            child: Column(
              children: [
                SizedBox(height: size.height * 0.03),
                AnimatedTextKit(
                  animatedTexts: [
                    WavyAnimatedText(
                      "Please Fill Your Details",
                      textStyle: GoogleFonts.openSans(
                        color: Colors.white54,
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                        shadows: [
                          const Shadow(
                            color: Colors.black,
                            offset: Offset(1, 1),
                            blurRadius: 5,
                          ),
                        ],
                      ),
                    ),
                  ],
                  repeatForever: true,
                  isRepeatingAnimation: true,
                ),
                SizedBox(height: size.height * 0.02),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(

                    controller: rollno,
                    decoration: InputDecoration(
                        fillColor: Colors.black26.withOpacity(0.7),
                        filled: true,
                        hintText: "Enter Roll No.",
                        hintStyle: const TextStyle(color: Colors.grey),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            width: 3,
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        focusColor: Colors.black,
                        disabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            width: 3,
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            width: 3,
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        )),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SearchField(
                    controller: universityController,
                    focusNode: univf,
                    suggestionItemDecoration: SuggestionDecoration(),
                    key: const Key("Search key"),
                    suggestions:
                    university.map((e) => SearchFieldListItem(e)).toList(),
                    searchStyle: GoogleFonts.openSans(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w800),
                    suggestionStyle: GoogleFonts.openSans(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                    marginColor: Colors.black,
                    suggestionsDecoration: SuggestionDecoration(
                        color: const Color.fromRGBO(40, 130, 146, 1),
                        //shape: BoxShape.rectangle,
                        padding: const EdgeInsets.all(10),
                        border: Border.all(width: 2, color: Colors.black),
                        borderRadius: BorderRadius.circular(0)),
                    searchInputDecoration: InputDecoration(
                        hintText: "University",
                        fillColor: Colors.black26.withOpacity(0.7),
                        filled: true,
                        hintStyle: GoogleFonts.openSans(
                            color: Colors.grey,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            width: 3,
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        focusColor: Colors.black,
                        disabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            width: 3,
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            width: 3,
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        )),
                    onSuggestionTap: (value) {
                      print(value.searchKey);
                      print(universityController.text.toString());

                      setState(() {
                        fetchcollege(universityController.text.toString());
                      });
                      FocusScope.of(context).requestFocus(colf);
                    },
                    enabled: true,
                    hint: "University",
                    itemHeight: 50,
                    maxSuggestionsInViewPort: 3,
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SearchField(
                    controller: collegeController,
                    focusNode: colf,
                    suggestionItemDecoration: SuggestionDecoration(),
                    key: const Key("Search key"),
                    suggestions:
                    college.map((e) => SearchFieldListItem(e)).toList(),
                    searchStyle: GoogleFonts.openSans(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w800),
                    suggestionStyle: GoogleFonts.openSans(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                    marginColor: Colors.white,
                    suggestionsDecoration: SuggestionDecoration(
                        color: const Color.fromRGBO(40, 130, 146, 1),
                        //shape: BoxShape.rectangle,
                        padding: const EdgeInsets.all(10),
                        border: Border.all(width: 2, color: Colors.black),
                        borderRadius: BorderRadius.circular(0)),
                    searchInputDecoration: InputDecoration(
                        hintText: "College",
                        fillColor: Colors.black26.withOpacity(0.7),
                        filled: true,
                        hintStyle: GoogleFonts.openSans(
                            color: Colors.grey,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            width: 3,
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        focusColor: Colors.black,
                        disabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            width: 3,
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            width: 3,
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        )),
                    onSuggestionTap: (value) {
                      print(value.searchKey);
                      print(courseController.text.toString());
                      setState(() {
                        fetchcourse(collegeController.text.toString());
                      });

                      FocusScope.of(context).requestFocus(corsef);
                    },
                    enabled: true,
                    hint: "College",
                    itemHeight: 50,
                    maxSuggestionsInViewPort: 3,
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SearchField(
                    controller: courseController,
                    focusNode: corsef,
                    suggestionItemDecoration: SuggestionDecoration(),
                    key: const Key("Search key"),
                    suggestions:
                    course.map((e) => SearchFieldListItem(e)).toList(),
                    searchStyle: GoogleFonts.openSans(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w800),
                    suggestionStyle: GoogleFonts.openSans(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                    marginColor: Colors.white,
                    suggestionsDecoration: SuggestionDecoration(
                        color: const Color.fromRGBO(40, 130, 146, 1),
                        //shape: BoxShape.rectangle,
                        padding: const EdgeInsets.all(10),
                        border: Border.all(width: 2, color: Colors.black),
                        borderRadius: BorderRadius.circular(0)),
                    searchInputDecoration: InputDecoration(
                        hintText: "Course",
                        fillColor: Colors.black26.withOpacity(0.7),
                        filled: true,
                        hintStyle: GoogleFonts.openSans(
                            color: Colors.grey,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            width: 3,
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        focusColor: Colors.black,
                        disabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            width: 3,
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            width: 3,
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        )),
                    onSuggestionTap: (value) {
                      print(value.searchKey);
                      print(courseController.text.toString());
                      setState(() {
                        fetchbranch(courseController.text.toString());
                      });

                      FocusScope.of(context).requestFocus(yearf);
                    },
                    enabled: true,
                    hint: "Course",
                    itemHeight: 50,
                    maxSuggestionsInViewPort: 3,
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SearchField(
                    controller: yearController,
                    focusNode: yearf,
                    suggestionItemDecoration: SuggestionDecoration(),
                    key: const Key("Search key"),
                    suggestions:
                    year.map((e) => SearchFieldListItem(e)).toList(),
                    searchStyle: GoogleFonts.openSans(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w800),
                    suggestionStyle: GoogleFonts.openSans(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                    marginColor: Colors.white,
                    suggestionsDecoration: SuggestionDecoration(
                        color: const Color.fromRGBO(40, 130, 146, 1),
                        //shape: BoxShape.rectangle,
                        padding: const EdgeInsets.all(10),
                        border: Border.all(width: 2, color: Colors.black),
                        borderRadius: BorderRadius.circular(0)),
                    searchInputDecoration: InputDecoration(
                        hintText: "Year",
                        fillColor: Colors.black26.withOpacity(0.7),
                        filled: true,
                        hintStyle: GoogleFonts.openSans(
                            color: Colors.grey,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            width: 3,
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        focusColor: Colors.black,
                        disabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            width: 3,
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            width: 3,
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        )
                    ),
                    onSuggestionTap: (value) {
                      print(value.searchKey);
                      print(universityController.text.toString());

                      FocusScope.of(context).requestFocus(branchf);
                    },
                    enabled: true,
                    hint: "Year",
                    itemHeight: 50,
                    maxSuggestionsInViewPort: 3,
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SearchField(
                    controller: branchController,
                    focusNode: branchf,
                    suggestionItemDecoration: SuggestionDecoration(),
                    key: const Key("Search key"),
                    suggestions:
                    branch.map((e) => SearchFieldListItem(e)).toList(),
                    searchStyle: GoogleFonts.openSans(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w800),
                    suggestionStyle: GoogleFonts.openSans(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                    marginColor: Colors.white,
                    suggestionsDecoration: SuggestionDecoration(
                        color: const Color.fromRGBO(40, 130, 146, 1),
                        //shape: BoxShape.rectangle,
                        padding: const EdgeInsets.all(10),
                        border: Border.all(width: 2, color: Colors.black),
                        borderRadius: BorderRadius.circular(0)),
                    searchInputDecoration: InputDecoration(
                        hintText: "Branch",
                        fillColor: Colors.black26.withOpacity(0.7),
                        filled: true,
                        hintStyle: GoogleFonts.openSans(
                            color: Colors.grey,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            width: 3,
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        focusColor: Colors.black,
                        disabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            width: 3,
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            width: 3,
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        )
                    ),
                    onSuggestionTap: (value) {
                      print(value.searchKey);

                      setState(() {
                        fetchsubject(branchController.text.toString());
                      });
                      FocusScope.of(context).requestFocus(sectionf);
                    },
                    enabled: true,
                    hint: "Branch",
                    itemHeight: 50,
                    maxSuggestionsInViewPort: 3,
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SearchField(
                    controller: sectionController,
                    focusNode: sectionf,
                    suggestionItemDecoration: SuggestionDecoration(),
                    key: const Key("Search key"),
                    suggestions:
                    section.map((e) => SearchFieldListItem(e)).toList(),
                    searchStyle: GoogleFonts.openSans(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w800),
                    suggestionStyle: GoogleFonts.openSans(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                    marginColor: Colors.black,
                    suggestionsDecoration: SuggestionDecoration(
                        color: const Color.fromRGBO(40, 130, 146, 1),
                        //shape: BoxShape.rectangle,
                        padding: const EdgeInsets.all(10),
                        border: Border.all(width: 2, color: Colors.black),
                        borderRadius: BorderRadius.circular(0)),
                    searchInputDecoration: InputDecoration(
                        hintText: "Section",
                        fillColor: Colors.black26.withOpacity(0.7),
                        filled: true,
                        hintStyle: GoogleFonts.openSans(
                            color: Colors.grey,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            width: 3,
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        focusColor: Colors.black,
                        disabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            width: 3,
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            width: 3,
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        )
                    ),
                    onSuggestionTap: (value) {
                      print(value.searchKey);
                      print(universityController.text.toString());

                      //FocusScope.of(context).requestFocus(subjectf);
                    },
                    enabled: true,
                    hint: "Section",
                    itemHeight: 50,
                    maxSuggestionsInViewPort: 3,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Container(

                    height: size.height * 0.14 * subjectlist.length,
                    width: size.width * 1,
                    color: Colors.transparent,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: subjectlist.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: SearchField(
                                  //focusNode:subjectf[index],
                                  controller: subjectlist[index],

                                  suggestionItemDecoration:
                                  SuggestionDecoration(),
                                  key: const Key("Search key"),
                                  suggestions: subjects
                                      .map((e) => SearchFieldListItem(e))
                                      .toList(),
                                  searchStyle: GoogleFonts.openSans(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800),
                                  suggestionStyle: GoogleFonts.openSans(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                  ),
                                  marginColor: Colors.white,
                                  suggestionsDecoration: SuggestionDecoration(

                                      color: const Color.fromRGBO(40, 130, 146, 1),
                                      //shape: BoxShape.rectangle,
                                      padding: const EdgeInsets.all(10),
                                      border: Border.all(
                                          width: 2, color: Colors.black),
                                      borderRadius: BorderRadius.circular(0)),
                                  searchInputDecoration: InputDecoration(
                                      suffixIcon: SizedBox(
                                        width: size.width * 0.28,
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.end,
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  //print(subjectlist[index].text.toString());
                                                  subjectlist.add(
                                                      TextEditingController());
                                                });
                                                FocusScope.of(context)
                                                    .requestFocus(
                                                    subjectf[index]);
                                              },
                                              icon: const Icon(Icons.add),
                                              color: Colors.white,
                                              iconSize: size.height * 0.04,
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  if (index != 0) {
                                                    subjectlist.removeAt(index);
                                                  }
                                                });
                                              },
                                              icon: const Icon(Icons.delete),
                                              color: Colors.white,
                                              iconSize: size.height * 0.04,
                                            )
                                          ],
                                        ),
                                      ),
                                      hintText: "Enter Subject Name",
                                      fillColor: Colors.black26.withOpacity(0.7),
                                      filled: true,
                                      hintStyle: GoogleFonts.openSans(
                                          color: Colors.grey,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          width: 3,
                                          color: Colors.black,
                                        ),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      focusColor: Colors.black,
                                      disabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          width: 3,
                                          color: Colors.black,
                                        ),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          width: 3,
                                          color: Colors.black,
                                        ),
                                        borderRadius: BorderRadius.circular(30),
                                      )
                                  ),
                                  onSuggestionTap: (value) {
                                    print(value.searchKey);
                                    FocusScope.of(context).removeListener;
                                  },
                                  enabled: true,
                                  hint: "Enter subject Name",
                                  itemHeight: 50,
                                  maxSuggestionsInViewPort: 3,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                Container(
                  width: size.width * 0.9,
                  height: size.height * 0.065,
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
                    onPressed: () async {
                      Navigator.push(
                        context,
                        PageTransition(
                          child: const loading(text: 'Data is Proceed Please Wait'),
                          type: PageTransitionType.bottomToTop,
                          duration: const Duration(milliseconds: 400),
                          alignment: Alignment.bottomCenter,
                          childCurrent: const StudentDetails(),
                        ),
                      );
                      print(".............push");
                      for (int i = 0; i < subjectlist.length; i++) {
                        subject.add(subjectlist[i].text.trim());

                        if (universityController.text.isNotEmpty &&
                            collegeController.text.isNotEmpty &&
                            courseController.text.isNotEmpty &&
                            branchController.text.isNotEmpty &&
                            yearController.text.isNotEmpty &&
                            sectionController.text.isNotEmpty &&
                            subjectlist[i].text.trim().isNotEmpty) {
                          Map<String, dynamic> map1 = {
                            "Active": false,
                            "Read_Count": 0,
                            "Last_Active" : DateTime.now(),
                            "Token": FieldValue.arrayUnion([usermodel["Token"]]),
                            "Profile_URL" : usermodel["Profile_URL"],
                            "Name" : usermodel["Name"],
                            "Muted" : false,
                            "Post" : "Students"
                          };
                          List<dynamic> channelList = await FirebaseFirestore.instance.collection("Chat_Channels").doc("Channels").get().then((value){
                            return value.data()?["Channels"];
                          });

                          if(channelList.contains("${universityController.text.trim().split(" ")[0]} "
                              "${collegeController.text.trim().split(" ")[0]} "
                              "${courseController.text.trim().split(" ")[0]} "
                              "${branchController.text.trim().split(" ")[0]} "
                              "${yearController.text.trim().split(" ")[0]} "
                              "${sectionController.text.trim().split(" ")[0]} "
                              "${subjectlist[i].text.trim().split(" ")[0]}")){
                            await FirebaseFirestore.instance
                                .collection("Messages")
                                .doc(
                                "${universityController.text.trim().split(" ")[0]} "
                                    "${collegeController.text.trim().split(" ")[0]} "
                                    "${courseController.text.trim().split(" ")[0]} "
                                    "${branchController.text.trim().split(" ")[0]} "
                                    "${yearController.text.trim().split(" ")[0]} "
                                    "${sectionController.text.trim().split(" ")[0]} "
                                    "${subjectlist[i].text.trim().split(" ")[0]}")
                                .update({
                              "Members": FieldValue.arrayUnion(["${usermodel["Email"]}",]),
                              usermodel["Email"].toString().split("@")[0]:  map1,
                            });
                          }
                          else{
                            DateTime stamp= DateTime.now();
                            await FirebaseFirestore.instance
                                .collection("Messages")
                                .doc(
                                "${universityController.text.trim().split(" ")[0]} "
                                    "${collegeController.text.trim().split(" ")[0]} "
                                    "${courseController.text.trim().split(" ")[0]} "
                                    "${branchController.text.trim().split(" ")[0]} "
                                    "${yearController.text.trim().split(" ")[0]} "
                                    "${sectionController.text.trim().split(" ")[0]} "
                                    "${subjectlist[i].text.trim().split(" ")[0]}")
                                .set({
                              "CreatedOn" : {
                                "Date" : stamp,
                                "Name" : usermodel["Name"]
                              },
                              "Messages": FieldValue.arrayUnion([]),
                              "Members": FieldValue.arrayUnion([
                                "${usermodel["Email"]}",
                              ]),
                              usermodel["Email"].toString().split("@")[0]:  map1,

                            });

                            await FirebaseFirestore.instance.collection("Chat_Channels").doc("Channels").update({
                              "Channels" : FieldValue.arrayUnion([
                                "${universityController.text.trim().split(" ")[0]} "
                                    "${collegeController.text.trim().split(" ")[0]} "
                                    "${courseController.text.trim().split(" ")[0]} "
                                    "${branchController.text.trim().split(" ")[0]} "
                                    "${yearController.text.trim().split(" ")[0]} "
                                    "${sectionController.text.trim().split(" ")[0]} "
                                    "${subjectlist[i].text.trim().split(" ")[0]}"
                              ])
                            });
                            
                          }
                          await FirebaseFirestore.instance
                              .collection("Students")
                              .doc(usermodel["Email"])
                              .update({
                            "Message_channels" : FieldValue.arrayUnion(["${universityController.text.trim().split(" ")[0]} ${collegeController.text.trim().split(" ")[0]} ${courseController.text.trim().split(" ")[0]} ${branchController.text.trim().split(" ")[0]} ${yearController.text.trim().split(" ")[0]} ${sectionController.text.trim().split(" ")[0]} ${subjectlist[i].text.trim()}"]),

                          });

                        }
                      }
                           print(".............................1");

                      if (rollno.text.toString().isNotEmpty &&
                          universityController.text.toString().isNotEmpty &&
                          courseController.text.toString().isNotEmpty &&
                          collegeController.text.toString().isNotEmpty &&
                          yearController.text.toString().isNotEmpty &&
                          branchController.text.toString().isNotEmpty &&
                          sectionController.text.toString().isNotEmpty &&
                          subject.isNotEmpty
                      ) {
                        await FirebaseFirestore.instance
                            .collection("Students")
                            .doc(usermodel["Email"])
                            .update({
                          "Rollnumber": rollno.text.trim().toString(),
                          "University": universityController.text.trim().toString(),
                          "College": collegeController.text.trim().toString(),
                          "Course": courseController.text.trim().toString(),
                          "Year": yearController.text.trim().toString(),
                          "Branch": branchController.text.trim().toString(),
                          "Section": sectionController.text.trim().toString(),
                          "Subject": FieldValue.arrayUnion(subject),
                          "Active": false,
                          "bg": "bg-1.jpg",

                        })
                            .then(
                                (value) async {


                          InAppNotifications.instance
                            ..titleFontSize = 20.0
                            ..descriptionFontSize = 16.0
                            ..textColor = Colors.black
                            ..backgroundColor =
                            const Color.fromRGBO(150, 150, 150, 1)
                            ..shadow = true
                            ..animationStyle =
                                InAppNotificationsAnimationStyle.scale;
                          InAppNotifications.show(
                              title: 'Details',
                              duration: const Duration(seconds: 2),
                              description: "Successfully added",
                              leading: const Icon(
                                Icons.error_outline_outlined,
                                color: Colors.red,
                                size: 25,
                              ));
                          print("Successfully uploaded");
                        })
                            .whenComplete(() async {

                        }).onError((error, stackTrace) {
                          print("Error is: $error");
                          Navigator.pop(context);
                          InAppNotifications.instance
                            ..titleFontSize = 35.0
                            ..descriptionFontSize = 20.0
                            ..textColor = Colors.black
                            ..backgroundColor = const Color.fromRGBO(150, 150, 150, 1)
                            ..shadow = true
                            ..animationStyle = InAppNotificationsAnimationStyle.scale;
                          InAppNotifications.show(
                              title: 'Failed',
                              duration: const Duration(seconds: 2),
                              description: error.toString().split(']')[0].trim(),
                              leading: const Icon(
                                Icons.error_outline_outlined,
                                color: Colors.red,
                                size: 55,
                              ));
                        });
                      }
                      else {
                        Navigator.pop(context);
                        InAppNotifications.instance
                          ..titleFontSize = 14.0
                          ..descriptionFontSize = 14.0
                          ..textColor = Colors.black
                          ..backgroundColor =
                          const Color.fromRGBO(150, 150, 150, 1)
                          ..shadow = true
                          ..animationStyle =
                              InAppNotificationsAnimationStyle.scale;
                        InAppNotifications.show(
                            title: 'Failed',
                            duration: const Duration(seconds: 2),
                            description: "Please fill all the details",
                            leading: const Icon(
                              Icons.error_outline_outlined,
                              color: Colors.red,
                              size: 20,
                            ));

                      }

                      await database().fetchuser().whenComplete(() {
                        Navigator.pop(context);

                        // Creating Channel for students group

                        Navigator.pop(context);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      backgroundColor: Colors.transparent,
                    ),
                    child: AutoSizeText(
                      "Submit",
                      style: GoogleFonts.openSans(
                        fontWeight: FontWeight.w600,
                        fontSize: 23,
                        color: Colors.black,
                        shadows: [
                          const Shadow(
                            color: Colors.black54,
                            blurRadius: 5,
                            offset: Offset(1, 1),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.06),
              ],
            ),
          ),
        ),
      ),
    );
  }

  fetchuniversity() async {
    final ref = await FirebaseFirestore.instance
        .collection("University")
        .doc("University")
        .get();
    university = ref.data()!["University"];
  }

  fetchcollege(String uni) async {
    final ref =
    await FirebaseFirestore.instance.collection("Colleges").doc(uni).get();
    setState(() {
      college = ref.data()!["Colleges"];
      print(college);
    });
  }

  fetchcourse(String coll) async {
    final ref =
    await FirebaseFirestore.instance.collection("Course").doc(coll).get();
    setState(() {
      course = ref.data()!["Course"];
    });
  }

  fetchbranch(String cou) async {
    final ref =
    await FirebaseFirestore.instance.collection("Branch").doc(cou).get();
    setState(() {
      branch = ref.data()!["Branch"];
    });
  }

  fetchsubject(String branch) async {
    final ref = await FirebaseFirestore.instance
        .collection("Subject")
        .doc(branch)
        .get();
    setState(() {
      subjects = ref.data()!["Subject"];
    });
  }
}
