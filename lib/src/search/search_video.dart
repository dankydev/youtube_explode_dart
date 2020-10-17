import '../videos/video_id.dart';
import 'base_search_content.dart';

/// Metadata related to a search query result (video).
class SearchVideo extends BaseSearchContent {
  /// VideoId.
  final VideoId videoId;

  /// Video title.
  final String videoTitle;

  /// Video author.
  final String videoAuthor;

  /// Video description snippet. (Part of the full description if too long)
  final String videoDescriptionSnippet;

  /// Video duration as String, HH:MM:SS
  final String videoDuration;

  /// Video View Count
  final int videoViewCount;

  /// Video thumbnail uris
  final List<String> videoThumbnails;

  /// Initialize a [SearchVideo] instance.
  const SearchVideo(
    this.videoId,
    this.videoTitle,
    this.videoAuthor,
    this.videoDescriptionSnippet,
    this.videoDuration,
    this.videoViewCount,
    this.videoThumbnails,
  );

  @override
  String toString() => '(Video) $videoTitle ($videoId)';
}
