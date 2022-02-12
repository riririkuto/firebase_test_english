import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String a = 'a';
  int times = 0;

  List b = [];
  int number = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: number,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              padding: EdgeInsets.all(7),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1.0, color: Colors.grey),
                ),
              ),
              child: ListTile(
                leading: Icon(Icons.add),
                title: Text(b[index]),
              ),
            );
          },
        ),),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            b.clear();
            number = 100;
            generateWordPairs().take(100).forEach((element) {
              a = element.asCamelCase;
              b.add(a);
            });
            while(times <= 99){
              FirebaseFirestore.instance
                  .collection('word100')
                  .doc('word$times')
                  .set({'word': b[times],});
            times++;}
          },

          );
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),

    );
  }
}
