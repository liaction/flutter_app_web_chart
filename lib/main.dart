import 'package:flutter/material.dart';

import 'ymwy_chart.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final title = "Chart";

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
        actions: <Widget>[
          IconButton(icon: Icon(Icons.refresh), onPressed: (){
            initTestData(reset: true);
            setState(() {
            });
          }),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: chartDataList.map((chartData) {
            return Container(
              height: everyHeight,
              width: everyWidth,
              margin: const EdgeInsets.all(5),
              child: YMWYChart(
                chartData: chartData,
              ),
            );
          }).toList(),
        ),
      ),
//      floatingActionButton: FloatingActionButton(
//        onPressed: () {
//          initTestData();
//          setState(() {});
//        },
//        tooltip: 'add',
//        child: Icon(Icons.add),
//      ),
    );
  }
  bool change = false;
  void initTestData({bool reset = false}) {
    chartDataList.clear();
    change = !change;
    for (int index = 0; index < 6; index++) {
      chartDataList.add([
        YMWYChartData(
            children: [
              YMWYChartItemData(
                  xValue: 1.0, yValue: 3, xLabel: "01月", yLabel: "第三"),
              YMWYChartItemData(
                  xValue: 2.0, yValue: 0, xLabel: "02月", yLabel: "无"),
              YMWYChartItemData(
                  xValue: 3.0, yValue: 16, xLabel: "03月", yLabel: "第十六"),
              YMWYChartItemData(
                  xValue: 4.0, yValue: 12, xLabel: "04月", yLabel: "第十二"),
              YMWYChartItemData(
                  xValue: 1.0, yValue: 5, xLabel: "05月", yLabel: "第五"),
              YMWYChartItemData(
                  xValue: 2.0, yValue: 2, xLabel: "06月", yLabel: "第二"),
              YMWYChartItemData(
                  xValue: 3.0, yValue: 11, xLabel: "07月", yLabel: "第十一"),
              YMWYChartItemData(
                  xValue: 4.0, yValue: 14, xLabel: "08月", yLabel: "第十四"),
              YMWYChartItemData(
                  xValue: 1.0, yValue: 0, xLabel: "09月", yLabel: "无"),
              YMWYChartItemData(
                  xValue: 2.0, yValue: 0, xLabel: "10月", yLabel: "无"),
              YMWYChartItemData(
                  xValue: 3.0, yValue: 18, xLabel: "11月", yLabel: "第十八"),
              YMWYChartItemData(
                  xValue: 4.0, yValue: 22, xLabel: "12月", yLabel: "第二十二"),
            ],
            tipLabel: YMWYChartTipData(label: "西北五省其它"),
            yChartLabel: "排名",
            charDataLabel: "西北五省其它",
            chartType: chartDataList.length.isEven ? YMWYChartType.REACT : YMWYChartType.LINE,
            color: Colors.red,
            showTipChart: change),
        YMWYChartData(
          children: [
            YMWYChartItemData(
                xValue: 1.0, yValue: 20, xLabel: "01月", yLabel: "第二十"),
            YMWYChartItemData(
                xValue: 1.0, yValue: 3, xLabel: "02月", yLabel: "第三"),
            YMWYChartItemData(
                xValue: 2.0, yValue: 10, xLabel: "03月", yLabel: "第十"),
            YMWYChartItemData(
                xValue: 3.0, yValue: 15, xLabel: "12月", yLabel: "第十五"),
            YMWYChartItemData(
                xValue: 1.0, yValue: 0, xLabel: "01月", yLabel: "无"),
            YMWYChartItemData(
                xValue: 1.0, yValue: 3, xLabel: "02月", yLabel: "第三"),
            YMWYChartItemData(
                xValue: 2.0, yValue: 0, xLabel: "03月", yLabel: "无"),
            YMWYChartItemData(
                xValue: 3.0, yValue: 11, xLabel: "12月", yLabel: "第十一"),
            YMWYChartItemData(
                xValue: 1.0, yValue: 10, xLabel: "01月", yLabel: "第十"),
            YMWYChartItemData(
                xValue: 1.0, yValue: 3, xLabel: "02月", yLabel: "第三"),
            YMWYChartItemData(
                xValue: 2.0, yValue: 10, xLabel: "03月", yLabel: "第十"),
            YMWYChartItemData(
                xValue: 3.0, yValue: 1, xLabel: "12月", yLabel: "第一"),
          ],
          tipLabel: YMWYChartTipData(label: "其它省份ymwy还是很长很长"),
          yChartLabel: "排名",
          charDataLabel: "其它省份",
          chartType: YMWYChartType.LINE,
          color: Colors.green,
          up: true,
        ),
      ]);
    }
  }
}
