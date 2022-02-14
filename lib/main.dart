import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FireStore(),
    );
  }
}

class FireStore extends StatefulWidget {
  const FireStore({Key? key}) : super(key: key);

  @override
  _FireStoreState createState() => _FireStoreState();
}

class _FireStoreState extends State<FireStore> {
  // ドキュメント情報を入れる箱を用意
  List<DocumentSnapshot> documentList = [];
  String _outputText = "";
  int times=0;
  int number=0;
  List wordlist=[];
String a='';
int storetimes=0;
String storeinformation='';
  @override
  Widget build(BuildContext context) {
    void _handleOutputText(String inputText) {
      setState(() {
        _outputText = inputText;
      });
    }
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // データの追加
           SingleChildScrollView(
             child: TextField(
                        maxLength: 16,
                        maxLengthEnforced: true,
                        style: TextStyle(color: Colors.black),
                        maxLines: 1,
                        onChanged: _handleOutputText,
                      ),
           ),



              ElevatedButton(
                child: Text("add"),
                onPressed: () async {
               print(wordlist);

                },
              ),
              // データの読み込み
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                ),
                child: Text('Load'),
                onPressed: () async {
                  // 指定コレクションのドキュメント一覧を取得
                  final snapshot = await FirebaseFirestore.instance
                      .collection('word100')
                      .get();
                  // ドキュメント一覧を配列で格納
                  setState(() {
                    documentList = snapshot.docs;
                  });
                },
              ),


              ElevatedButton(
                child: Text("wordlist"),
                onPressed: () async {
                  print(wordlist);
                  if(wordlist.indexOf(_outputText)>=0){
                    print(wordlist.indexOf(_outputText));
                    setState(() {
                      storeinformation='IDは${wordlist.indexOf(_outputText)}です';
                    });

                  }
                  else{
                    print('まだ登録されていません');
                    setState(() {

                      storeinformation='登録されていないので追加します。';
                      wordlist.add(_outputText);
                      storetimes=storetimes+1;
                      FirebaseFirestore.instance
                          .collection('word100')
                          .doc('word${storetimes}')
                          .set({'word': wordlist[storetimes],'id':storetimes});
                    });
                  }
                },
              ),

              Text(storeinformation),
              // 表示
              Container(
                margin: EdgeInsets.only(top:10),
                height:400,
                child:
              SingleChildScrollView(
                child: Column(
                  children: documentList.map((document) {
                    wordlist.add('${document['word']}');
                    print(wordlist);

                    return ListTile(
                      title: Text('name:${document['word']} id:${document['id']}'),
                    );

                  }).toList(),

                ),
              ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {

            generateWordPairs().take(100).forEach((element) {
              wordlist.add(element.asCamelCase.toLowerCase());
            });
         print(wordlist.length);
            while(times <= storetimes+99){

              FirebaseFirestore.instance
                  .collection('word100')
                  .doc('word$times')
                  .set({'word': wordlist[times],'id':times});
              times++;

            }
            storetimes=times;
          },

          );
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),

    );

  }

}