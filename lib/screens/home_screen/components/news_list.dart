import 'package:appmedicolaluz/helper/news.dart';

import 'news_list_view.dart';

newsList() {
  return NewsListView(
    callback: () {},
    newsData: NewslistData.newsData,
  );
}
