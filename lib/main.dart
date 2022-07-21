import 'package:flutter/material.dart';
import './moivelist.dart';

void main() {
  runApp(const MyApp());
}

// 自定义组件// StatelessWidget是无状态组件
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //  Widget build 类似于 React render
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.amber,
      ),
      home: const MyHomePage(title: 'My App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String movieName = '';
  double movieRate = 0;

  void _textChanged(String value, String type) {
    if (type == 'name') {
      setState(() {
        movieName = value;
      });
    } else if (type == 'rate') {
      setState(() {
        movieRate = double.parse(value);
      });
    }
  }

  Future<Map<String, Object>?> _showSearchDialog() {
    return showDialog<Map<String, Object>>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("提示"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  autofocus: true,
                  onChanged: (v) => _textChanged(v, 'name'),
                  decoration: const InputDecoration(
                      labelText: '电影名称',
                      hintText: '请输入电影名称',
                      prefixIcon: Icon(Icons.movie))),
              TextField(
                keyboardType: TextInputType.number,
                onChanged: (v) => _textChanged(v, 'rate'),
                decoration: const InputDecoration(
                    labelText: '电影评分',
                    hintText: '请输入电影评分',
                    prefixIcon: Icon(Icons.grade)),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("取消"),
              onPressed: () => Navigator.of(context).pop(), // 关闭对话框
            ),
            TextButton(
              child: const Text("确定"),
              onPressed: () {
                //关闭对话框并返回true
                Navigator.of(context)
                    .pop({'movieName': movieName, 'movieRate': movieRate});
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
          backgroundColor: const Color.fromRGBO(22, 182, 190, 1),
          titleTextStyle: const TextStyle(
              color: Color.fromARGB(255, 215, 238, 175), fontSize: 20),
          // actions: const [Text('back')],
        ),
        body: Container(
            child: const TabBarView(children: [
          MovieList(tabKey: 'in_theaters'),
          MovieList(tabKey: 'coming_soon'),
          MovieList(tabKey: 'top250'),
        ])),
        drawer: Drawer(
            child: ListView(
                padding: const EdgeInsets.all(0),
                children: const <Widget>[
              UserAccountsDrawerHeader(
                  accountName: Text('Rico'),
                  accountEmail: Text('zrless@163.com')),
              ListTile(
                title: Text('用户反馈'),
                subtitle: Text('给我一个反馈'),
                trailing: Icon(Icons.feedback),
              ),
              ListTile(
                  title: Text('系统设置'),
                  subtitle: Text('设置一下'),
                  trailing: Icon(Icons.settings))
            ])),
        bottomNavigationBar: Container(
          // color: const Color.fromARGB(255, 215, 238, 175),
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 224, 224, 224),
          ),
          child: const TabBar(
              indicatorColor: Color.fromRGBO(22, 182, 190, 1),
              // labelColor: Color.fromARGB(255, 78, 78, 4),
              indicator: BoxDecoration(
                color: Color.fromRGBO(22, 182, 190, 1),
              ),
              tabs: [
                Tab(icon: Icon(Icons.movie_filter), text: '热映'),
                Tab(icon: Icon(Icons.movie_creation), text: '即将上映'),
                Tab(
                  icon: Icon(Icons.local_movies),
                  text: 'Top250',
                )
              ]),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.search),
          // onPressed: () {
          //   print(2);
          // }
          onPressed: () async {
            //弹出对话框并等待其关闭
            Map<String, Object>? values = await _showSearchDialog();
            print(values);
            if (values == null) {
              print("取消删除");
            } else {
              print("已确认删除");
              //... 删除文件
            }
          },
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}

class MyButtonWidget extends StatefulWidget {
  const MyButtonWidget({Key? key}) : super(key: key);

  @override
  State<MyButtonWidget> createState() => _MyButtonWidgetState();
}

class _MyButtonWidgetState extends State<MyButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration:
              BoxDecoration(border: Border.all(width: 1, color: Colors.black)),
          padding: const EdgeInsets.fromLTRB(10, 4, 10, 4),
          child: const Text(
            '点一下',
            style: TextStyle(
              color: Color.fromRGBO(0, 0, 0, 1),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
