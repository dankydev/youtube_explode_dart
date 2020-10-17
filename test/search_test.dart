import 'package:test/test.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

void main() {
  YoutubeExplode yt;
  setUp(() {
    yt = YoutubeExplode();
  });

  tearDown(() {
    yt.close();
  });

    test('SearchYouTubeVideosFromApi', () async {
      Stopwatch stopwatch = Stopwatch()..start();
      var videos = await yt.search
          .getVideos('AC/DC If you want blood')
          .toList();
      print(stopwatch.elapsedMilliseconds.toString());
      expect(videos, isNotEmpty);
    });

  test('Search a youtube videos from the search page', () async {
    var searchQuery = await yt.search.queryFromPage('hello');
    expect(searchQuery.content, isNotEmpty);
    expect(searchQuery.relatedVideos, isNotEmpty);
    expect(searchQuery.relatedQueries, isNotEmpty);
  });

  test('Search with no results', () async {
    var query =
        await yt.search.queryFromPage('g;jghEOGHJeguEPOUIhjegoUEHGOGHPSASG');
    expect(query.content, isEmpty);
    expect(query.relatedQueries, isEmpty);
    expect(query.relatedVideos, isEmpty);
    var nextPage = await query.nextPage();
    expect(nextPage, isNull);
  });

  test('Search youtube videos have thumbnails', () async {
      var searchQuery = await yt.search.queryFromPage('hello');
      expect(searchQuery.content.first, isA<SearchVideo>());

      var video = searchQuery.content.first as SearchVideo;
      expect(video.videoThumbnails, isNotEmpty);
    });

  test('Search youtube videos from search page (stream)', () async {
    var query = await yt.search.getVideosFromPage('hello').take(30).toList();
    expect(query, hasLength(30));
  });
}
