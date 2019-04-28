import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_inappbrowser/flutter_inappbrowser.dart';
///
/// 为新疆三级界面图表定制版本,不保证全局通用性,如有需要,请自行处理
/// CHEN.SI LIACTION USTCSOFT
///
///
class YMWYChart extends StatefulWidget {
  final List<YMWYChartData> chartData;

  YMWYChart({Key key, this.chartData}) : super(key: key);

  @override
  _YMWYChartState createState() => _YMWYChartState();
}

class _YMWYChartState extends State<YMWYChart> {

  InAppWebViewController inAppWebViewController;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Color(0xFF161816),
      ),
      child: SizedBox.expand(
        child: InAppWebView(
          onWebViewCreated: (c){
            inAppWebViewController = c;
          },
        ),
      ),
    );
  }
}

class YMWYPointerBean {
  Offset position;
  bool up;

  YMWYPointerBean({this.position, this.up = true});

  @override
  String toString() {
    return "[position : $position , up : $up]";
  }
}

const YMWYNumberLabel = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '%'];

class YMWYChartData {
  List<YMWYChartItemData> children;
  YMWYChartTipData tipLabel;
  String xChartLabel;
  String yChartLabel;
  bool showXChartLabel;
  bool showYChartLabel;
  bool showTipChart;
  YMWYChartType chartType;
  String chartTitle;
  YMWYAlignment titleAlignment;
  Decoration decoration;
  EdgeInsetsGeometry padding;
  EdgeInsetsGeometry margin;
  Color color;
  bool up;
  String charDataLabel;

  YMWYChartData(
      {this.children = const [],
      this.tipLabel,
      this.xChartLabel = "",
      this.yChartLabel = "",
      this.showXChartLabel = true,
      this.showYChartLabel = true,
      this.showTipChart = false,
      this.chartType = YMWYChartType.LINE,
      this.titleAlignment = YMWYAlignment.start,
      this.decoration = const BoxDecoration(
        color: Color(0xFF161816),
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      this.padding = const EdgeInsets.all(4.0),
      this.margin = const EdgeInsets.all(4.0),
      this.chartTitle = "",
      this.color = Colors.blue,
      this.up = true,
      this.charDataLabel = ""});
}

enum YMWYChartType { LINE, REACT }

enum YMWYAlignment { start, end, center }

class YMWYChartTipData {
  String label;
  Color color;
  YMWYChartType chartType;

  YMWYChartTipData(
      {this.label = "",
      this.color = Colors.blue,
      this.chartType = YMWYChartType.LINE});
}

class YMWYChartItemData {
  double xValue;
  double yValue;

  String xLabel;

  String yLabel;

  bool show;

  Color color;

  YMWYChartItemData(
      {this.xValue = 0.0,
      this.yValue = 0.0,
      this.xLabel = "",
      this.yLabel = "",
      this.show = true,
      this.color = Colors.blue});
}

class YMWYPair<E, F> {
  E first;
  F second;

  YMWYPair(this.first, this.second);
}

var colors = [
  Color(0xFF9127ae),
  Color(0xFF376AFF),
  Color(0xFFff5a00),
  Color(0xFF61a0a8),
  Color(0xFFd48265),
  Color(0xFF91c7ae),
  Color(0xFF2f4554),
  Color(0xFF749f83),
  Color(0xFFca8622),
  Color(0xFFFF68D6),
  Color(0xFFc2353),
  Color(0xFF5EFFAA),
];
