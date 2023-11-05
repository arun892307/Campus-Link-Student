import 'package:auto_size_text/auto_size_text.dart';
import 'package:campus_link_student/Constraints.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'attendance.dart';
import 'loadingscreen.dart';

late double s1Percent;
late double s2Percent;
late double s3Percent;

class Marks extends StatefulWidget {
  const Marks({Key? key}) : super(key: key);

  @override
  State<Marks> createState() => _MarksState();
}

class _MarksState extends State<Marks> {
  var previousIndex = -1;
  int? touchedIndex1 = -1;
  int? touchedIndex2 = -1;
  int? touchedIndex3 = -1;

  // sessional percentage

  List<BarChartGroupData> barChartGroupDataList = [];

  List<bool> selected = List.filled(usermodel["Subject"].length, false);

  List<dynamic> subjects = usermodel["Subject"];
  String selectedSubject = usermodel["Subject"][0];
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final TextStyle _st = GoogleFonts.exo(
      color: Colors.white,
      fontSize: size.height * 0.024,
    );
    return Container(
      height: size.height ,
      width: size.width * 0.9,
      decoration: BoxDecoration(
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
      child: Padding(
          padding: EdgeInsets.all(size.height * 0.01),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                SizedBox(
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
                                      selected =
                                          List.filled(subjects.length, false);
                                      /*if (previousIndex != -1) {
                                        selected[previousIndex] = false;
                                      }*/
                                      selected[index] = true;
                                      // previousIndex = index;
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
                                        shape: BoxShape.circle,
                                        border: selected[index]
                                            ? Border.all(
                                                color: Colors.white, width: 2)
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
                ),
                Divider(
                  color: Colors.black,
                  height: MediaQuery.of(context).size.height * 0.03,
                  thickness: MediaQuery.of(context).size.height * 0.001,
                ),
                SizedBox(
                  height: size.height * 0.04,
                ),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("Students")
                      .doc(FirebaseAuth.instance.currentUser?.email)
                      .snapshots(),
                  builder: (context, snapshot) {
                    int count = 0;
                    int index = -1;
                    if (snapshot.hasData) {
                      barChartGroupDataList.clear();
                      if (snapshot.data!.data()?["S-1-$selectedSubject"] !=
                              null &&
                          snapshot.data!.data()?["S-1-max_marks"] != null) {
                        count++;
                        int s1Marks = int.parse(
                            snapshot.data!.data()?["S-1-$selectedSubject"]);
                        int s1MaxMarks =
                            int.parse(snapshot.data!.data()?["S-1-max_marks"]);
                        s1Percent = double.parse(
                            ((s1Marks / s1MaxMarks) * 100).toStringAsFixed(2));
                        index++;
                        barChartGroupDataList
                            .add(BarChartGroupData(x: index, barRods: [
                          BarChartRodData(
                              toY: s1MaxMarks.toDouble(),
                              fromY: 0,
                              color: Colors.greenAccent,
                              width: size.width * 0.035,
                              borderRadius:
                                  const BorderRadius.all(Radius.zero)),
                          BarChartRodData(
                              toY: s1Marks.toDouble(),
                              fromY: 0,
                              color: Colors.amber,
                              width: size.width * 0.035,
                              borderRadius:
                                  const BorderRadius.all(Radius.zero)),
                        ]));
                      } else {
                        index++;
                        barChartGroupDataList
                            .add(BarChartGroupData(x: index, barRods: [
                          BarChartRodData(
                              toY: 0,
                              fromY: 0,
                              color: Colors.greenAccent,
                              width: size.width * 0.035,
                              borderRadius:
                                  const BorderRadius.all(Radius.zero)),
                          BarChartRodData(
                              toY: 0,
                              fromY: 0,
                              color: Colors.amber,
                              width: size.width * 0.035,
                              borderRadius:
                                  const BorderRadius.all(Radius.zero)),
                        ]));
                      }
                      if (snapshot.data!.data()?["S-2-$selectedSubject"] !=
                              null &&
                          snapshot.data!.data()?["S-2-max_marks"] != null) {
                        count++;
                        int s2Marks = int.parse(
                            snapshot.data!.data()?["S-2-$selectedSubject"]);
                        int s2MaxMarks =
                            int.parse(snapshot.data!.data()?["S-2-max_marks"]);
                        s2Percent = double.parse(
                            ((s2Marks / s2MaxMarks) * 100).toStringAsFixed(2));
                        index++;
                        barChartGroupDataList
                            .add(BarChartGroupData(x: index, barRods: [
                          BarChartRodData(
                              toY: s2MaxMarks.toDouble(),
                              fromY: 0,
                              color: Colors.greenAccent,
                              width: size.width * 0.035,
                              borderRadius:
                                  const BorderRadius.all(Radius.zero)),
                          BarChartRodData(
                              toY: s2Marks.toDouble(),
                              fromY: 0,
                              color: Colors.amber,
                              width: size.width * 0.035,
                              borderRadius:
                                  const BorderRadius.all(Radius.zero)),
                        ]));
                      } else {
                        index++;
                        barChartGroupDataList
                            .add(BarChartGroupData(x: index, barRods: [
                          BarChartRodData(
                              toY: 0,
                              fromY: 0,
                              color: Colors.greenAccent,
                              width: size.width * 0.035,
                              borderRadius:
                                  const BorderRadius.all(Radius.zero)),
                          BarChartRodData(
                              toY: 0,
                              fromY: 0,
                              color: Colors.amber,
                              width: size.width * 0.035,
                              borderRadius:
                                  const BorderRadius.all(Radius.zero)),
                        ]));
                      }
                      if (snapshot.data!.data()?["S-3-$selectedSubject"] !=
                              null &&
                          snapshot.data!.data()?["S-3-max_marks"] != null) {
                        count++;
                        int s3Marks = int.parse(
                            snapshot.data!.data()?["S-3-$selectedSubject"]);
                        int s3MaxMarks =
                            int.parse(snapshot.data!.data()?["S-3-max_marks"]);
                        s3Percent = double.parse(
                            ((s3Marks / s3MaxMarks) * 100).toStringAsFixed(2));
                        index++;
                        barChartGroupDataList
                            .add(BarChartGroupData(x: index, barRods: [
                          BarChartRodData(
                              toY: s3MaxMarks.toDouble(),
                              fromY: 0,
                              color: Colors.greenAccent,
                              width: size.width * 0.035,
                              borderRadius:
                                  const BorderRadius.all(Radius.zero)),
                          BarChartRodData(
                              toY: s3Marks.toDouble(),
                              fromY: 0,
                              color: Colors.amber,
                              width: size.width * 0.035,
                              borderRadius:
                                  const BorderRadius.all(Radius.zero)),
                        ]));
                      } else {
                        index++;
                        barChartGroupDataList
                            .add(BarChartGroupData(x: index, barRods: [
                          BarChartRodData(
                              toY: 0,
                              fromY: 0,
                              color: Colors.greenAccent,
                              width: size.width * 0.035,
                              borderRadius:
                                  const BorderRadius.all(Radius.zero)),
                          BarChartRodData(
                              toY: 0,
                              fromY: 0,
                              color: Colors.amber,
                              width: size.width * 0.035,
                              borderRadius:
                                  const BorderRadius.all(Radius.zero)),
                        ]));
                      }
                    }

                    return snapshot.hasData && count>0
                        ?
                        Column(
                          children: [
                            AutoSizeText("Sessional Progress",
                            style: GoogleFonts.openSans(
                              color: Colors.black87,
                              fontSize: size.height*0.03
                            ),),
                            SizedBox(
                              height: size.height*0.05,
                            ),
                            SizedBox(
                              height: count>2?size.height * 0.52:size.height * 0.28,
                              width: size.width * 1,
                              child: GridView.builder(
                                gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                ),
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: 3,
                                itemBuilder: (context, index) {
                                  return Center(
                                    child: SizedBox(
                                        height: size.height * 0.5,
                                        width: size.width * 0.53,
                                        child:
                                        snapshot.data!.data()?["S-${index+1}-$selectedSubject"]!=null && snapshot.data!.data()?["S-${index+1}-max_marks"]!=null
                                            ?
                                        Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            PieChart(
                                              PieChartData(
                                                  pieTouchData: PieTouchData(
                                                    enabled: true,
                                                    touchCallback:
                                                        (_, pieTouchResponse) {
                                                      //var pieTouchResponse;
                                                      setState(() {
                                                        if (pieTouchResponse
                                                            ?.touchedSection
                                                        is FlLongPressEnd ||
                                                            pieTouchResponse
                                                                ?.touchedSection
                                                            is FlPanEndEvent) {
                                                          index==0
                                                              ?
                                                          touchedIndex1=-1
                                                              :
                                                          index==1
                                                              ?
                                                          touchedIndex2=-1
                                                              :
                                                          touchedIndex3=-1;

                                                        } else {
                                                          index==0
                                                              ?
                                                          touchedIndex1 =
                                                              pieTouchResponse
                                                                  ?.touchedSection
                                                                  ?.touchedSectionIndex
                                                              :
                                                          index==1
                                                              ?
                                                          touchedIndex2 =
                                                              pieTouchResponse
                                                                  ?.touchedSection
                                                                  ?.touchedSectionIndex
                                                              :
                                                          touchedIndex3 =
                                                              pieTouchResponse
                                                                  ?.touchedSection
                                                                  ?.touchedSectionIndex;
                                                        }
                                                      });
                                                      print(
                                                          "....stastwst$touchedIndex1");
                                                    },
                                                  ),
                                                  borderData: FlBorderData(
                                                    show: false,
                                                  ),
                                                  sectionsSpace: 8,
                                                  centerSpaceRadius: size.height*0.065,
                                                  sections: index==0?
                                                  sectionData1(context, touchedIndex1)
                                                      :
                                                  index==1
                                                      ?
                                                  sectionData2(context, touchedIndex2)
                                                      :
                                                  sectionData3(context, touchedIndex3)


                                              ),
                                            ),
                                            Center(
                                                child: AutoSizeText("${snapshot.data!.data()?["S-${index+1}-$selectedSubject"]}/${snapshot.data!.data()?["S-${index+1}-max_marks"]}",
                                                  style: GoogleFonts.openSans(
                                                      fontSize: size.height*0.022,
                                                      color: Colors.black87,
                                                      fontWeight: FontWeight.w600
                                                  ),)
                                            ),
                                            SizedBox(
                                                height: size.height*0.1
                                            ),
                                            /*Align(
                                              alignment: Alignment.bottomCenter,
                                              child: AutoSizeText("${snapshot.data!.data()?["S-${index+1}-$selectedSubject"]}/${snapshot.data!.data()?["S-${index+1}-max_marks"]}",
                                                style: GoogleFonts.openSans(
                                                    fontSize: size.height*0.022,
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.w600
                                                ),),
                                            )*/
                                          ],
                                        )
                                            :
                                        null
                                    ),
                                  );
                                },
                              ),
                            )
                          ],
                        )
                        : const loading(
                            text: "Data is Retrieving from server please wait");
                  },
                ),
                AutoSizeText("Attendance Progress",
                  style: GoogleFonts.openSans(
                      color: Colors.black87,
                      fontSize: size.height*0.03
                  ),),
                SizedBox(
                  height: size.height*0.05,
                ),
                Container(
                  height:size.height*1,
                  width:size.width*1,
                  color: Colors.transparent,
                  child: const Attendance()
                )

              ],
            ),
          )),
    );
  }

  List<PieChartSectionData> sectionData1(
      BuildContext context, int? touchedIndex) {
    return PieData1()
        .data
        .asMap()
        .map<int, PieChartSectionData>((index, data) {
          double size = index == touchedIndex
              ? MediaQuery.of(context).size.height * 0.044
              : MediaQuery.of(context).size.height * 0.035;
          double fontSize = index == touchedIndex ? 14 : 12;

          final value = PieChartSectionData(
              color: data.color,
              value: data.present,
              radius: size,
              title: '${data.present}%',
              showTitle: true,
              titleStyle: GoogleFonts.openSans(
                  color: Colors.amber,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600));
          return MapEntry(index, value);
        })
        .values
        .toList();
  }

  List<PieChartSectionData> sectionData2(
      BuildContext context, int? touchedIndex) {
    return PieData2()
        .data
        .asMap()
        .map<int, PieChartSectionData>((index, data) {
          double size = index == touchedIndex
              ? MediaQuery.of(context).size.height * 0.044
              : MediaQuery.of(context).size.height * 0.035;
          double fontSize = index == touchedIndex ? 14 : 12;

          final value = PieChartSectionData(
              color: data.color,
              value: data.present,
              radius: size,
              title: '${data.present}%',
              showTitle: true,
              titleStyle: GoogleFonts.openSans(
                  color: Colors.amber,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600));
          return MapEntry(index, value);
        })
        .values
        .toList();
  }

  List<PieChartSectionData> sectionData3(
      BuildContext context, int? touchedIndex) {
    return PieData3()
        .data
        .asMap()
        .map<int, PieChartSectionData>((index, data) {
          double size = index == touchedIndex
              ? MediaQuery.of(context).size.height * 0.044
              : MediaQuery.of(context).size.height * 0.035;
          double fontSize = index == touchedIndex ? 14 : 12;

          final value = PieChartSectionData(
              color: data.color,
              value: data.present,
              radius: size,
              title: '${data.present}%',
              titleStyle: GoogleFonts.openSans(
                  color: Colors.amber,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600));
          return MapEntry(index, value);
        })
        .values
        .toList();
  }
}

class PieData1 {
  List<Data> data = [
    Data(name: "Present", present: s1Percent, color: Colors.greenAccent),
    Data(name: "Absent", present: 100.0 - s1Percent, color: Colors.red)
  ];
}

class PieData2 {
  List<Data> data = [
    Data(name: "Present", present: s2Percent, color: Colors.greenAccent),
    Data(name: "Absent", present: 100.0 - s2Percent, color: Colors.red)
  ];
}

class PieData3 {
  List<Data> data = [
    Data(name: "Present", present: s3Percent, color: Colors.greenAccent),
    Data(name: "Absent", present: 100.0 - s3Percent, color: Colors.red)
  ];
}

class Data {
  late String name;
  late double present;
  late Color color;
  Data({required this.name, required this.present, required this.color});
}
