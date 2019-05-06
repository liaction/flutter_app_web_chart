import 'dart:convert';
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
  InAppWebViewController appWebViewController;
  YMWYWebChartBean webChartBean;

  void resolveData() {
    if (null == appWebViewController) {
      return;
    }
    List<String> legend = List<String>();
    List<String> xAxis = List<String>();
    bool line = false;
    bool haveData = false;
    List<List<String>> dataList = List();
    if (null != widget.chartData && widget.chartData.isNotEmpty) {
      haveData = true;
      var chartData = widget.chartData.first;
      line = chartData.chartType == YMWYChartType.LINE;
      bool showTipLabel = chartData.showTipChart;
      xAxis.addAll(chartData.children.map((data) => data.xLabel));
      for (var index = 0; index < widget.chartData.length; ++index) {
        var cd = widget.chartData[index];
        if (showTipLabel) {
          legend.add(cd.charDataLabel);
        }
        var d = cd.children.map((data) => "${data.yValue}").toList();
        dataList.add(d);
      }
    } else {
      haveData = false;
    }
    webChartBean = YMWYWebChartBean(
      line: line,
      xAxis: xAxis,
      legend: legend,
      dataList: dataList,
      haveData: haveData,
    );
    var scriptCode = """
      ymwyChart($webChartBean);
    """;
    appWebViewController?.injectScriptCode(scriptCode);
  }

  @override
  void didUpdateWidget(YMWYChart oldWidget) {
    resolveData();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Color(0xFF161816),
      ),
      child: SizedBox.expand(
        child: InAppWebView(
          initialFile: "assets/html/chart.html",
          onWebViewCreated: (c) {
            appWebViewController = c;
          },
          onConsoleMessage: (c, message) {
            debugPrint("${message.message}");
          },
          onLoadStop: (c, u) {
            resolveData();
          },
        ),
      ),
    );
  }
}

class YMWYWebChartBean {
  final List<String> legend;
  final List<String> xAxis;
  final bool line;
  final List dataList;
  final bool haveData;

  YMWYWebChartBean(
      {this.legend, this.xAxis, this.line, this.dataList, this.haveData});

  @override
  String toString() {
    return """{
    legend:${jsonEncode(legend)},
    xAxis:${jsonEncode(xAxis)},
    line:${jsonEncode(line)},
    dataList:${jsonEncode(dataList)},
    haveData:${jsonEncode(haveData)}
    }""";
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

  @override
  String toString() {
    return super.toString();
  }
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

const YMWYNumberLabel = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '%'];

class YMWYChartPainter extends CustomPainter {
  final double bottomMargin = 40;
  final double topMargin = 20;
  final double leftMargin = 20;
  final double rightMargin = 10;
  final double jianTouLength = 5;
  final double everyMargin = 5;
  double tipWidth = 100;
  List<YMWYPair<double, double>> pairList = List();

  ///
  /// 线的类型,只取第一个元素的,后面的元素会忽略
  ///
  final List<YMWYChartData> chartDatas;

  final YMWYPointerBean pointerBean;

  // 默认没有
  int currentUpTipIndex = -1;

  YMWYChartPainter(this.chartDatas, this.pointerBean);

  int checkIfCanUpdate(Offset position) {
    for (var index = 0; index < pairList.length; ++index) {
      var data = pairList[index];
      if (position.dx > data.first && position.dx < data.second) {
        currentUpTipIndex = index;
        break;
      }
    }
    return currentUpTipIndex;
  }

  @override
  void paint(Canvas canvas, Size size) {
    // y轴
    drawYAxis(canvas, size);
    // x轴
    drawXAxis(canvas, size);

    // 画完坐标轴后,开始处理数据
    if (null == chartDatas || chartDatas.isEmpty) {
      // 数据无效,不干了
      return;
    }

    // 移除无效的数据
    chartDatas.removeWhere((data) =>
        data == null || data.children == null || data.children.isEmpty);

    // 剩下的数据都是有数据的,紧接着,处理长度问题,取长度最小值,为啥?你说为啥?继续往下看,别捣乱
    var goodCharDataLengthList =
        chartDatas.map((data) => data.children.length).toList();
    // 排个序,最小的在第一位
    goodCharDataLengthList.sort();
    // 把最小的长度取出
    var validLength = goodCharDataLengthList.first;
    // 只取有效长度值
    for (var charData in chartDatas) {
      // 移除过长的数据
      charData.children.removeRange(validLength, charData.children.length);
    }

    // 从这里开始❀
    var startX = leftMargin + everyMargin * 4;
    var startY = bottomMargin;
    // 总共能❀多长呢?
    var xWidth = size.width -
        startX -
        rightMargin -
        (chartDatas.first.showTipChart ? tipWidth : 0);
    var yHeight = size.height - startY - topMargin;

    // 总共多少份?
    var xCount = validLength;
    // 每一份多长呢?
    var xEveryWidth = 1.0 * xWidth / xCount;

    // y轴最大数据
    var valueList = chartDatas
        .expand((data) => data.children)
        .toList()
        .map((data) => data.yValue)
        .toList();
    valueList.sort();
    double maxValue = valueList.last * 1.4;
    // 别忘了0的问题
    double yEveryHeight = maxValue == 0 ? 0 : yHeight / maxValue;

    // ❀ tip , 明确要求的时候再画,否则不予理会
    if (chartDatas.first.showTipChart) {
      drawTip(canvas, size, chartDatas.first.chartType == YMWYChartType.LINE);
    }
    pairList.clear();
    if (chartDatas.first.chartType == YMWYChartType.LINE) {
      drawLine(canvas, size, startX, xEveryWidth, yEveryHeight, startY);
      return;
    }
    drawRect(canvas, size, startX, xEveryWidth, yEveryHeight, startY);
  }

  void drawTip(Canvas canvas, Size size, bool line) {
    // x
    double dx = size.width - rightMargin - tipWidth;
    double everyHeight = line ? 10 : 15.0;
    double everyWidth = 20.0;
    double fixValue = 5.0;
    // 色块的宽
    double everyRectTipWidth = everyWidth - fixValue;
    // 色块的高
    double everyRectTipHeight = everyHeight - fixValue;
    // 文字大小
    double fontSize = 10.0;
    // 如果文字过长,会换行的,此时,就要相应把下一个色块坐标下移,要不然就会看到重叠的情况
    double fixYValue = 0.0;
    for (var index = 0; index < chartDatas.length; ++index) {
      var charData = chartDatas[index];
      // 标识文字,信息无效的话,就没有必要❀,直接下一位
      if (null == charData.tipLabel ||
          null == charData.tipLabel.label ||
          charData.tipLabel.label.isEmpty) {
        continue;
      }
      // 标识色块
      double left = dx;
      double labelEveryLineWidth = tipWidth - everyRectTipWidth;

      var paragraphBuilder = ui.ParagraphBuilder(
        ui.ParagraphStyle(
          fontSize: fontSize,
        ),
      )
        ..addText(charData.tipLabel.label)
        ..pushStyle(ui.TextStyle(
          color: Colors.white,
        ));
      var paragraph = paragraphBuilder.build()
        ..layout(
          ui.ParagraphConstraints(
            width: labelEveryLineWidth,
          ),
        );
      if (index != 0) {
        // 获取文字
        String label = chartDatas[index - 1].tipLabel.label;
        if (label.isNotEmpty) {
          var paragraphBuilder = ui.ParagraphBuilder(
            ui.ParagraphStyle(
              fontSize: fontSize,
            ),
          )
            ..addText(label)
            ..pushStyle(ui.TextStyle(
              color: Colors.white,
            ));
          var paragraph = paragraphBuilder.build()
            ..layout(
              ui.ParagraphConstraints(
                width: labelEveryLineWidth,
              ),
            );
          fixYValue += paragraph.height;
        }
      }
      double top = topMargin + everyHeight * index + fixYValue;
      canvas.drawRect(
          Rect.fromLTWH(left, top, everyRectTipWidth, everyRectTipHeight),
          Paint()..color = charData.color);
      canvas.drawParagraph(
        paragraph,
        Offset(left + everyRectTipWidth + fixValue, top),
      );
    }
  }

  void drawRect(Canvas canvas, Size size, double startX, double xEveryWidth,
      double yEveryHeight, double startY) {
    // 每一个item长度
    double everyWidth = (xEveryWidth - everyMargin) / chartDatas.length;
    everyWidth = min(everyWidth, 60.0);
    xEveryWidth = everyWidth * chartDatas.length + everyMargin;
    for (var index = 0; index < chartDatas.length; ++index) {
      var charData = chartDatas[index];
      for (var childIndex = 0;
          childIndex < charData.children.length;
          ++childIndex) {
        var startInnerX =
            startX + xEveryWidth * childIndex + everyWidth * index;
        YMWYChartItemData chartItemData = charData.children[childIndex];

        // 绘制 rect
        double pHeight = yEveryHeight * chartItemData.yValue;
        double startYInner = size.height - startY - pHeight;
        canvas.drawRect(
            Rect.fromLTWH(startInnerX, startYInner, everyWidth, pHeight),
            Paint()
              ..color = charData.color
              ..strokeWidth = 2
              ..strokeJoin = StrokeJoin.round);

        if (chartItemData.show) {
          double fontSize = 20.0 - chartDatas.length * 5.0;
          double fixYValue = 0.0;
          // 获取文字
          String label = chartItemData.yLabel;
          // 绘制y值
          var paragraphBuilder = ui.ParagraphBuilder(
            ui.ParagraphStyle(
              fontSize: fontSize,
              textAlign: TextAlign.center,
            ),
          )
            ..addText(label)
            ..pushStyle(ui.TextStyle(
              color: Colors.white,
            ));
          var paragraph = paragraphBuilder.build()
            ..layout(
              ui.ParagraphConstraints(
                width: everyWidth,
              ),
            );
          if (label.isNotEmpty) {
            fixYValue = paragraph.height;
          }
          canvas.drawParagraph(
            paragraph,
            Offset(startInnerX, max(startYInner - fixYValue, topMargin)),
          );
        }
        // ❀x轴坐标文字,绘制一次即可,
        if (index == 0) {
          double dx = startX + xEveryWidth * childIndex + xEveryWidth / 2;
          Offset offsetStart = Offset(dx, size.height - bottomMargin);
          Offset offsetEd = Offset(dx, size.height - bottomMargin - 2);
          // ❀坐标指示
          canvas.drawLine(
              offsetStart,
              offsetEd,
              Paint()
                ..color = Colors.white
                ..strokeWidth = 2);
          var paragraphBuilder = ui.ParagraphBuilder(
            ui.ParagraphStyle(
              fontSize: 10.0,
              textAlign: TextAlign.center,
            ),
          )
            ..addText(chartItemData.xLabel)
            ..pushStyle(ui.TextStyle(
              color: Colors.white,
            ));
          double start = offsetStart.dx - xEveryWidth / 2.0;
          canvas.drawParagraph(
            paragraphBuilder.build()
              ..layout(
                ui.ParagraphConstraints(
                  width: xEveryWidth,
                ),
              ),
            Offset(start, offsetStart.dy + 5),
          );
        }
      }
    }
    for (var index = 0; index < chartDatas.length; ++index) {
      var charData = chartDatas[index];
      for (var childIndex = 0;
          childIndex < charData.children.length;
          ++childIndex) {
        if (index == 0) {
          double dx = startX + xEveryWidth * childIndex + xEveryWidth / 2;
          Offset offsetStart = Offset(dx, size.height - bottomMargin);
          double start = offsetStart.dx - xEveryWidth / 2.0;
          drawEventTip(
              canvas, size, start, dx, start + xEveryWidth, childIndex);
        }
      }
    }
  }

  void drawEventTip(Canvas canvas, Size size, double start, double center,
      double end, int index) {
    pairList.add(YMWYPair(start, end));
//    ymwyLog("进行 event tip >>> center : $center , index : $index");
    if (pointerBean.up) {
      currentUpTipIndex = -1;
      return;
    }
    Offset position = pointerBean.position;
    if (null == position) {
      return;
    }
    if (!(position.dx > start && position.dx < end)) {
      return;
    }
    currentUpTipIndex = index;
    canvas.drawLine(
        Offset(center, 0),
        Offset(center, size.height - bottomMargin),
        Paint()
          ..color = Colors.grey
          ..style = PaintingStyle.stroke);
    bool showTipChart = chartDatas.first.showTipChart;
    double width =
        size.width - leftMargin - rightMargin - (showTipChart ? tipWidth : 0);
    double height = size.height - topMargin - bottomMargin;
    Paint paint = Paint()..color = Color.fromARGB(123, 0, 0, 0);
    canvas.drawRect(Rect.fromLTWH(leftMargin, topMargin, width, height), paint);
    // 获取 index 数值
    var resultData = chartDatas
        .map((data) => {
              "label": data.charDataLabel.isEmpty
                  ? data.tipLabel?.label ?? ""
                  : data.charDataLabel ?? "",
              "item": data.children[index]
            })
        .toList();
    StringBuffer text = StringBuffer();
    for (var tipIndex = 0; tipIndex < resultData.length; ++tipIndex) {
      var data = resultData[tipIndex];

      YMWYChartItemData chartItemData = data['item'];
      text.writeln(
          "${data['label']}  ${chartItemData.yLabel.isEmpty ? chartItemData.yValue : chartItemData.yLabel}");
    }
    TextPainter textPainter = TextPainter(
      text: TextSpan(
        style: TextStyle(
          color: Colors.blueGrey,
          fontSize: 10.0,
        ),
        children: [
          TextSpan(
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
            ),
            text:
                "[${(resultData.first['item'] as YMWYChartItemData).xLabel}详情]\n",
          ),
          TextSpan(
            text: text.toString(),
          )
        ],
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    textPainter
      ..layout(
        maxWidth: width,
        minWidth: width,
      );
    Offset offset = Offset(leftMargin + everyMargin, topMargin + 20);
    textPainter.paint(canvas, offset);
  }

  void drawLine(Canvas canvas, Size size, double startX, double xEveryWidth,
      double yEveryHeight, double startY) {
    for (var index = 0; index < chartDatas.length; ++index) {
      var charData = chartDatas[index];
      for (var childIndex = 0;
          childIndex < charData.children.length;
          ++childIndex) {
        double dx = startX + xEveryWidth * (childIndex);
        YMWYChartItemData chartItemData = charData.children[childIndex];
        Offset offsetStart = Offset(dx, size.height - bottomMargin);
        Offset offsetEd = Offset(dx, size.height - bottomMargin - 2);

        // 绘制line
        double pStartY = yEveryHeight * chartItemData.yValue;
        double pStartYResult;
        YMWYChartData ymwyChartData = chartDatas.first;
        if (ymwyChartData.up) {
          pStartYResult = pStartY + topMargin;
        } else {
          pStartYResult = size.height - bottomMargin - pStartY;
        }
        Offset pStart = Offset(offsetStart.dx, pStartYResult);
        if (childIndex != charData.children.length - 1) {
          YMWYChartItemData pEdItem = charData.children[childIndex + 1];
          double pEdY = yEveryHeight * pEdItem.yValue;
          double pEdYResult;
          if (ymwyChartData.up) {
            pEdYResult = pEdY + topMargin;
          } else {
            pEdYResult = size.height - bottomMargin - pEdY;
          }
          Offset pEd = Offset(dx + xEveryWidth, pEdYResult);
          canvas.drawLine(
              pStart,
              pEd,
              Paint()
                ..color = charData.color
                ..strokeWidth = 2
                ..strokeJoin = StrokeJoin.round
                ..strokeCap = StrokeCap.round);
        }

        // 绘制y值
        if (chartItemData.show) {
          double fixYValue = 0.0;
          // 获取文字
          String label = chartItemData.yLabel;

          var paragraphBuilder = ui.ParagraphBuilder(
            ui.ParagraphStyle(
              fontSize: 10.0,
              textAlign: TextAlign.center,
            ),
          )
            ..addText(label)
            ..pushStyle(ui.TextStyle(
              color: Colors.white,
            ));
          var paragraph = paragraphBuilder.build()
            ..layout(
              ui.ParagraphConstraints(
                width: xEveryWidth,
              ),
            );
          if (label.isNotEmpty) {
            fixYValue = paragraph.height;
          }
          canvas.drawParagraph(
            paragraph,
            Offset(offsetStart.dx - xEveryWidth / 2.0,
                max(pStart.dy - fixYValue, topMargin)),
          );
        }

        // ❀x轴坐标文字,绘制一次即可,
        if (index == 0) {
          // ❀坐标指示
          canvas.drawLine(
              offsetStart,
              offsetEd,
              Paint()
                ..color = Colors.white
                ..strokeWidth = 2);
          var paragraphBuilder = ui.ParagraphBuilder(
            ui.ParagraphStyle(
              fontSize: 10.0,
              textAlign: TextAlign.center,
            ),
          )
            ..addText(chartItemData.xLabel)
            ..pushStyle(ui.TextStyle(
              color: Colors.white,
            ));
          double start = offsetStart.dx - xEveryWidth / 2.0;
          canvas.drawParagraph(
            paragraphBuilder.build()
              ..layout(
                ui.ParagraphConstraints(
                  width: xEveryWidth,
                ),
              ),
            Offset(start, offsetStart.dy + 5),
          );
          drawEventTip(canvas, size, start, offsetStart.dx, start + xEveryWidth,
              childIndex);
        }
      }
    }
    for (var index = 0; index < chartDatas.length; ++index) {
      var charData = chartDatas[index];
      for (var childIndex = 0;
          childIndex < charData.children.length;
          ++childIndex) {
        double dx = startX + xEveryWidth * (childIndex);
        Offset offsetStart = Offset(dx, size.height - bottomMargin);
        if (index == 0) {
          double start = offsetStart.dx - xEveryWidth / 2.0;
          drawEventTip(canvas, size, start, offsetStart.dx, start + xEveryWidth,
              childIndex);
        }
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  void drawYAxis(Canvas canvas, Size size) {
    canvas.drawLine(
      Offset(leftMargin, topMargin),
      Offset(leftMargin, size.height - bottomMargin),
      Paint()
        ..color = Colors.white
        ..isAntiAlias = true,
    );
    canvas.drawLine(
      Offset(leftMargin, topMargin),
      Offset(leftMargin - jianTouLength, topMargin + jianTouLength),
      Paint()
        ..color = Colors.white
        ..isAntiAlias = true,
    );
    canvas.drawLine(
      Offset(leftMargin, topMargin),
      Offset(leftMargin + jianTouLength, topMargin + jianTouLength),
      Paint()
        ..color = Colors.white
        ..isAntiAlias = true,
    );
    // Y Label
    if (chartDatas != null && chartDatas.isNotEmpty) {
      var paragraphBuilder4YLabel = ui.ParagraphBuilder(
        ui.ParagraphStyle(
          fontSize: 10.0,
        ),
      )
        ..addText(chartDatas.first.yChartLabel)
        ..pushStyle(ui.TextStyle(
          color: Colors.white,
        ));
      canvas.drawParagraph(
        paragraphBuilder4YLabel.build()
          ..layout(
            ui.ParagraphConstraints(
              width: 10,
            ),
          ),
        Offset(0, topMargin),
      );
    }
  }

  void drawXAxis(Canvas canvas, Size size) {
    bool removeTipWidth = chartDatas == null ||
        chartDatas.isEmpty ||
        !chartDatas.first.showTipChart;
    double fixTipWidth = removeTipWidth ? 0.0 : tipWidth;
    canvas.drawLine(
      Offset(leftMargin, size.height - bottomMargin),
      Offset(
          size.width - rightMargin - fixTipWidth, size.height - bottomMargin),
      Paint()
        ..color = Colors.white
        ..isAntiAlias = true,
    );
    canvas.drawLine(
      Offset(size.width - rightMargin - jianTouLength - fixTipWidth,
          size.height - bottomMargin - jianTouLength),
      Offset(
          size.width - rightMargin - fixTipWidth, size.height - bottomMargin),
      Paint()
        ..color = Colors.white
        ..isAntiAlias = true,
    );
    canvas.drawLine(
      Offset(size.width - rightMargin - jianTouLength - fixTipWidth,
          size.height - bottomMargin + jianTouLength),
      Offset(
          size.width - rightMargin - fixTipWidth, size.height - bottomMargin),
      Paint()
        ..color = Colors.white
        ..isAntiAlias = true,
    );
  }
}

///
/// Flutter chart 暂时不使用,有兴趣的话,请自行研究
///
class YMWYFlutterChart extends StatefulWidget {
  final Size size;
  final List<YMWYChartData> chartData;

  YMWYFlutterChart({Key key, this.size = Size.zero, this.chartData})
      : super(key: key);

  @override
  _YMWYFlutterChartState createState() => _YMWYFlutterChartState();
}

class _YMWYFlutterChartState extends State<YMWYFlutterChart> {
  YMWYPointerBean pointerBean = YMWYPointerBean();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF161816),
      ),
      child: SizedBox.expand(
        child: Listener(
          onPointerDown: onPointerDown,
          onPointerMove: onPointerMove,
          onPointerUp: onPointerUp,
          child: CustomPaint(
            painter: YMWYChartPainter(
              widget.chartData,
              pointerBean,
            ),
          ),
        ),
      ),
    );
  }

  void onPointerDown(PointerDownEvent event) {
    RenderBox renderBox = context.findRenderObject();
    Offset offsetLocal = renderBox.globalToLocal(event.position);
    setState(() {
      pointerBean
        ..position = offsetLocal
        ..up = false;
    });
  }

  void onPointerMove(PointerMoveEvent event) {
    RenderBox renderBox = context.findRenderObject();
    Offset offsetLocal = renderBox.globalToLocal(event.position);
    setState(() {
      pointerBean
        ..position = offsetLocal
        ..up = false;
    });
  }

  void onPointerUp(PointerUpEvent event) {
    RenderBox renderBox = context.findRenderObject();
    Offset offsetLocal = renderBox.globalToLocal(event.position);
    setState(() {
      pointerBean
        ..position = offsetLocal
        ..up = true;
    });
  }
}
