import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late ScrollController _controller;
  int _current = 0;
  final double _w = 10;
  final double _h = 80;
  final int _max = 2000;

  EdgeInsets _getPadding(int idx, int maxIdx, double width) {
    if (idx == 0) {
      return EdgeInsets.only(left: (width / 2) - _w / 2);
    } else if (idx == maxIdx) {
      return EdgeInsets.only(right: (width / 2) - _w / 2);
    } else {
      return const EdgeInsets.all(0);
    }
  }

  BoxBorder _getBorder(int idx, int maxIdx) {
    if (idx == 0) {
      return const Border(
          left: BorderSide(color: Colors.black, width: 1),
          top: BorderSide(color: Colors.black, width: 1),
          bottom: BorderSide(color: Colors.black, width: 1));
    } else if (idx == maxIdx) {
      return const Border(
          right: BorderSide(color: Colors.black, width: 1),
          top: BorderSide(color: Colors.black, width: 1),
          bottom: BorderSide(color: Colors.black, width: 1));
    } else {
      return const Border(
          top: BorderSide(color: Colors.black, width: 1),
          bottom: BorderSide(color: Colors.black, width: 1));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _controller = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  Widget _getBar(int idx) {
    if (idx % 100 == 0) {
      return const Text(
        "|",
        style: TextStyle(fontSize: 20, color: Colors.red),
      );
    } else if (idx % 10 == 0) {
      return const Text(
        "|",
        style: TextStyle(fontSize: 15, color: Colors.blue),
      );
    } else if (idx % 5 == 0) {
      return const Text(
        "|",
        style: TextStyle(fontSize: 10, color: Colors.blue),
      );
    } else {
      return const Text(
        "|",
        style: TextStyle(fontSize: 5, color: Colors.blue),
      );
    }
  }

  Widget _getNum(int idx) {
    if (idx % 100 == 0) {
      return Text(
        "${(idx ~/ 10).toInt()}",
        style: const TextStyle(fontSize: 16),
      );
    } else if (idx % 10 == 0) {
      return Text(
        "${((idx / 10) - ((idx ~/ 100) * 10)).toInt()}",
        style: const TextStyle(fontSize: 12),
      );
    } else {
      return const Text("");
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ruler"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("|"),
          SizedBox(
            height: _h,
            child: NotificationListener<ScrollNotification>(
              onNotification: (scrollNotification) {
                if (scrollNotification is ScrollStartNotification) {
                  //print("startScroll");
                } else if (scrollNotification is ScrollUpdateNotification) {
                  //print("stillScroll");
                } else if (scrollNotification is ScrollEndNotification) {
                  //print("endScroll");
                  int newIdx = ((_controller.offset + _w / 2) ~/ _w);
                  setState(() {
                    _current = newIdx;
                    WidgetsBinding.instance!.addPostFrameCallback((_) {
                      _controller.animateTo(_current * _w,
                          duration: const Duration(milliseconds: 50),
                          curve: Curves.easeIn);
                    });
                  });
                }
                return true;
              },
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                controller: _controller,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: _max,
                itemBuilder: (ctx, idx) => Padding(
                  padding: _getPadding(idx, _max - 1, width),
                  child: Container(
                    decoration: BoxDecoration(
                      border: _getBorder(idx, _max - 1),
                    ),
                    width: _w,
                    height: _h * 2,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Column(
                        children: [
                          _getBar(idx),
                          _getNum(idx),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Text(((_current / 100) * 10).toStringAsFixed(1)),
        ],
      ),
    );
  }
}
