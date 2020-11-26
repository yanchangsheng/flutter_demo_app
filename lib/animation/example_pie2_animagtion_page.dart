import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test_app/tk/demo6/config/colors.dart';

/// 创建人： Created by zhaolong
/// 创建时间：Created by  on 2020/11/24.
///
/// 可关注公众号：我的大前端生涯   获取最新技术分享
/// 可关注网易云课堂：https://study.163.com/instructor/1021406098.htm
/// 可关注博客：https://blog.csdn.net/zl18603543572
/// 西瓜视频 https://www.ixigua.com/home/3662978423
/// 知乎 https://www.zhihu.com/people/zhao-long-90-89
///
///代码清单
///程序入口
void main() {
  //启动根目录
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TestPieAnimationPage(),
    ),
  );
}

//定义一个全局的内容主颜色
Color mainColor = Color(0xFFCADCED);

///默认显示的首页面
class TestPieAnimationPage extends StatefulWidget {
  @override
  _TestPieAnimationPageState createState() => _TestPieAnimationPageState();
}

class _TestPieAnimationPageState extends State<TestPieAnimationPage>
    with SingleTickerProviderStateMixin {
  //来个动画控制器
  AnimationController _animationController;

  //控制背景抬高使用的
  Animation<double> _bgAnimation;

  //控制饼图使用的
  Animation<double> _progressAnimation;

  //控制数字使用的
  Animation<double> _numberAnimation;

  @override
  void initState() {
    super.initState();

    //初始化一下
    _animationController = new AnimationController(
        //执行时间为 1 秒
        duration: Duration(milliseconds: 1000),
        vsync: this);

    //在 0~500毫秒内 执行背景阴影抬高的操作
    _bgAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        //执行时间 区间
        curve: Interval(0.0, 0.5, curve: Curves.bounceOut),
      ),
    );

    //在 400 ~ 800 毫秒的区间内执行画饼的操作动画
    _progressAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        //执行时间 区间
        curve: Interval(0.4, 0.8, curve: Curves.bounceOut),
      ),
    );

    //在 700 ~ 1000 毫秒的区间 执行最上层的数字抬高的操作动画
    _numberAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        //执行时间 区间
        curve: Interval(0.7, 1.0, curve: Curves.bounceOut),
      ),
    );

    //添加 一个监听 刷新页面
    _animationController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //页面的主内容 先来个居中
      body: Center(
        child: Container(
          //来个高度
          height: 260,
          //宽度填充
          width: MediaQuery.of(context).size.width,
          //设置一下背景
          color: mainColor,
          //封装一个方法构建左右排列的
          child: buildRow(),
        ),
      ),
      //右下角的悬浮按钮
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          //点击按钮开启动画
          _animationController.reset();
          _animationController.forward();
        },
      ),
    );
  }

  buildRow() {
    //左右排列的线性布局
    return buildRightStack();
  }

  double _downX = 0.0;
  double _downY = 0.0;

  Stack buildRightStack() {
    return Stack(
      //子 Widget 居中
      alignment: Alignment.center,
      children: [
        //第一层
        Container(
          //来个内边距
          //来个边框装饰
          decoration: BoxDecoration(color: mainColor, shape: BoxShape.circle,
              //来个阴影
              boxShadow: [
                BoxShadow(
                  color: Colors.white,
                  spreadRadius: -8 * _bgAnimation.value,
                  offset:
                      Offset(-5 * _bgAnimation.value, -5 * _bgAnimation.value),
                  blurRadius: 30 * _bgAnimation.value,
                ),
                BoxShadow(
                  //模糊颜色
                  color: Colors.blue[300].withOpacity(0.3),
                  //模糊半径
                  spreadRadius: 2 * _bgAnimation.value,
                  //阴影偏移量
                  offset:
                      Offset(5 * _bgAnimation.value, 5 * _bgAnimation.value),
                  //模糊度
                  blurRadius: 20 * _bgAnimation.value,
                ),
              ]),
          //开始绘制神操作
          child: GestureDetector(
            onTapDown: (TapDownDetails details) {
              setState(() {
                ///相对于父组件的位置
                Offset localPosition = details.localPosition;

                ///相对于屏幕的位置
                Offset globalPosition = details.globalPosition;

                _downY = localPosition.dy;
                _downX = localPosition.dx;
              });
            },
            child: CustomPaint(
              size: Size(300, 300),
              painter: CustomShapPainter(_list, _progressAnimation.value,
                  downX: _downX, downY: _downY, clickCallBack: (int value) {
                currentSelect = value;
              }),
            ),
          ),
        ),
        //第二层
        Container(
          width: 80,
          decoration: BoxDecoration(
            color: mainColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  spreadRadius: 3 * _numberAnimation.value,
                  blurRadius: 5 * _numberAnimation.value,
                  offset: Offset(
                      5 * _numberAnimation.value, 5 * _numberAnimation.value),
                  color: Colors.black54),
            ],
          ),
          child: Center(
            child: Text(
              "${_list[currentSelect]["title"]}",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  int currentSelect = 0;

  //定义数据模型
  List _list = [
    {
      "title": "生活费",
      "number": 200,
      "color": Colors.lightBlueAccent,
      "isClick": false
    },
    {"title": "交通费", "number": 200, "color": Colors.green, "isClick": false},
    {"title": "贷款费", "number": 400, "color": Colors.amber, "isClick": false},
    {"title": "游玩费", "number": 100, "color": Colors.orange, "isClick": false},
    {
      "title": "电话费",
      "number": 100,
      "color": Colors.deepOrangeAccent,
      "isClick": false
    },
  ];
}

//你可以将这些类封装成不同的类文件 在这里小编为提供 Demo 的方便所以写在一起了

class CustomShapPainter extends CustomPainter {
  //数据内容
  List list;

  Function(int index) clickCallBack;
  double progress;

  CustomShapPainter(this.list, this.progress,
      {this.downX = 0.0, this.downY = 0.0, this.clickCallBack});

  //来个画笔
  Paint _paint = new Paint()
    ..isAntiAlias = true
    ..style = PaintingStyle.fill
    ..strokeWidth = 2.0;

  TextPainter _textPainter = TextPainter(
    textDirection: TextDirection.ltr,
    maxLines: 1,
  );

  double downX;
  double downY;
  double radius;
  double line1;
  double line2;

  //圆周率（Pi）是圆的周长与直径的比值，一般用希腊字母π表示
  //绘制内容
  @override
  void paint(Canvas canvas, Size size) {


    if (size.width > size.height) {
      radius = size.height / 3;
    } else {
      radius = size.width / 3;
    }

    line1 = radius / 3;
    line2 = radius / 2;

    canvas.translate(size.width / 2, size.height / 2);

    downY -= size.height / 2;
    downX -= size.width / 2;

    var calculatorDegree2 = calculatorDegree(0, 0, radius, 0, downX, downY);

    if (downY < 0) {
      calculatorDegree2 = pi + pi - calculatorDegree2;
    }
    print("calculatorDegree2 $calculatorDegree2");

    // 设置起始角度

    double total = 0.0;
    list.forEach((element) {
      total += element["number"];
    });

    double startRadin = 0.0;

    for (var i = 0; i < list.length; i++) {
      var entity = list[i];
      _paint.color = entity["color"];

      //计算所占的比例
      double flag = entity["number"] / total;

      //计算弧度
      double sweepRadin = flag * 2 * pi * progress;

      double endRadin = startRadin + sweepRadin;

      double tagRadius = radius;
      if (calculatorDegree2 > startRadin && calculatorDegree2 <= endRadin) {
        tagRadius += 10;
        if (clickCallBack != null) {
          clickCallBack(i);
        }
      }



      canvas.drawArc(Rect.fromCircle(center: Offset(0, 0), radius: tagRadius),
          startRadin, sweepRadin, true, _paint);

      _drawLineAndText(canvas, startRadin + sweepRadin / 2, sweepRadin,
          tagRadius, entity["title"], entity["color"]);

      startRadin += sweepRadin;
    }
    // 绘制测试点
    // _paint.color=Colors.black54;
    // _paint.style=PaintingStyle.stroke;
    // canvas.drawArc(Rect.fromCircle(center: Offset(0, 0), radius: radius),
    //     startRadin, calculatorDegree2, true, _paint);

  }

  //返回true 刷新
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  void _drawLineAndText(Canvas canvas, double currentAngle, double angle,
      double r, String name, Color color) {
    // 绘制横线
    // 1，计算开始坐标和转折点坐标
    var startX = r * (cos(currentAngle));
    var startY = r * (sin(currentAngle));

    var stopX = (r + line1) * (cos(currentAngle));
    var stopY = (r + line1) * (sin(currentAngle));

    // 2、计算坐标在左边还是在右边，并计算横线结束坐标
    var endX;
    if (stopX - startX > 0) {
      endX = stopX + line2;
    } else {
      endX = stopX - line2;
    }

    // 3、绘制斜线和横线
    canvas.drawLine(Offset(startX, startY), Offset(stopX, stopY), _paint);
    canvas.drawLine(Offset(stopX, stopY), Offset(endX, stopY), _paint);

    // 4、绘制文字
    // 绘制下方名称
    // 上下间距偏移量
    var offset = 4;
    // 1、测量文字
    var tp = _newVerticalAxisTextPainter(name, color);
    tp.layout();

    var w = tp.width;
    // 2、计算文字坐标
    var textStartX;
    if (stopX - startX > 0) {
      if (w > line2) {
        textStartX = (stopX + offset);
      } else {
        textStartX = (stopX + (line2 - w) / 2);
      }
    } else {
      if (w > line2) {
        textStartX = (stopX - offset - w);
      } else {
        textStartX = (stopX - (line2 - w) / 2 - w);
      }
    }
    tp.paint(canvas, Offset(textStartX, stopY + offset));

    // 绘制上方百分比，步骤同上
    // todo 保留2为小数，确保精准度
    var per = (angle / 360.0 * 100).toStringAsFixed(2) + "%";

    var tpPre = _newVerticalAxisTextPainter(per, color);
    tpPre.layout();

    w = tpPre.width;
    var h = tpPre.height;

    if (stopX - startX > 0) {
      if (w > line2) {
        textStartX = (stopX + offset);
      } else {
        textStartX = (stopX + (line2 - w) / 2);
      }
    } else {
      if (w > line2) {
        textStartX = (stopX - offset - w);
      } else {
        textStartX = (stopX - (line2 - w) / 2 - w);
      }
    }

    tpPre.paint(canvas, Offset(textStartX, stopY - offset - h));
  }

  // 文字画笔 风格定义
  TextPainter _newVerticalAxisTextPainter(String text, Color color) {
    return _textPainter
      ..text = TextSpan(
        text: text,
        style: new TextStyle(
          color: color,
          fontSize: 12.0,
        ),
      );
  }

  /// 三个点：圆心A，半径r，度数0的点B,任意点C.
  /// 先计算∠BAC的度数（弧度）。
  double calculatorDegree(
      double x1, double y1, double x2, double y2, double x3, double y3) {
    double radian = 0;

    double ab = getDistance(x1, y1, x2, y2);
    double ac = getDistance(x1, y1, x3, y3);
    double bc = getDistance(x2, y2, x3, y3);

    double value = (ab * ab + ac * ac - (bc * bc)) / (2 * ab * ac);

    radian = acos(value);

    return radian;
  }

  double getDistance(double x1, double y1, double x2, double y2) {
    double distance = 0;
    distance = sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1));
    return distance;
  }

  ///根据弧度计算度数并且计算AC距离。
  ///
}
