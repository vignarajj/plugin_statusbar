import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plugin_statusbar/plugin_statusbar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Color _randomStatusColor = Colors.black;
  Color _randomNavigationColor = Colors.black;

  bool? _useWhiteStatusBarForeground;
  bool? _useWhiteNavigationBarForeground;

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (_useWhiteStatusBarForeground != null) {
        PluginStatusbar.setStatusBarWhiteForeground(
            _useWhiteStatusBarForeground!);
      }
      if (_useWhiteNavigationBarForeground != null) {
        PluginStatusbar.setNavigationBarWhiteForeground(
            _useWhiteNavigationBarForeground!);
      }
    }
    super.didChangeAppLifecycleState(state);
  }

  changeStatusColor(Color color) async {
    try {
      await PluginStatusbar.setStatusBarColor(color, animate: true);
      if (useWhiteForeground(color)) {
        PluginStatusbar.setStatusBarWhiteForeground(true);
        PluginStatusbar.setNavigationBarWhiteForeground(true);
        _useWhiteStatusBarForeground = true;
        _useWhiteNavigationBarForeground = true;
      } else {
        PluginStatusbar.setStatusBarWhiteForeground(false);
        PluginStatusbar.setNavigationBarWhiteForeground(false);
        _useWhiteStatusBarForeground = false;
        _useWhiteNavigationBarForeground = false;
      }
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
  }

  changeNavigationColor(Color color) async {
    try {
      await PluginStatusbar.setNavigationBarColor(color, animate: true);
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Flutter statusbar color plugin example'),
            bottom: const TabBar(
              tabs: <Widget>[
                Tab(text: 'Statusbar'),
                Tab(text: 'Navigationbar(android only)')
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Builder(builder: (BuildContext context) {
                    return ElevatedButton(
                        onPressed: () =>
                            PluginStatusbar.getStatusBarColor()
                                .then((Color? color) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(color.toString()),
                                backgroundColor: color,
                                duration: const Duration(milliseconds: 200),
                              ));
                            }),
                        child: const Text(
                          'Show Statusbar Color',
                          style: TextStyle(color: Colors.white),
                        ));
                    //   style:
                    //   ButtonStyle(
                    //       // backgroundColor:
                    //       //     MaterialStateProperty.all<Color>(Colors.amber)),
                    // );
                  }),
                  const Padding(padding: EdgeInsets.all(10.0)),
                  ElevatedButton(
                    onPressed: () => changeStatusColor(Colors.transparent),
                    child: const Text('Transparent'),
                  ),
                  const Padding(padding: EdgeInsets.all(10.0)),
                  ElevatedButton(
                    onPressed: () {
                      Color color = Colors.amberAccent;
                      changeStatusColor(color);
                    },
                    child: const Text('amber-accent'),
                    style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.amberAccent),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(10.0)),
                  ElevatedButton(
                    onPressed: () => changeStatusColor(Colors.tealAccent),
                    child: const Text('teal-accent'),
                    style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.tealAccent),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(10.0)),
                  ElevatedButton(
                    onPressed: () =>
                        PluginStatusbar.setStatusBarWhiteForeground(true)
                            .then((_) => _useWhiteStatusBarForeground = true),
                    child: const Text(
                      'light foreground',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.black),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(10.0)),
                  ElevatedButton(
                    onPressed: () =>
                        PluginStatusbar.setStatusBarWhiteForeground(false)
                            .then((_) => _useWhiteStatusBarForeground = false),
                    child: const Text('dark foreground'),
                    style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(10.0)),
                  ElevatedButton(
                    onPressed: () {
                      Random rnd = Random();
                      Color color = Color.fromARGB(
                        255,
                        rnd.nextInt(255),
                        rnd.nextInt(255),
                        rnd.nextInt(255),
                      );
                      changeStatusColor(color);
                      setState(() => _randomStatusColor = color);
                    },
                    child: Text(
                      'Random color',
                      style: TextStyle(
                        color: useWhiteForeground(_randomStatusColor)
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all<Color>(_randomStatusColor),
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Builder(builder: (BuildContext context) {
                    return ElevatedButton(
                      onPressed: () =>
                          PluginStatusbar.getNavigationBarColor()
                              .then((Color? color) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(color.toString()),
                              backgroundColor: color,
                              duration: const Duration(milliseconds: 200),
                            ));
                          }),
                      child: const Text(
                        'Show Navigationbar Color',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                      ),
                    );
                  }),
                  const Padding(padding: EdgeInsets.all(10.0)),
                  ElevatedButton(
                    onPressed: () => changeNavigationColor(Colors.green[400]!),
                    child: const Text('Green-400'),
                    style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all<Color?>(Colors.green[400]),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(10.0)),
                  ElevatedButton(
                    onPressed: () =>
                        changeNavigationColor(Colors.lightBlue[100]!),
                    child: const Text('LightBlue-100'),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color?>(
                          Colors.lightBlue[100]),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(10.0)),
                  ElevatedButton(
                    onPressed: () =>
                        changeNavigationColor(Colors.cyanAccent[200]!),
                    child: const Text('CyanAccent-200'),
                    style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all<Color?>(Colors.cyan[200]),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(10.0)),
                  ElevatedButton(
                    onPressed: () => PluginStatusbar
                        .setNavigationBarWhiteForeground(true)
                        .then((_) => _useWhiteNavigationBarForeground = true),
                    child: const Text(
                      'light foreground',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.black),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(10.0)),
                  ElevatedButton(
                    onPressed: () => PluginStatusbar
                        .setNavigationBarWhiteForeground(false)
                        .then((_) => _useWhiteNavigationBarForeground = false),
                    child: const Text('dark foreground'),
                    style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(10.0)),
                  ElevatedButton(
                    onPressed: () {
                      Random rnd = Random();
                      Color color = Color.fromARGB(
                        255,
                        rnd.nextInt(255),
                        rnd.nextInt(255),
                        rnd.nextInt(255),
                      );
                      setState(() => _randomNavigationColor = color);
                      changeNavigationColor(color);
                    },
                    child: Text(
                      'Random color',
                      style: TextStyle(
                        color: useWhiteForeground(_randomNavigationColor)
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          _randomNavigationColor),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

