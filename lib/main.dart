import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      builder: (context, child) =>
          ResponsiveWrapper.builder(child, defaultScale: true, breakpoints: [
        const ResponsiveBreakpoint.resize(350, name: MOBILE),
        const ResponsiveBreakpoint.autoScale(600, name: TABLET),
        const ResponsiveBreakpoint.resize(800, name: DESKTOP),
        const ResponsiveBreakpoint.autoScale(1700, name: 'XL'),
      ]),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: ResponsiveWrapper.of(context).isSmallerThan(DESKTOP)?Drawer(
          elevation: 30,
          child: Column(
            children: [
              SizedBox(
                  height: 64,
                  child: DrawerHeader(
                      padding: EdgeInsets.zero,
                      child: Container(
                        color: Colors.blue,
                      ))),
               DropdownMenuItem(child: TextButton(onPressed: _incrementCounter, child: Text('Increment')))
            ],
          )):null,
      body: ResponsiveRowColumn(
        rowPadding: const EdgeInsets.all(10),
        columnPadding: const EdgeInsets.all(10),
        rowSpacing: 10,
        columnSpacing: 10,
        layout: ResponsiveWrapper.of(context).isSmallerThan(DESKTOP)
            ? ResponsiveRowColumnType.COLUMN
            : ResponsiveRowColumnType.ROW,
        children: [
          ResponsiveRowColumnItem(
              rowFlex: 1,
              columnFlex: 1,
              child: Container(
                color: Colors.blue,
                child: Center(
                  child: Text(
                      ResponsiveWrapper.of(context).isSmallerThan(DESKTOP)
                          ? 'Mobile'
                          : 'Desktop',
                      style: const TextStyle(
                          fontSize: 25,
                          color: Colors.amber,
                          fontWeight: FontWeight.bold)),
                ),
              )),
          ResponsiveRowColumnItem(
              rowFlex: 1,
              columnFlex: 1,
              child: Container(
                color: Colors.amber,
                child: Center(
                    child: Text(
                  '$_counter',
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: ResponsiveValue<double>(context,
                          defaultValue: 16,
                          valueWhen: [
                            const Condition.largerThan(name: MOBILE, value: 32)
                          ]).value),
                )),
              ))
        ],
      ),
      floatingActionButton: ResponsiveVisibility(
        visible: false,
        visibleWhen: const [Condition.largerThan(name: TABLET)],
        child: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
