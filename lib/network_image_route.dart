import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'new_route.dart';

class NetworkImageRoute extends StatefulWidget {
  final bool precache;
  const NetworkImageRoute({Key? key, required this.precache}) : super(key: key);

  @override
  State<NetworkImageRoute> createState() => _NetworkImageRouteState();
}

class _NetworkImageRouteState extends State<NetworkImageRoute> {
  late Image image1;
  late Image image2;
  static const int seconds = 3;
  bool isTimerFinished = false;
  late Timer timer;

  Image _getImageFromNetwork(String url) {
    return Image.network(
      url,
      width: 750.0,
      height: 280.0,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

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
    image1 = _getImageFromNetwork(
        "http://img.alicdn.com/bao/uploaded/i3/6000000000147/TB2biPurbsTMeJjy1zcXXXAgXXa_!!0-fleamarket.jpg");
    image2 = _getImageFromNetwork(
        "http://img.alicdn.com/bao/uploaded/i4/6000000004811/TB2W0LFjLMTUeJjSZFKXXagopXa_!!0-fleamarket.jpg");
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
