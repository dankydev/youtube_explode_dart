import 'dart:async';

import '../../exceptions/exceptions.dart';
import '../../retry.dart';
import '../cipher/cipher_operations.dart';
import '../youtube_http_client.dart';

///
class PlayerSource {
  final RegExp _statIndexExp = RegExp(r'\(\w+,(\d+)\)');

  final RegExp _funcBodyExp = RegExp(
      r'(\w+)=function\(\w+\){(\w+)=\2\.split\(\x22{2}\);.*?return\s+\2\.join\(\x22{2}\)}');

  final RegExp _objNameExp = RegExp(r'([\$_\w]+).\w+\(\w+,\d+\);');

  final RegExp _calledFuncNameExp = RegExp(r'\w+(?:.|\[)(\"?\w+(?:\")?)\]?\(');

  final String _root;

  String _sts;
  String _deciphererDefinitionBody;

  ///
  String get sts {
    if (_sts != null) {
      return _sts;
    }

    var val = RegExp(r'(?<=invalid namespace.*?;[\w\s]+=)\d+')
            .stringMatch(_root)
            ?.nullIfWhitespace ??
        RegExp(r'(?<=signatureTimestamp[=\:])\d+')
            .stringMatch(_root)
            ?.nullIfWhitespace;
    if (val == null) {
      throw FatalFailureException('Could not find sts in player source.');
    }
    return _sts ??= val;
  }

  ///
  Iterable<CipherOperation> getCiperOperations() sync* {
    var funcBody = _getDeciphererFuncBody();

    if (funcBody == null) {
      throw FatalFailureException(
          'Could not find signature decipherer function body.');
    }

    var definitionBody = _getDeciphererDefinitionBody(funcBody);
    if (definitionBody == null) {
      throw FatalFailureException(
          'Could not find signature decipherer definition body.');
    }

    for (var statement in funcBody.split(';')) {
      var calledFuncName = _calledFuncNameExp.firstMatch(statement)?.group(1);
      if (calledFuncName.isNullOrWhiteSpace) {
        continue;
      }

      var escapedFuncName = RegExp.escape(calledFuncName);
      // Slice
      var exp = RegExp('$escapedFuncName'
          r':\bfunction\b\([a],b\).(\breturn\b)?.?\w+\.');

      if (exp.hasMatch(definitionBody)) {
        var index = int.parse(_statIndexExp.firstMatch(statement).group(1));
        yield SliceCipherOperation(index);
      }

      // Swap
      exp = RegExp(
          '$escapedFuncName' r':\bfunction\b\(\w+\,\w\).\bvar\b.\bc=a\b');
      if (exp.hasMatch(definitionBody)) {
        var index = int.parse(_statIndexExp.firstMatch(statement).group(1));
        yield SwapCipherOperation(index);
      }

      // Reverse
      exp = RegExp('$escapedFuncName' r':\bfunction\b\(\w+\)');
      if (exp.hasMatch(definitionBody)) {
        yield const ReverseCipherOperation();
      }
    }
  }

  String _getDeciphererFuncBody() {
    return _deciphererDefinitionBody ??=
        _funcBodyExp.firstMatch(_root).group(0);
  }

  String _getDeciphererDefinitionBody(String deciphererFuncBody) {
    var objName = _objNameExp.firstMatch(deciphererFuncBody).group(1);

    var exp = RegExp(
        r'var\s+'
        '${RegExp.escape(objName)}'
        r'=\{(\w+:function\(\w+(,\w+)?\)\{(.*?)\}),?\};',
        dotAll: true);
    return exp.firstMatch(_root)?.group(0)?.nullIfWhitespace;
  }

  ///
  PlayerSource(this._root);

  ///
  // Same as default constructor
  PlayerSource.parse(this._root);

  ///
  static Future<PlayerSource> get(
      YoutubeHttpClient httpClient, String url) async {
    if (url == null) return Future.value(null);
    
    if (_cache[url]?.expired ?? true) {
      var val = await retry(() async {
        var raw = await httpClient.getString(url);
        return PlayerSource.parse(raw);
      });
      if (_cache[url] == null) {
        _cache[url] = _CachedValue(val);
      } else {
        _cache[url].update(val);
      }
    }
    return _cache[url].value;
  }

  static final Map<String, _CachedValue<PlayerSource>> _cache = {};
}

class _CachedValue<T> {
  T _value;
  int expireTime;
  final int cacheTime;

  T get value {
    if (expired) {
      throw StateError('Value $value is expired!');
    }
    return _value;
  }

  bool get expired {
    final now = DateTime.now().millisecondsSinceEpoch;
    return now > expireTime;
  }

  set value(T other) => _value = other;

  _CachedValue(this._value, [this.expireTime, this.cacheTime = 600000]) {
    expireTime ??= DateTime.now().millisecondsSinceEpoch + cacheTime;
  }

  void update(T newValue) {
    var now = DateTime.now().millisecondsSinceEpoch;
    expireTime = now + cacheTime;
    value = newValue;
  }
}

extension on String {
  String get nullIfWhitespace => trim().isEmpty ? null : this;

  bool get isNullOrWhiteSpace {
    if (this == null) {
      return true;
    }
    if (trim().isEmpty) {
      return true;
    }
    return false;
  }
}
