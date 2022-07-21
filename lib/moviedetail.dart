import 'package:flutter/material.dart';

class MovieDetail extends StatefulWidget {
  MovieDetail({Key? key, required this.record}) : super(key: key);

  var record = {};

  @override
  State<MovieDetail> createState() => _MovieDetailState();
}

class _MovieDetailState extends State<MovieDetail> {
  @override
  Widget build(BuildContext context) {
    // return Container(
    //   child: const Text('这是${ record['title']}页面'),
    // );
    String title = (widget.record['title']) as String;
    var year = widget.record['year'];
    List casts = widget.record['casts'];
    var genres = widget.record['genres'].join(',');
    var rating = widget.record['rating']['average'];

    var castlist1 = casts.asMap().entries.map((entry) {
      var item = casts[entry.key];
      double left = entry.key != 0 ? 15.0 : 0.0;
      var margin = EdgeInsets.only(left: left);
      // var imgUrl = item['avatars'] ?? ['small'];
      var avatars = item['avatars'] ?? '';

      var imgUrl = avatars == '' ? '' : avatars['small'];
      return Container(
        margin: margin,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipOval(
              child: Image.network(imgUrl,
                  height: 50.0,
                  width: 50.0,
                  fit: BoxFit.cover, errorBuilder: (context, error, stack) {
                return Image.asset('images/bg.png',
                    height: 50.0, width: 50.0, fit: BoxFit.cover);
              }),
            ),
            SizedBox(
                width: 50.0,
                child: Align(
                    child: Text(item['name'], textAlign: TextAlign.center)))
          ],
        ),
      );
    });
    var border = const Border(
        bottom: BorderSide(width: 1, color: Color.fromRGBO(0, 0, 0, 0.15)));
    return Scaffold(
        appBar: AppBar(title: Text(title)),
        body: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(border: border),
              child: Row(
                children: [const Text('名称: '), Text(title)],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(border: border),
              child: Row(
                children: [const Text('上映年份: '), Text("$year年")],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(border: border),
              child: Row(
                children: [const Text('电影类型: '), Text(genres)],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(border: border),
              child: Row(
                children: [const Text('豆瓣评分: '), Text(rating.toString())],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(border: border),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [const Text('演员: '), ...castlist1],
              ),
            )
          ],
        ));
  }
}
