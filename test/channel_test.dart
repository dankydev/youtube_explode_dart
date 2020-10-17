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

  test('Get metadata of a channel', () async {
    var channelUrl = 'https://www.youtube.com/channel/UCEnBXANsKmyj2r9xVyKoDiQ';
    var channel = await yt.channels.get(ChannelId(channelUrl));
    expect(channel.url, channelUrl);
    expect(channel.title, 'Tyrrrz');
    expect(channel.logoUrl, isNotEmpty);
    expect(channel.logoUrl, isNot(equalsIgnoringWhitespace('')));
  });

  group('Get metadata of any channel', () {
    for (var val in {
      'UC46807r_RiRjH8IU-h_DrDQ',
      'UCJ6td3C9QlPO9O_J5dF4ZzA',
      'UCiGm_E4ZwYSHV3bcW1pnSeQ'
    }) {
      test('Channel - $val', () async {
        var channelId = ChannelId(val);
        var channel = await yt.channels.get(channelId);
        expect(channel.id, channelId);
      });
    }
  });

  test('Get metadata of a channel by username', () async {
    var channel = await yt.channels.getByUsername(Username('TheTyrrr'));
    expect(channel.id.value, 'UCEnBXANsKmyj2r9xVyKoDiQ');
  });

  test('Get metadata of a channel by a video', () async {
    var channel = await yt.channels.getByVideo(VideoId('5NmxuoNyDss'));
    expect(channel.id.value, 'UCEnBXANsKmyj2r9xVyKoDiQ');
  });

  test('Get the videos of a youtube channel', () async {
    var videos = await yt.channels
        .getUploads(ChannelId(
            'https://www.youtube.com/channel/UCEnBXANsKmyj2r9xVyKoDiQ'))
        .toList();
    expect(videos.length, greaterThanOrEqualTo(80));
  });

  group('Get the videos of any youtube channel', () {
    for (var val in {
      'UC46807r_RiRjH8IU-h_DrDQ',
      'UCJ6td3C9QlPO9O_J5dF4ZzA',
      'UCiGm_E4ZwYSHV3bcW1pnSeQ'
    }) {
      test('Channel - $val', () async {
        var videos = await yt.channels.getUploads(ChannelId(val)).toList();
        expect(videos, isNotEmpty);
      });
    }
  });

  test('Get videos of a youtube channel from the uploads page', () async {
    var videos = await yt.channels
        .getUploadsFromPage('UCEnBXANsKmyj2r9xVyKoDiQ')
        .take(30)
        .toList();
    expect(videos, hasLength(30));
  });
}
