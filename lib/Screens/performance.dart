import 'package:flutter/material.dart';

class performance extends StatefulWidget {

  var key;

  performance({this.key,}) : super(key: key);

  _performanceState createState() => _performanceState();
}

class _performanceState extends State<performance> {
  // late List<charts.Series<Pollution, String>> _seriesData;
  // late List<charts.Series<Task, String>> _seriesPieData;
  // late List<charts.Series<Sales, int>> _seriesLineData;

  // _generateData() {
  //   var data1 = [
  //     Pollution(1, 'A', 30),
  //     Pollution(2, 'B', 40),
  //     Pollution(3, 'C', 10),
  //   ];
  //   var data2 = [
  //     Pollution(1, 'A', 30),
  //     Pollution(2, 'B', 40),
  //     Pollution(3, 'C', 10),
  //   ];
  //   var data3 = [
  //     Pollution(1, 'A', 30),
  //     Pollution(2, 'B', 40),
  //     Pollution(3, 'C', 10),
  //   ];
  //
  //   var piedata = [
  //     Task('Work', 35.8, Color(0xff3366cc)),
  //     Task('Eat', 8.3, Color(0xff990099)),
  //     Task('Commute', 10.8, Color(0xff109618)),
  //     Task('TV', 15.6, Color(0xfffdbe19)),
  //     Task('Sleep', 19.2, const Color(0xffff9900)),
  //     Task('Other', 10.3, Color(0xffdc3912)),
  //   ];
  //
  //   var linesalesdata = [
  //     Sales(0, 45),
  //     Sales(1, 56),
  //     Sales(2, 55),
  //     Sales(3, 60),
  //     Sales(4, 61),
  //     Sales(5, 70),
  //   ];
  //   var linesalesdata1 = [
  //     Sales(0, 35),
  //     Sales(1, 46),
  //     Sales(2, 45),
  //     Sales(3, 50),
  //     Sales(4, 51),
  //     Sales(5, 60),
  //   ];
  //
  //   var linesalesdata2 = [
  //     Sales(0, 20),
  //     Sales(1, 24),
  //     Sales(2, 25),
  //     Sales(3, 40),
  //     Sales(4, 45),
  //     Sales(5, 60),
  //   ];
  //
  //   _seriesData.add(
  //     charts.Series(
  //       domainFn: (Pollution pollution, _) => pollution.place,
  //       measureFn: (Pollution pollution, _) => pollution.quantity,
  //       id: '2017',
  //       data: data1,
  //       fillPatternFn: (_, __) => charts.FillPatternType.solid,
  //       fillColorFn: (Pollution pollution, _) =>
  //           charts.ColorUtil.fromDartColor(Color(0xff990099)),
  //     ),
  //   );
  //
  //   _seriesData.add(
  //     charts.Series(
  //       domainFn: (Pollution pollution, _) => pollution.place,
  //       measureFn: (Pollution pollution, _) => pollution.quantity,
  //       id: '2018',
  //       data: data2,
  //       fillPatternFn: (_, __) => charts.FillPatternType.solid,
  //       fillColorFn: (Pollution pollution, _) =>
  //           charts.ColorUtil.fromDartColor(Color(0xff109618)),
  //     ),
  //   );
  //
  //   _seriesData.add(
  //     charts.Series(
  //       domainFn: (Pollution pollution, _) => pollution.place,
  //       measureFn: (Pollution pollution, _) => pollution.quantity,
  //       id: '2019',
  //       data: data3,
  //       fillPatternFn: (_, __) => charts.FillPatternType.solid,
  //       fillColorFn: (Pollution pollution, _) =>
  //           charts.ColorUtil.fromDartColor(const Color(0xffff9900)),
  //     ),
  //   );
  //
  //   _seriesPieData.add(
  //     charts.Series(
  //       domainFn: (Task task, _) => task.task,
  //       measureFn: (Task task, _) => task.taskvalue,
  //       colorFn: (Task task, _) =>
  //           charts.ColorUtil.fromDartColor(task.colorval),
  //       id: 'Air Pollution',
  //       data: piedata,
  //       labelAccessorFn: (Task row, _) => '${row.taskvalue}',
  //     ),
  //   );
  //
  //   _seriesLineData.add(
  //     charts.Series(
  //       colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff990099)),
  //       id: 'Air Pollution',
  //       data: linesalesdata,
  //       domainFn: (Sales sales, _) => sales.yearval,
  //       measureFn: (Sales sales, _) => sales.salesval,
  //     ),
  //   );
  //   _seriesLineData.add(
  //     charts.Series(
  //       colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff109618)),
  //       id: 'Air Pollution',
  //       data: linesalesdata1,
  //       domainFn: (Sales sales, _) => sales.yearval,
  //       measureFn: (Sales sales, _) => sales.salesval,
  //     ),
  //   );
  //   _seriesLineData.add(
  //     charts.Series(
  //       colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xffff9900)),
  //       id: 'Air Pollution',
  //       data: linesalesdata2,
  //       domainFn: (Sales sales, _) => sales.yearval,
  //       measureFn: (Sales sales, _) => sales.salesval,
  //     ),
  //   );
  // }

  @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   _seriesData = List<charts.Series<Pollution, String>>();
  //   _seriesPieData = List<charts.Series<Task, String>>();
  //   _seriesLineData = List<charts.Series<Sales, int>>();
  //   _generateData();
  // }

  @override
  Widget build(BuildContext context) {
    return SizedBox();
    // return MaterialApp(
    //   home: DefaultTabController(
    //     length: 3,
    //     child: Scaffold(
    //       appBar: AppBar(
    //         backgroundColor: Color(0xff1976d2),
    //         //backgroundColor: Color(0xff308e1c),
    //         bottom: const TabBar(
    //           indicatorColor: Color(0xff9962D0),
    //           tabs: [
    //             Tab(
    //               icon: Icon(FontAwesomeIcons.solidChartBar),
    //             ),
    //             Tab(icon: Icon(FontAwesomeIcons.chartPie)),
    //             Tab(icon: Icon(FontAwesomeIcons.chartLine)),
    //           ],
    //         ),
    //         title: Text('Flutter Charts'),
    //       ),
    //       body: TabBarView(
    //         children: [
    //           Padding(
    //             padding: EdgeInsets.all(8.0),
    //             child: Center(
    //               child: Column(
    //                 children: <Widget>[
    //                   Text(
    //                     'SO₂ emissions, by world region (in million tonnes)',style: TextStyle(fontSize: 24.0,fontWeight: FontWeight.bold),),
    //                   Expanded(
    //                     child: charts.BarChart(
    //                       _seriesData,
    //                       animate: true,
    //                       barGroupingType: charts.BarGroupingType.grouped,
    //                       //behaviors: [new charts.SeriesLegend()],
    //                       animationDuration: const Duration(seconds: 5),
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ),
    //           Padding(
    //             padding: EdgeInsets.all(8.0),
    //             child: Container(
    //               child: Center(
    //                 child: Column(
    //                   children: <Widget>[
    //                     Text(
    //                       'Time spent on daily tasks',style: TextStyle(fontSize: 24.0,fontWeight: FontWeight.bold),),
    //                     SizedBox(height: 10.0,),
    //                     Expanded(
    //                       child: charts.PieChart(
    //                           _seriesPieData,
    //                           animate: true,
    //                           animationDuration: Duration(seconds: 5),
    //                           behaviors: [
    //                             charts.DatumLegend(
    //                               outsideJustification: charts.OutsideJustification.endDrawArea,
    //                               horizontalFirst: false,
    //                               desiredMaxRows: 2,
    //                               cellPadding: const EdgeInsets.only(right: 4.0, bottom: 4.0),
    //                               entryTextStyle: charts.TextStyleSpec(
    //                                   color: charts.MaterialPalette.purple.shadeDefault,
    //                                   fontFamily: 'Georgia',
    //                                   fontSize: 11),
    //                             )
    //                           ],
    //                           defaultRenderer: new charts.ArcRendererConfig(
    //                               arcWidth: 100,
    //                               arcRendererDecorators: [
    //                                 new charts.ArcLabelDecorator(
    //                                     labelPosition: charts.ArcLabelPosition.inside)
    //                               ])),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             ),
    //           ),
    //           Padding(
    //             padding: EdgeInsets.all(8.0),
    //             child: Container(
    //               child: Center(
    //                 child: Column(
    //                   children: <Widget>[
    //                     Text(
    //                       'Sales for the first 5 years',style: TextStyle(fontSize: 24.0,fontWeight: FontWeight.bold),),
    //                     Expanded(
    //                       child: charts.LineChart(
    //                           _seriesLineData,
    //                           defaultRenderer: new charts.LineRendererConfig(
    //                               includeArea: true, stacked: true),
    //                           animate: true,
    //                           animationDuration: Duration(seconds: 5),
    //                           behaviors: [
    //                             new charts.ChartTitle('Years',
    //                                 behaviorPosition: charts.BehaviorPosition.bottom,
    //                                 titleOutsideJustification:charts.OutsideJustification.middleDrawArea),
    //                             new charts.ChartTitle('Sales',
    //                                 behaviorPosition: charts.BehaviorPosition.start,
    //                                 titleOutsideJustification: charts.OutsideJustification.middleDrawArea),
    //                             new charts.ChartTitle('Departments',
    //                               behaviorPosition: charts.BehaviorPosition.end,
    //                               titleOutsideJustification:charts.OutsideJustification.middleDrawArea,
    //                             )
    //                           ]
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}

class Pollution {
  String place;
  int year;
  int quantity;

  Pollution(this.year, this.place, this.quantity);
}

class Task {
  String task;
  double taskvalue;
  Color colorval;

  Task(this.task, this.taskvalue, this.colorval);
}

class Sales {
  int yearval;
  int salesval;

  Sales(this.yearval, this.salesval);
}