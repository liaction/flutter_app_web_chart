import 'package:flutter/material.dart';
import 'ymwy_chart.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final title = "Webview & Chart";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: title),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<List<YMWYChartData>> chartDataList = List();

  @override
  void initState() {
    initTestData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final everyHeight = size.height / 2.0;
    final everyWidth = size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: ListView(
        children: chartDataList.map((chartData) {
          return Container(
            height: everyHeight,
            width: everyWidth,
            child: YMWYChart(
              chartData: chartData,
            ),
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'refresh',
        child: Icon(Icons.refresh),
      ),
    );
  }

  void initTestData() {
    for (int index = 0; index < 5; index++) {
      chartDataList.add(List());
    }
  }
}
