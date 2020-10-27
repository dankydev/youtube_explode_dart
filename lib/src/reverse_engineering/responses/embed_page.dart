import 'dart:convert';

import 'package:html/dom.dart';
import 'package:html/parser.dart' as parser;

import '../../extensions/helpers_extension.dart';
import '../../retry.dart';
import '../youtube_http_client.dart';


///
class EmbedPage {
  static final _playerConfigExp =
      RegExp('[\'"]PLAYER_CONFIG[\'"]\\s*:\\s*(\\{.*\\})');

  final Document _root;
  _PlayerConfig _playerConfig;
  String __playerConfigJson;

  ///
  String get sourceUrl {
    var url = _root.querySelector('*[name="player_ias/base"]').attributes['src'];
    if (url == null) {
      return null;
    }
    return 'https://youtube.com$url';
  }

  ///
  _PlayerConfig get playerconfig {
    if (_playerConfig != null) {
      return _playerConfig;
    }
    var playerConfigJson = _playerConfigJson;
    if (playerConfigJson == null) {
      return null;
    }
    return _playerConfig =
        _PlayerConfig(json.decode(playerConfigJson.extractJson()));
  }

  String get _playerConfigJson => __playerConfigJson ??= _root
      .getElementsByTagName('script')
      .map((e) => e.text)
      .map((e) => _playerConfigExp.firstMatch(e)?.group(1))
      .firstWhere((e) => !e.isNullOrWhiteSpace, orElse: () => null);

  ///
  EmbedPage(this._root);

  ///
  EmbedPage.parse(String raw) : _root = parser.parse(raw);

  ///
  static Future<EmbedPage> get(YoutubeHttpClient httpClient, String videoId) {
    var url = 'https://youtube.com/embed/$videoId?hl=en';
    return retry(() async {
      var raw = await httpClient.getString(url);
      return EmbedPage.parse(raw);
    });
  }
}

class _PlayerConfig {
  // Json parsed map.
  final Map<String, dynamic> _root;

  _PlayerConfig(this._root);

  String get sourceUrl =>
      _root != null && _root['assets'] != null ? 'https://youtube.com${_root['assets']['js']}' : null;
}
