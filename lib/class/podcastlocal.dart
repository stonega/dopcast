class PodcastLocal {
  final String title;
  final String imageUrl;
  final String jsonUrl;
  PodcastLocal(this.title, this.imageUrl, this.jsonUrl);
}

final List<PodcastLocal> podcastlist = <PodcastLocal>[
  PodcastLocal('路书', "images/lushu.jpg", "data/lushu.json"),
  PodcastLocal('选美', "images/xuanmei.png", "data/xuanmei.json"),
  PodcastLocal('声东击西', "images/etw.jpg", "data/lushu.json"),
  PodcastLocal('7-Stories', "images/7-stories.jpg", "data/lushu.json"),
];