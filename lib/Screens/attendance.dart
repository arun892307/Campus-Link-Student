import 'package:auto_size_text/auto_size_text.dart';
import 'package:campus_link_student/Constraints.dart';
import 'package:campus_link_student/Screens/loadingscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_notifications/flutter_inapp_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

import '../Registration/database.dart';

var absentCount = 0;
var totalLecture = 0;
double percentage = 0;
var attendanceCount = 0;

class Attendance extends StatefulWidget {
  const Attendance({Key? key}) : super(key: key);
  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  DateTime endDate = DateTime.now();
  TextEditingController endDateController = TextEditingController();
  DateTime startDate = DateTime.now();
  TextEditingController startDateController = TextEditingController();

  final _st = GoogleFonts.exo(
      fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black26);
  final TextEditingController monthController = TextEditingController();
  List months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    'August',
    "September",
    "October",
    "November",
    "December"
  ];

  TextEditingController subjectController = TextEditingController();

  List<dynamic> subjects = usermodel["Subject"];
  String selectedSubject = "";

  String selectedMonth = "";
  var monthNumber = -1;

  List<bool> selected = List.filled(6, false);
  bool attendanceData = false;
  var previousIndex = -1;

  // Chart Data

  //pai chart data
  int? touchedIndex;
  final colorList = <Color>[Colors.indigo, Colors.purpleAccent];

  // Bar chart Data List
  List<String> dateWithMonthList = [];

  List<BarChartGroupData> barChartGroupDataList = [];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          // image: DecorationImage(image: AssetImage("assets/images/bg-image.png"),fit: BoxFit.fill
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              // Colors.black,
              // Colors.deepPurple,
              // Colors.purpleAccent
              const Color.fromRGBO(86, 149, 178, 1),

              const Color.fromRGBO(68, 174, 218, 1),
              //Color.fromRGBO(118, 78, 232, 1),
              Colors.deepPurple.shade300
            ],
          ),
        ),
        child: Scaffold(
          extendBody: true,
          backgroundColor: Colors.transparent,
          body: Container(
            height: size.height,
            width: size.width ,
            color: Colors.transparent,
            child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      /*SizedBox(
                        height: size.height * 0.12,
                        width: size.width * 1,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: subjects.length,
                          itemBuilder: (context, index) {
                            return Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: size.width * 0.016,
                                      right: size.width * 0.016),
                                  child: Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          var preIndex = index;
                                          setState(() {
                                            if (previousIndex != -1) {
                                              selected[previousIndex] = false;
                                            }
                                            selected[index] = true;
                                            previousIndex = index;
                                            print(subjects[index]);
                                            selectedSubject = subjects[index];
                                          });
                                        },
                                        child: Container(
                                          height: size.height * 0.068,
                                          width: size.width * 0.2,
                                          decoration: BoxDecoration(
                                              gradient: const LinearGradient(
                                                begin: Alignment.centerLeft,
                                                end: Alignment.centerRight,
                                                colors: [
                                                  Color.fromRGBO(
                                                      169, 169, 207, 1),
                                                  // Color.fromRGBO(86, 149, 178, 1),
                                                  Color.fromRGBO(
                                                      189, 201, 214, 1),
                                                  //Color.fromRGBO(118, 78, 232, 1),
                                                  Color.fromRGBO(
                                                      175, 207, 240, 1),

                                                  // Color.fromRGBO(86, 149, 178, 1),
                                                  Color.fromRGBO(
                                                      189, 201, 214, 1),
                                                  Color.fromRGBO(
                                                      169, 169, 207, 1),
                                                ],
                                              ),
                                              shape: BoxShape.circle,
                                              border: selected[index]
                                                  ? Border.all(
                                                      color: Colors.white,
                                                      width: 2)
                                                  : Border.all(
                                                      color: Colors.blueAccent,
                                                      width: 1)),
                                        ),
                                      ),
                                      SizedBox(
                                        height: size.height * 0.008,
                                      ),
                                      AutoSizeText(
                                        "${subjects[index]}",
                                        style: GoogleFonts.openSans(
                                            color: selected[index]
                                                ? Colors.white
                                                : Colors.black87),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),*/
                      SizedBox(
                        height: size.height * 0.075,
                        width: size.width * 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            /*SearchField(
                        controller: monthcontroller,
                        suggestionItemDecoration: SuggestionDecoration(),
                        key: const Key("Search key"),
                        suggestions:
                            months.map((e) => SearchFieldListItem(e)).toList(),
                        searchStyle: GoogleFonts.exo(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800),
                        suggestionStyle: GoogleFonts.exo(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                        marginColor: Colors.blue,
                        suggestionsDecoration: SuggestionDecoration(
                            color: Colors.blue,
                            //shape: BoxShape.rectangle,
                            padding: const EdgeInsets.all(10),
                            border: Border.all(width: 2, color: Colors.white),
                            borderRadius: BorderRadius.circular(0)),
                        searchInputDecoration: InputDecoration(
                            fillColor: Colors.blueAccent,
                            filled: true,
                            hintStyle: GoogleFonts.exo(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                width: 3,
                                color: Colors.white,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusColor: Colors.white,
                            disabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                width: 3,
                                color: Colors.white,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                width: 3,
                                color: Colors.white,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            )),
                        onSuggestionTap: (value) {
                          print(value.searchKey);

                          print(monthcontroller.text.toString());
                          setState(() {
                            selected_month = monthcontroller.text.toString();
                            month_number = months.indexOf(selected_month) + 1;
                            count_attendance();
                          });
                          print(month_number);
                          //FocusScope.of(context).requestFocus();
                        },
                        enabled: true,
                        hint: "${months[DateTime.now().month - 1]}",
                        itemHeight: 50,
                        maxSuggestionsInViewPort: 3,
                      ),*/
                            /*SizedBox(
                            height: size.height*0.085,
                            width: size.width*0.31,
                            child: SearchField(
                              controller: Subject_Controller,
                              suggestionItemDecoration: SuggestionDecoration(),
                              key: const Key("Search key"),
                              suggestions:
                              _subjects.map((e) => SearchFieldListItem(e)).toList(),
                              searchStyle: _st,
                              suggestionStyle: _st,
                              marginColor: Colors.black,
                              suggestionsDecoration: SuggestionDecoration(
                                  color:Colors.blue,
                                  //shape: BoxShape.rectangle,
                                  padding: const EdgeInsets.all(10),
                                  border: Border.all(width: 1, color: Colors.black),
                                  borderRadius: BorderRadius.circular(0)),
                              searchInputDecoration: InputDecoration(
                                  hintText: "Subject",
                                  contentPadding: EdgeInsets.all(size.height*0.02),
                                  fillColor: Colors.transparent,
                                  filled: true,
                                  // hintStyle: _st,
                                  suffixIcon: Icon(Icons.arrow_drop_down,color: Colors.black,size: size.height*0.04,),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      width: 1,
                                      color: Colors.black,
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  focusColor: Colors.transparent,
                                  disabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      width: 1,
                                      color: Colors.black,
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      width: 1,
                                      color: Colors.black,
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                  )),
                              onSuggestionTap: (value) {
                                FocusScope.of(context).unfocus();

                                setState(() {
                                  selected_subject=Subject_Controller.text.toString().trim();
                                });


                              },
                              enabled: true,
                              hint: "subject",
                              itemHeight: 50,
                              maxSuggestionsInViewPort: 3,
                            ),
                          ),*/
                            Container(
                              height: size.height * 0.08,
                              width: size.width * 0.36,
                              decoration: const BoxDecoration(
                                gradient:  LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [Colors.blue, Colors.purpleAccent],
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                              child: TextField(
                                controller: startDateController,
                                onTap: () async {
                                  final startdate = await _selectDate(context)
                                      .whenComplete(() {});
                                  setState(() {
                                    startDate = startdate;
                                    startDateController.text =
                                        startDate.toString().substring(0, 10);
                                    //print(".....${selected_subject.trim()}-${start_date_controller.text.trim().toString().split("-")[1]}");
                                  });
                                },
                                style:
                                    GoogleFonts.openSans(color: Colors.white),
                                keyboardType: TextInputType.none,
                                cursorColor: Colors.white70,
                                decoration: InputDecoration(
                                    focusedBorder: const OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 2),
                                    ),
                                    hintText: "Start Date",
                                    prefixIcon: Icon(Icons.date_range,
                                        color: startDateController.text.isEmpty
                                            ? Colors.black87
                                            : Colors.white,
                                        size: size.height * 0.03),
                                    fillColor: Colors.transparent,
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(15)),
                                        borderSide: BorderSide(
                                            color:
                                                startDateController.text.isEmpty
                                                    ? Colors.black
                                                    : Colors.white,
                                            width: 1))),
                              ),
                            ),
                            Container(
                              height: size.height * 0.08,
                              width: size.width * 0.36,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [Colors.blue, Colors.purpleAccent],
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                              child: TextField(
                                controller: endDateController,
                                cursorColor: Colors.black,
                                style:
                                    GoogleFonts.openSans(color: Colors.white),
                                onTap: () async {
                                  final enddate = await _selectDate(context);
                                  setState(() {
                                    endDate = enddate;
                                    print(enddate.toString());
                                    endDateController.text =
                                        enddate.toString().substring(0, 10);
                                  });
                                },
                                keyboardType: TextInputType.none,
                                decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(15)),
                                        borderSide: BorderSide(
                                          color: endDateController.text.isEmpty
                                              ? Colors.black
                                              : Colors.white,
                                          width: 1,
                                        )),
                                    hintText: "End Date",
                                    prefixIcon: Icon(Icons.date_range,
                                        color: endDateController.text.isEmpty
                                            ? Colors.black87
                                            : Colors.white,
                                        size: size.height * 0.03),
                                    fillColor: Colors.transparent,
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(15)),
                                        borderSide: BorderSide(
                                            color:
                                                endDateController.text.isEmpty
                                                    ? Colors.black
                                                    : Colors.white,
                                            width: 1))),
                              ),
                            ),
                            Container(
                              height: size.height * 0.074,
                              width: size.width * 0.15,
                              decoration: const BoxDecoration(
                                gradient:  LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [Colors.blue, Colors.purpleAccent],
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      backgroundColor: Colors.transparent),
                                  onPressed: () {
                                    setState(() {
                                      attendanceData = false;
                                    });

                                    Navigator.push(
                                      context,
                                      PageTransition(
                                        child: const loading(
                                            text:
                                                'Data is Proceed Please Wait'),
                                        type: PageTransitionType.bottomToTop,
                                        duration:
                                            const Duration(milliseconds: 400),
                                        alignment: Alignment.bottomCenter,
                                        childCurrent: const Attendance(),
                                      ),
                                    );

                                    if (
                                        endDateController.text == "" ||
                                        startDateController.text == "") {
                                      setState(() {
                                        attendanceData = false;
                                      });
                                      InAppNotifications.instance
                                        ..titleFontSize = 22.0
                                        ..descriptionFontSize = 16.0
                                        ..textColor = Colors.black
                                        ..backgroundColor =
                                            const Color.fromRGBO(
                                                190, 190, 190, 1)
                                        ..shadow = true
                                        ..animationStyle =
                                            InAppNotificationsAnimationStyle
                                                .scale;
                                      InAppNotifications.show(
                                          title: 'Failed',
                                          duration: const Duration(seconds: 5),
                                          description: "Please select all Data",
                                          leading: AutoSizeText(
                                            "!",
                                            style: GoogleFonts.gfsDidot(
                                                color: Colors.red,
                                                fontSize: size.height * 0.06,
                                                fontWeight: FontWeight.w900),
                                          ));
                                      Navigator.pop(context);
                                    } else {
                                      countAttendance(size).whenComplete(() {
                                        Navigator.pop(context);
                                      });
                                    }
                                  },
                                  child: Center(
                                      child: Icon(
                                    Icons.search,
                                    color: Colors.white,
                                    size: size.height * 0.04,
                                  ))),
                            )
                          ],
                        ),
                      ),
                      Divider(
                        color: Colors.black,
                        height: MediaQuery.of(context).size.height * 0.06,
                        thickness: MediaQuery.of(context).size.height * 0.001,
                      ),
                      SizedBox(
                        height: size.height * 0.025,
                      ),
                      attendanceData
                          ? Column(children: [
                              SizedBox(
                                height: size.height * 0.03,
                              ),
                              Container(
                                  width: size.width * 0.9,
                                  height: size.height * 0.31,
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(colors: [
                                      Color.fromRGBO(177, 54, 101, 1),
                                      Color.fromRGBO(43, 39, 113, 1),
                                    ]),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: size.width * 0.055,
                                            ),
                                            AutoSizeText("Subject : ",
                                                style: GoogleFonts.openSans(
                                                    color: Colors.white,
                                                    fontSize:
                                                        size.height * 0.026)),
                                            SizedBox(
                                              width: size.width * 0.02,
                                            ),
                                            AutoSizeText(" ${selectedSubject}",
                                                style: GoogleFonts.openSans(
                                                    color: Colors.white,
                                                    fontSize:
                                                        size.height * 0.026)),
                                          ],
                                        ),
                                        SizedBox(
                                          height: size.height * 0.02,
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: size.width * 0.055,
                                            ),
                                            AutoSizeText("Present : ",
                                                style: GoogleFonts.openSans(
                                                    color: Colors.white,
                                                    fontSize:
                                                        size.height * 0.026)),
                                            SizedBox(
                                              height: size.height * 0.02,
                                            ),
                                            AutoSizeText(" $attendanceCount",
                                                style: GoogleFonts.openSans(
                                                    color: Colors.white,
                                                    fontSize:
                                                        size.height * 0.026)),
                                          ],
                                        ),
                                        SizedBox(
                                          height: size.height * 0.02,
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: size.width * 0.055,
                                            ),
                                            AutoSizeText("Absent : ",
                                                style: GoogleFonts.openSans(
                                                    color: Colors.white,
                                                    fontSize:
                                                        size.height * 0.026)),
                                            SizedBox(
                                              height: size.height * 0.02,
                                            ),
                                            AutoSizeText(" $absentCount",
                                                style: GoogleFonts.openSans(
                                                    color: Colors.white,
                                                    fontSize:
                                                        size.height * 0.026)),
                                          ],
                                        ),
                                        SizedBox(
                                          height: size.height * 0.02,
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: size.width * 0.055,
                                            ),
                                            AutoSizeText("Total Lecture : ",
                                                style: GoogleFonts.openSans(
                                                    color: Colors.white,
                                                    fontSize:
                                                        size.height * 0.026)),
                                            SizedBox(
                                              height: size.height * 0.02,
                                            ),
                                            AutoSizeText(" $totalLecture",
                                                style: GoogleFonts.openSans(
                                                    color: Colors.white,
                                                    fontSize:
                                                        size.height * 0.026)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )),
                              SizedBox(
                                height: size.height * 0.03,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  height: size.height * 0.05,
                                  child: AutoSizeText(
                                    "Bar Chart",
                                    style: GoogleFonts.openSans(
                                        fontSize: size.height * 0.04,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                    height: size.height * 0.32,
                                    width: size.width * 0.98,
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Colors.blue,
                                            Colors.purpleAccent
                                          ],
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30.0))),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                  height: size.height * 0.22,
                                                  width: size.width * 0.53,
                                                  child: Stack(
                                                    children: [
                                                      PieChart(
                                                        PieChartData(
                                                            pieTouchData:
                                                                PieTouchData(
                                                              enabled: true,
                                                              touchCallback: (_,
                                                                  pieTouchResponse) {
                                                                //var pieTouchResponse;
                                                                setState(() {
                                                                  if (pieTouchResponse
                                                                              ?.touchedSection
                                                                          is FlLongPressEnd ||
                                                                      pieTouchResponse
                                                                              ?.touchedSection
                                                                          is FlPanEndEvent) {
                                                                    touchedIndex =
                                                                        -1;
                                                                  } else {
                                                                    touchedIndex =
                                                                        pieTouchResponse
                                                                            ?.touchedSection
                                                                            ?.touchedSectionIndex;
                                                                  }
                                                                });
                                                                //print("....stastwst$touchedIndex1");
                                                              },
                                                            ),
                                                            borderData:
                                                                FlBorderData(
                                                              show: false,
                                                            ),
                                                            sectionsSpace: 8,
                                                            centerSpaceRadius: size.height*0.07,
                                                            sections: sectionData(
                                                                context,
                                                                touchedIndex)),
                                                      ),
                                                      Center(
                                                          child: AutoSizeText(
                                                        "${double.parse(percentage.toStringAsPrecision(2))}%",
                                                        style:
                                                            GoogleFonts.openSans(
                                                                fontSize:
                                                                    size.height *
                                                                        0.04,
                                                                color: Colors
                                                                    .black87,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                      ))
                                                    ],
                                                  )),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                 Row(
                                                   children: [
                                                     Container(
                                                       height: size.height * 0.02,
                                                       width: size.width * 0.04,
                                                       decoration: const BoxDecoration(
                                                           color: Colors.greenAccent,
                                                           shape: BoxShape.circle),
                                                     ),
                                                     AutoSizeText(
                                                       "\t\t\t Present",
                                                       style: GoogleFonts.openSans(
                                                           color: Colors.greenAccent,
                                                           fontSize: size.height * 0.025,
                                                           fontWeight: FontWeight.w600),
                                                     ),
                                                   ],
                                                 ),
                                                  SizedBox(
                                                    height: size.height*0.03,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        height: size.height * 0.02,
                                                        width: size.width * 0.04,
                                                        decoration: const BoxDecoration(
                                                            color: Colors.red,
                                                            shape: BoxShape.circle),
                                                      ),
                                                      AutoSizeText(
                                                        "\t\t\t Present",
                                                        style: GoogleFonts.openSans(
                                                            color: Colors.red,
                                                            fontSize: size.height * 0.025,
                                                            fontWeight: FontWeight.w600),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              )
                                            ]),

                                        /*SizedBox(
                                    height: size.height * 0.08,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      height: size.height * 0.05,
                                      child: AutoSizeText(
                                        "Bar Chart",
                                        style: GoogleFonts.openSans(
                                            fontSize: size.height * 0.04,
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: size.height * 0.04,
                                  ),
                                  Container(
                                    height: size.height * 0.42,
                                    width: size.width * 0.88,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.black,
                                          width: 2,
                                        ),
                                        color: Colors.black26.withOpacity(0.7)),
                                    child: BarChart(
                                      swapAnimationCurve: Curves.linear,
                                      swapAnimationDuration: const Duration(milliseconds: 100),
                                      BarChartData(
                                        barTouchData: BarTouchData(
                                          enabled: true,
                                          allowTouchBarBackDraw: true,
                                          touchTooltipData: BarTouchTooltipData(
                                            tooltipBgColor: Colors.white,
                                            //getTooltipItem: (a, b, c, d) => null,
                                          ),
                                        ),
                                        alignment: BarChartAlignment.center,
                                        barGroups: barChartGroupDataList,
                                        titlesData: FlTitlesData(
                                          show: true,
                                          bottomTitles: AxisTitles(
                                            drawBehindEverything: true,
                                            sideTitles: SideTitles(
                                              showTitles: true,
                                              reservedSize: 38,
                                              interval: size.width * 0.04,
                                              getTitlesWidget: (value, meta) {
                                                return Text(dateWithMonthList[value.toInt()],
                                                  style: GoogleFonts.openSans(
                                                    color: Colors.blueAccent
                                                  ),



                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: size.height * 0.035,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: size.height * 0.02,
                                        width: size.width * 0.04,
                                        decoration: const BoxDecoration(
                                            color: Colors.greenAccent,
                                            shape: BoxShape.circle),
                                      ),
                                      AutoSizeText(
                                        "\t\t\t Present",
                                        style: GoogleFonts.openSans(
                                            color: Colors.greenAccent,
                                            fontSize: size.height * 0.025,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(
                                        width: size.width * 0.26,
                                      ),
                                      Container(
                                        height: size.height * 0.02,
                                        width: size.width * 0.04,
                                        decoration: const BoxDecoration(
                                            color: Colors.amber,
                                            shape: BoxShape.circle),
                                      ),
                                      AutoSizeText(
                                        "\t\t\t Absent",
                                        style: GoogleFonts.openSans(
                                            color: Colors.red,
                                            fontSize: size.height * 0.025,
                                            fontWeight: FontWeight.w600),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: size.height * 0.055,
                                  ),*/
                                      ],
                                    )),
                              )
                            ])
                          : const SizedBox(),
                    ],
                  ),
                )),
          ),
        ));
  }

  Future<void> countAttendance(Size size) async {
    selectedSubject="DBMS";
    barChartGroupDataList.clear();
    dateWithMonthList.clear();
    double dailyAttendanceCount = 0;
    var index = -1;
    String month = "";
    double dailyAbsentCount = 0;
    final now = DateTime.now();
    var currentMon = now.month;
    if (monthNumber == -1) {
      monthNumber = currentMon;
    }
    attendanceCount = 0;
    absentCount = 0;
    percentage = 0;

    var doc = await FirebaseFirestore.instance
        .collection("Students")
        .doc(FirebaseAuth.instance.currentUser?.email)
        .collection("Attendance")
        .doc("$selectedSubject-${startDate.month}")
        .get()
        .then((value) {
      return value.data();
    });
    //print("......................Doc is....$doc");

    if (startDate.month == endDate.month) {
      month = months[startDate.month - 1].toString().substring(0, 3);
      for (var i = startDate.day; i <= endDate.day; i++) {
        dateWithMonthList.add("$i\n$month");
        dailyAbsentCount = 0;
        dailyAttendanceCount = 0;
        index++;
        // print(".................map is.${doc?["$i"][0]}..............");
        if (doc?["$i"] != null) {
          List<dynamic> map = [];
          map = doc?["$i"];
          // print(".................map is.$map..............");
          for (var element in map) {
            print(element);
            if (element["Status"] == "Present") {
              attendanceCount++;
              dailyAttendanceCount++;
            } else {
              absentCount++;
              dailyAbsentCount++;
            }
          }
        }

        barChartGroupDataList.add(BarChartGroupData(x: index, barRods: [
          BarChartRodData(
              toY: dailyAttendanceCount,
              fromY: 0,
              color: Colors.greenAccent,
              width: size.width * 0.035,
              borderRadius: const BorderRadius.all(Radius.zero)),
          BarChartRodData(
              toY: dailyAbsentCount + dailyAttendanceCount,
              fromY: 0,
              color: Colors.amber,
              width: size.width * 0.035,
              borderRadius: const BorderRadius.all(Radius.zero)),
        ]));
      }
    } else {
      // for first month
      var start = startDate.day;
      var end = database().getDaysInMonth(startDate.year, startDate.month);
      month = months[startDate.month - 1].toString().substring(0, 3);
      for (var i = start; i <= end; i++) {
        dateWithMonthList.add("$i\n$month");
        dailyAbsentCount = 0;
        dailyAttendanceCount = 0;
        index++;
        if (doc?["$i"] != null) {
          List<dynamic> map = [];
          map = doc?["$i"];
          for (var element in map) {
            if (element["Status"] == "Present") {
              attendanceCount++;
              dailyAttendanceCount++;
            } else {
              absentCount++;
              dailyAbsentCount++;
            }
          }
        }

        barChartGroupDataList.add(BarChartGroupData(x: index, barRods: [
          BarChartRodData(
              toY: dailyAttendanceCount,
              fromY: 0,
              color: Colors.greenAccent,
              width: size.width * 0.035,
              borderRadius: const BorderRadius.all(Radius.zero)),
          BarChartRodData(
              toY: dailyAbsentCount + dailyAttendanceCount,
              fromY: 0,
              color: Colors.amber,
              width: size.width * 0.035,
              borderRadius: const BorderRadius.all(Radius.zero)),
        ]));
      }

      // Fore next monts
      var doc_2 = await FirebaseFirestore.instance
          .collection("Students")
          .doc(FirebaseAuth.instance.currentUser?.email)
          .collection("Attendance")
          .doc("$selectedSubject-${endDate.month}")
          .get()
          .then((value) {
        return value.data();
      });

      print("...........$doc_2");
      start = 1;
      month = months[endDate.month - 1].toString().substring(0, 3);
      for (var i = start; i <= endDate.day; i++) {
        dateWithMonthList.add("$i\n$month");
        dailyAbsentCount = 0;
        dailyAttendanceCount = 0;
        index++;
        List<dynamic> map = [];
        if (doc_2?["$i"] != null) {
          map = doc_2?["$i"];
          for (var element in map) {
            if (element["Status"] == "Present") {
              attendanceCount++;
              dailyAttendanceCount++;
            } else {
              absentCount++;
              dailyAbsentCount++;
            }
          }
        }
        barChartGroupDataList.add(BarChartGroupData(x: index, barRods: [
          BarChartRodData(
              toY: dailyAttendanceCount,
              fromY: 0,
              color: Colors.greenAccent,
              width: size.width * 0.035,
              borderRadius: const BorderRadius.all(Radius.zero)),
          BarChartRodData(
              toY: dailyAbsentCount + dailyAttendanceCount,
              fromY: 0,
              color: Colors.amber,
              width: size.width * 0.035,
              borderRadius: const BorderRadius.all(Radius.zero)),
        ]));
      }
    }
    setState(() {
      totalLecture = attendanceCount + absentCount;
      percentage = (attendanceCount / totalLecture) * 100;
      attendanceData = true;
    });
  }

  List<PieChartSectionData> sectionData(
      BuildContext context, int? touchedIndex) {
    return PieData()
        .data
        .asMap()
        .map<int, PieChartSectionData>((index, data) {
          double size = index == touchedIndex
              ? MediaQuery.of(context).size.height * 0.05
              : MediaQuery.of(context).size.height * 0.042;
          double _fontSize = index == touchedIndex ? 20 : 16;

          print(",,,,,,,,,,,,${index == touchedIndex}");

          final value = PieChartSectionData(
              color: data.color,
              value: data.present,
              radius: size,
              title: '${data.present}%',
              titleStyle: GoogleFonts.openSans(
                  color: Colors.amber,
                  fontSize: _fontSize,
                  fontWeight: FontWeight.w600));
          return MapEntry(index, value);
        })
        .values
        .toList();
  }

  Future<DateTime> _selectDate(BuildContext context) async {
    DateTime date = DateTime.now();
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime(2023, 5),
        lastDate: DateTime(2101));
    if (picked != null && picked != date) {
      date = picked;
    }
    return date;
  }
}

// Pie Chart Data

class PieData {
  List<Data> data = [
    Data(name: "Present", present: double.parse(percentage.toStringAsPrecision(2)), color: Colors.greenAccent),
    Data(name: "Absent", present: double.parse((100.0 - percentage).toStringAsPrecision(2)), color: Colors.red)
  ];
}

class Data {
  late String name;
  late double present;
  late Color color;
  Data({required this.name, required this.present, required this.color});
}

/*
Table(
border: TableBorder.all(
color:Colors.black54,
width: 1),
children: [
checkHoliday
?
TableRow(
decoration:   const BoxDecoration(
gradient: LinearGradient(
begin: Alignment.centerLeft,
end: Alignment.centerRight,
colors: [
Color.fromRGBO(169, 169, 207, 1),
// Color.fromRGBO(86, 149, 178, 1),
Color.fromRGBO(189, 201, 214, 1),
//Color.fromRGBO(118, 78, 232, 1),
Color.fromRGBO(175, 207, 240, 1),

// Color.fromRGBO(86, 149, 178, 1),
Color.fromRGBO(189, 201, 214, 1),
Color.fromRGBO(169, 169, 207, 1),
],
),
),
children: [
Center(
child: AutoSizeText(
"Holiday",
style: GoogleFonts.openSans(
color: Colors.red,
fontSize: 16
),

),
),
]
)
    :
TableRow(
decoration:   const BoxDecoration(
gradient: LinearGradient(
begin: Alignment.centerLeft,
end: Alignment.centerRight,
colors: [
Color.fromRGBO(169, 169, 207, 1),
// Color.fromRGBO(86, 149, 178, 1),
Color.fromRGBO(189, 201, 214, 1),
//Color.fromRGBO(118, 78, 232, 1),
Color.fromRGBO(175, 207, 240, 1),

// Color.fromRGBO(86, 149, 178, 1),
Color.fromRGBO(189, 201, 214, 1),
Color.fromRGBO(169, 169, 207, 1),
],
),
),
children: [
Center(
child: AutoSizeText(
"$dateCount",
style: GoogleFonts.openSans(
color: Colors.black,
fontSize: 16
),

),
),
Center(
child: AutoSizeText(
"${months[startDate.month-1]}",
style: GoogleFonts.openSans(
color: Colors.black,
fontSize: 16
),

),
),
Center(
child: AutoSizeText(
"$presentCount",
style: GoogleFonts.openSans(
color: Colors.black,
fontSize: 16
),

),
),
Center(
child: AutoSizeText(
"$absentCount",
style: GoogleFonts.openSans(
color: Colors.black,
fontSize: 16
),

),
)
]
),
]
);*/

/* Center(
          child: Container(
            height: size.height*0.4,
            width: size.width*0.85,
            child: Column(
              mainAxisAlignment:  MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      AutoSizeText(
                        "Subject :",
                        style: GoogleFonts.openSans(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.42,
                        child: SearchField(
                          controller: Subject_Controller,
                          suggestionItemDecoration: SuggestionDecoration(),
                          key: const Key("Search key"),
                          suggestions:
                          _subjects.map((e) => SearchFieldListItem(e)).toList(),
                          searchStyle: _st,
                          suggestionStyle: _st,
                          marginColor: Colors.black,
                          suggestionsDecoration: SuggestionDecoration(
                              color:Colors.blue,
                              //shape: BoxShape.rectangle,
                              padding: const EdgeInsets.all(10),
                              border: Border.all(width: 1, color: Colors.black),
                              borderRadius: BorderRadius.circular(0)),
                          searchInputDecoration: InputDecoration(
                              hintText: "Subject",
                              contentPadding: EdgeInsets.all(size.height*0.02),
                              fillColor: Colors.transparent,
                              filled: true,
                              // hintStyle: _st,
                              suffixIcon: Icon(Icons.arrow_drop_down,color: Colors.black,size: size.height*0.04,),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  width: 1,
                                  color: Colors.black,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              focusColor: Colors.transparent,
                              disabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  width: 1,
                                  color: Colors.black,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  width: 1,
                                  color: Colors.black,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              )),
                          onSuggestionTap: (value) {
                            FocusScope.of(context).unfocus();

                            setState(() {
                              selected_subject=Subject_Controller.text.toString().trim();
                            });


                          },
                          enabled: true,
                          hint: "subject",
                          itemHeight: 50,
                          maxSuggestionsInViewPort: 3,
                        ),
                      ),
                    ]
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AutoSizeText(
                      "From :",
                      style: GoogleFonts.exo(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.42,
                      child: TextField(
                        controller: start_date_controller,
                        onTap: () async {
                          final start_date = await _selectDate(context).whenComplete(() {

                          });
                          setState(() {
                             startDate=start_date;
                            print("......................$startDate");
                            start_date_controller.text =
                                startDate.toString().substring(0, 10);
                            //print(".....${selected_subject.trim()}-${start_date_controller.text.trim().toString().split("-")[1]}");
                          });
                        },
                        keyboardType: TextInputType.none,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                            focusedBorder: const OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(15)),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                )),
                            hintText: "Start Date",
                            prefixIcon: Icon(Icons.date_range,
                                color: Colors.black54,
                                size: size.height * 0.03),
                            fillColor: Colors.transparent,
                            enabledBorder: const OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(15)),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                ))),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "      To :",
                      style: GoogleFonts.exo(
                          fontSize: 18,
                          color: Colors.black, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      width: size.width * 0.42,
                      child: TextField(
                        controller: end_date_controller,
                        cursorColor: Colors.black,
                        onTap: () async {
                          final enddate = await _selectDate(context);
                          setState(() {
                            endDate=enddate;
                            print(enddate.toString());
                            end_date_controller.text =
                                enddate.toString().substring(0, 10);
                          });
                        },
                        keyboardType: TextInputType.none,
                        decoration: InputDecoration(
                            focusedBorder: const OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(15)),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                )),
                            hintText: "End Date",
                            prefixIcon: Icon(Icons.date_range,
                                color: Colors.black54,
                                size: size.height * 0.03),
                            fillColor: Colors.transparent,
                            enabledBorder: const OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(15)),
                                borderSide: BorderSide(color: Colors.black))),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: size.width*0.55,
                  height: size.height*0.046,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          elevation: 20,
                          backgroundColor: Colors.black12),
                      onPressed: (){
                        setState(() {
                          attendance_data=true;
                        });
                      },
                      child:AutoSizeText(
                        "Show Attendance",
                        style: GoogleFonts.openSans(
                            color: Colors.white
                        ),
                      )

                  ),
                )

              ],
            ),
          ),
        )*/
