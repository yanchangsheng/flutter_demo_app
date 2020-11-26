import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test_app/canvas/test_bubble_login_page.dart';

/// 创建人： Created by zhaolong
/// 创建时间：Created by  on 2020/11/22.
///
/// 可关注公众号：我的大前端生涯   获取最新技术分享
/// 可关注网易云课堂：https://study.163.com/instructor/1021406098.htm
/// 可关注博客：https://blog.csdn.net/zl18603543572
/// 西瓜视频 https://www.ixigua.com/home/3662978423
/// 知乎 https://www.zhihu.com/people/zhao-long-90-89
///
///
/// 程序入口
void main() {
  runApp(
    MaterialApp(
      home: TestPage(),
    ),
  );
}

/// 雪花背景
class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

//全局定义获取颜色的方法
Color getRandomWhiteColor(Random random) {
  //透明度 0 ~ 200  255是不透明
  int a = random.nextInt(200);
  return Color.fromARGB(a, 255, 255, 255);
}

class _TestPageState extends State<TestPage> with TickerProviderStateMixin {
  //创建一个集合用来保存气泡
  List<BobbleBean> _list = [];

  //随机数
  Random _random = new Random(DateTime.now().microsecondsSinceEpoch);

  //运动速度控制
  double _maxSpeed = 2.0;

  //设置最大半径
  double _maxRadius = 100;

  //设置最大的角度  360度
  double _maxThte = 2 * pi;

  //来个动画控制器
  AnimationController _animationController;

  AnimationController _fadeAnimationController;

  //初始化函数中创建气泡
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      for (int i = 0; i < 2000; i++) {
        BobbleBean bean = new BobbleBean();
        //获取随机透明度白色
        bean.color = getRandomWhiteColor(_random);
        //设置位置 先来个默认的 绘制的时候再修改
        double x = _random.nextDouble() * MediaQuery.of(context).size.width;
        double y = _random.nextDouble() * MediaQuery.of(context).size.height;
        double z = _random.nextDouble() + 0.5;
        bean.speed = _random.nextDouble() + 0.01 / z;
        bean.postion = Offset(x, y);
        bean.origin = Offset(x, 0);
        //设置半径
        bean.radius = 2.0 / z;

        _list.add(bean);
      }
    });

    //创建动画控制器 1秒
    _animationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 10000));

    //执行刷新监听
    _animationController.addListener(() {
      setState(() {});
    });
    //重复执行
    // _animationController.repeat();

    _fadeAnimationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 1800));
    _fadeAnimationController.forward();

    _fadeAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        //开启气泡的运动
        _animationController.repeat();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      ///填充布局
      body: Container(
        width: double.infinity,
        height: double.infinity,
        //层叠布局
        child: Stack(
          children: [
            //第一部分 渐变背景
            Positioned.fill(
              child: Image.asset(
                "assets/images/bg_snow.png",
                fit: BoxFit.fill,
              ),
            ),
            //第二部分 气泡
            buildBobbleWidget(context),
          ],
        ),
      ),
    );
  }

  buildBobbleWidget(BuildContext context) {
    //画板
    return CustomPaint(
      size: MediaQuery.of(context).size,
      //画布
      painter: CustomMyPainter(list: _list, random: _random),
    );
  }
}

class TextFieldWidget extends StatelessWidget {
  Function(String value) onChanged;
  bool obscureText;
  String labelText;

  IconData prefixIconData;
  IconData suffixIconData;

  TextFieldWidget(
      {this.onChanged,
      this.obscureText,
      this.labelText,
      this.prefixIconData,
      this.suffixIconData});

  @override
  Widget build(BuildContext context) {
    return TextField(
      //来个实时输入回调
      onChanged: onChanged,
      //是否隐藏文本 用于密码
      obscureText: obscureText,

      //文本样式
      style: TextStyle(
        color: Colors.blue,
        fontSize: 14.0,
      ),
      //输入框可用时的边框配置
      decoration: InputDecoration(
          //填充一下
          filled: true,
          //提示文本
          labelText: labelText,
          //去掉默认的下划线
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide.none,
          ),
          //获取输入焦点时的边框样式
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: Colors.blue),
          ),
          //输入框前的图标
          prefixIcon: Icon(
            prefixIconData,
            size: 18,
            color: Colors.blue,
          ),
          //输入文本后的图标
          suffixIcon: Icon(
            suffixIconData,
            size: 18,
            color: Colors.blue,
          )),
    );
  }
}

///创建画布
class CustomMyPainter extends CustomPainter {
  List<BobbleBean> list;
  Random random;

  CustomMyPainter({this.list, this.random}); //具体的绘制功能

  //先来个画笔
  Paint _paint = new Paint()..isAntiAlias = true;

  @override
  void paint(Canvas canvas, Size size) {
    // 在绘制前重新计算每个点的位置
    list.forEach((element) {
      double dx = random.nextDouble() * 2.0 - 1.0;
      double dy = element.speed;

      element.postion += Offset(dx, dy);

      if (element.postion.dy > size.height) {
        element.postion = element.origin;
      }
    });
    //
    // //绘制
    list.forEach((element) {
      //修改画笔的颜色
      _paint.color = element.color;
      //绘制圆
      canvas.drawCircle(element.postion, element.radius, _paint);
    });
  }

  //刷新 控制
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    //返回false 不刷新
    return true;
  }

  Offset calculateXY(double speed, double theta) {
    return Offset(speed * cos(theta), speed * sin(theta));
  }
}

///定义气泡
class BobbleBean {
  //位置
  Offset postion;
  Offset origin;

  //颜色
  Color color;

  //运动的速度
  double speed;

  //透明度
  double opacity;

  //半径
  double radius;
}
