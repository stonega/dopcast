
class PodcastLocal {
  final String title;
  final String imageUrl;
  final String rssUrl;
  PodcastLocal(this.title, this.imageUrl, this.rssUrl);
}
final List<PodcastLocal> podcastlist = <PodcastLocal>[
  PodcastLocal('路书', "images/lushu.jpg", "http://lushu88.com/rss"),
  PodcastLocal('选美', "images/xuanmei.png", "http://xuanmei.us/rss"),
  PodcastLocal('声东击西', "images/etw.jpg", "https://www.etw.fm/rss"),
];