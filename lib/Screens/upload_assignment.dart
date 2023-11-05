import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:campus_link_student/Screens/loadingscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Constraints.dart';

class AssigmentQuestion extends StatefulWidget {
  AssigmentQuestion(
      {super.key,
        required this.selectedSubject,
        required this.assignmentNumber, required this.deadline});
  String selectedSubject;
  int assignmentNumber;
  final String deadline;

  @override
  State<AssigmentQuestion> createState() => _AssigmentQuestionState();
}

class _AssigmentQuestionState extends State<AssigmentQuestion> {
  late final FilePickerResult? filePath;
  bool fileSelected = false;
  int assignmentCount = 0;

  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black45.withOpacity(0.9),
      body: Container(
        height: size.height,
        padding: EdgeInsets.all(size.height * 0.01),
        decoration: BoxDecoration(
          color: Colors.black45.withOpacity(0.5),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child:
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
              height: size.height * 0.1,
            ),
            Padding(
              padding: EdgeInsets.all(size.height * 0.009),
              child: Row(
                children: [
                  AutoSizeText(
                    "Upload File",
                    style: GoogleFonts.openSans(
                      color: Colors.white,
                      fontSize: size.height * 0.023,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(
                    width: size.width * 0.02,
                  ),
                  const Icon(
                    Icons.cloud_upload,
                    color: Colors.white,
                  )
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                  height: size.height * 0.1,
                  width: size.width,
                  child: DottedBorder(
                      color: Colors.white,
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(12),
                      padding: EdgeInsets.all(size.height * 0.01),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            size: size.height * 0.04,
                            Icons.upload_sharp,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: size.width * 0.03,
                          ),
                          AutoSizeText(
                            "Drop item here  or",
                            style: GoogleFonts.openSans(
                              color: Colors.white,
                              fontSize: size.height * 0.02,
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              await FilePicker.platform
                                  .pickFiles(
                                  type: FileType.custom,
                                  allowedExtensions: ['pdf'],
                                  allowMultiple: false)
                                  .then((value) {
                                if (value!.files[0].path!.isNotEmpty) {
                                  filePath = value;
                                  print(
                                      ".......PickedFile${filePath?.files[0].path}");
                                  setState(() {
                                    fileSelected = true;
                                  });
                                }
                              });
                            },
                            child: AutoSizeText(
                              "Browse File",
                              style: GoogleFonts.openSans(
                                  color: Colors.white,
                                  fontSize: size.height * 0.02,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          fileSelected
                              ? Icon(
                            size: size.height * 0.02,
                            Icons.check_circle,
                            color: Colors.green.shade800,
                          )
                              : const SizedBox()
                        ],
                      ))),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            Center(
              child: Container(
                height: size.height * 0.06,
                width: size.width * 0.466,
                decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.blue,
                        Colors.purpleAccent,
                      ],
                    ),
                    borderRadius:
                    BorderRadius.all(Radius.circular(size.width * 0.033)),
                    border: Border.all(color: Colors.black, width: 2)),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent),
                  onPressed: () async {
                    if (fileSelected) {
                      const loading(text: 'Please wait Data is Uploading',);
                      Reference ref = FirebaseStorage.instance
                          .ref("Student_Assignment")
                          .child(
                          "${usermodel["University"].split(" ")[0]} ${usermodel["College"].split(" ")[0]} ${usermodel["Course"].split(" ")[0]} ${usermodel["Branch"].split(" ")[0]} ${usermodel["Year"]} ${usermodel["Section"]} ${widget.selectedSubject}");
                      DateTime stamp = DateTime.now();
                      Reference filename = ref.child("$stamp");
                      TaskSnapshot snap = await filename
                          .putFile(File("${filePath!.files[0].path}"));
                      String pdfURL = " ";
                      await snap.ref
                          .getDownloadURL()
                          .then((value) => pdfURL = value)
                          .whenComplete(() {
                        FirebaseFirestore.instance
                            .collection("Assignment")
                            .doc(
                            "${usermodel["University"].split(" ")[0]} ${usermodel["College"].split(" ")[0]} ${usermodel["Course"].split(" ")[0]} ${usermodel["Branch"].split(" ")[0]} ${usermodel["Year"]} ${usermodel["Section"]} ${widget.selectedSubject}")
                            .update({
                          "Assignment-${widget.assignmentNumber}.Submitted-by":
                          FieldValue.arrayUnion([
                            "${usermodel["Email"].toString().split("@")[0]}-${usermodel["Name"]}-${usermodel["Rollnumber"]}"
                          ]),
                          "Assignment-${widget.assignmentNumber}.submitted-Assignment.${usermodel["Email"].toString().split("@")[0]}-${usermodel["Name"]}-${usermodel["Rollnumber"]}":
                          {
                            "Document_Type": filePath?.files[0].extension,
                            "File_Size": filePath?.files[0].size,
                            "Time": stamp,
                            "Status":" ",
                          }
                        }).whenComplete(() async {
                          print("Completed");
                          print("subject: ${widget.selectedSubject}\n assignment number: ${widget.assignmentNumber}\n dealine: ${widget.deadline}");
                          await FirebaseFirestore.instance.collection("Students").doc(usermodel["Email"]).update({
                            'Notifications' : FieldValue.arrayRemove([{
                              'body' : "Your ${widget.selectedSubject} assignment ${widget.assignmentNumber} is pending. Please complete your assignment as soon as possible.Deadline: ${widget.deadline}",
                              'title' : "${widget.selectedSubject} assignment pending."
                            }])
                          }).whenComplete(() => Navigator.pop(context));


                        }


                        );
                      }
                      );
                    }
                  },
                  child: AutoSizeText(
                    "Submit",
                    style: GoogleFonts.openSans(
                        fontSize: size.height * 0.025,
                        color: Colors.white,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
