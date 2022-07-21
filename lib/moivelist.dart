import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import './moviedetail.dart';

Dio dio = Dio();

class MovieList extends StatefulWidget {
  const MovieList({Key? key, required this.tabKey}) : super(key: key);

  final String tabKey;

  @override
  State<MovieList> createState() => _MovieListState();
}

// 有状态组件,必须结合一个状态管理类,来实现
class _MovieListState extends State<MovieList>
    with AutomaticKeepAliveClientMixin {
  int page = 1;
  int size = 6;
  int total = 0;
  List<dynamic> records = [];

  final ScrollController _scrollController = ScrollController(); //上拉加载滚动控制器
  bool showToTopBtn = false; //是否显示“返回到顶部”按钮
  bool loding = false;
  bool lastPage = false;

  // 页面keepAlive
  @override
  bool get wantKeepAlive => true;

  // 生命周期初始化,控件创建的时候执行
  @override
  void initState() {
    super.initState();
    getMovieList();
    _scrollController.addListener(() {
      // print(_scrollController.offset);
      // print(_scrollController.position.pixels);
      // print(_scrollController.position.maxScrollExtent);
      if (_scrollController.position.pixels >
          _scrollController.position.maxScrollExtent - 20) {
        if (!loding) {
          getMovieList();
        }
      }
    });
  }

  @override
  void dispose() {
    //为了避免内存泄露，需要调用_controller.dispose
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var movieItems = records.map((item) {
      return Container(child: MovieItem(item: item));
    });
    return RefreshIndicator(
        onRefresh: _onRefresh, // 下拉刷新
        child: ListView(
          controller: _scrollController,
          shrinkWrap: true,
          children: [
            ...movieItems,
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(loding ? '加载中~' : (lastPage ? '到底了~' : ''),
                  style: const TextStyle(), textAlign: TextAlign.center),
            )
          ],
        ));
  }

  Future<void> _onRefresh() {
    setState(() {
      page = 1;
    });
    return getMovieList();
  }

  getMovieList() async {
    if (total > 0 && ((page - 1) * size > total)) {
      setState(() {
        lastPage = true;
      });
      return;
    }
    setState(() {
      loding = true;
    });
    int offset = (page - 1) * size;
    String url =
        'http://www.liulongbin.top:3005/api/v2/movie/${widget.tabKey}?start=$offset&count=$size';

    var resp = await dio.get(url);
    var result = resp.data;
    print(url);
    print(page);
    // setState更新赋值
    if (page == 1) {
      setState(() {
        records = result['subjects'];
      });
    } else {
      records.addAll(result['subjects']);
    }
    setState(() {
      page = page + 1;
      total = result['total'];
      loding = false;
    });
  }
}

class MovieItem extends StatelessWidget {
  const MovieItem({Key? key, required this.item}) : super(key: key);
  final dynamic item;
  @override
  Widget build(BuildContext context) {
    // return Text(item['title']);
    // var imgUrl = item['images']['small'];
    var imgUrl = item['images']['large'];
    var title = item['title'];
    var year = item['year'];
    var genres = item['genres'].join(',');
    var rating = item['rating']['average'];

    return GestureDetector(
      onTap: () {
        // 跳转到详情页面
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return MovieDetail(record: item);
        }));
      },
      child: Container(
        decoration: const BoxDecoration(
            border: Border(
                top: BorderSide(color: Color.fromARGB(255, 233, 233, 233)))),
        height: 180.0,
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Image.network(imgUrl, width: 130, height: 180, fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                "images/bg.png",
                width: 130,
                height: 180,
                fit: BoxFit.cover,
              );
            }),
            Container(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("名称:$title"),
                    Text("上映年份:$year年"),
                    Text("电影类型:$genres"),
                    Text("豆瓣评分:$rating"),
                  ],
                ))
          ]),
        ),
      ),
    );
  }
}
