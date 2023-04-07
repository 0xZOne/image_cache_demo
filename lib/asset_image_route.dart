import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'new_route.dart';

class AssetImageRoute extends StatefulWidget {
  final bool precache;
  const AssetImageRoute({Key? key, required this.precache}) : super(key: key);

  @override
  State<AssetImageRoute> createState() => _AssetImageRouteState();
}

class _AssetImageRouteState extends State<AssetImageRoute> {
  late Image image1;
  late Image image2;
  static const int seconds = 3;
  bool isTimerFinished = false;
  late Timer timer;

  @override
  void dispose() {
    super.dispose();
    if (kDebugMode) {
      print('#dispose, $this');
    }
    timer.cancel();
  }

  @override
  void initState() {
    super.initState();
    timer = Timer(
      const Duration(seconds: seconds),
      () {
        // Execute your code here
        setState(() {
          isTimerFinished = true;
        });
      },
    );
    image1 = Image.asset("images/picture1.jpg");
    image2 = Image.asset("images/picture2.jpg");
    if (kDebugMode) {
      print('#initState, $this');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.precache) {
      precacheImage(image1.image, context);
      precacheImage(image2.image, context);
    }

    if (kDebugMode) {
      print('#didChangeDependencies, precache=${widget.precache}, $this');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print('#build, $this');
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Precache Images Demo"),
      ),
      body: Center(
        child: (isTimerFinished || !widget.precache)
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const NewRoute()),
                          );
                        },
                        child: const Text('Open route'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Go back!'),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  image1,
                  const SizedBox(
                    height: 50,
                  ),
                  image2,
                ],
              )
            : Container(
                alignment: Alignment.center,
                child: const Text('Waiting $seconds seconds for precache...'),
              ),
      ),
    );
  }
}
