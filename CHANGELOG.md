## 1.x.x - WIP
- Implement `getSrt` a video closed captions in srt format.
- Only throw custom exceptions from the library.
- `getUploadsFromPage` no longer throws.

## 1.6.0
- BREAKING CHANGE: Renamed `getVideosAsync` to `getVideos`.
- Implemented `getVideosFromPage` which supersedes `queryFromPage`.
- Implemented JSON Classes for reverse engineer.
- Added `forceWatchPage` to the video client to assure the fetching of the video page. (ATM useful only if using the comments api)
- Remove adaptive streams. These are not used anymore.
- Implement `channelClient.getAboutPage` and `getAboutPageByUsername` to fetch data from a channel's about page.

## 1.5.2
- Fix extraction for same videos (#76)

## 1.5.1
- Fix Video Search: https://github.com/Tyrrrz/YoutubeExplode/issues/438

## 1.5.0
- BREAKING CHANGE: Renamed `Container` class to `StreamContainer` to avoid conflicting with Flutter `Container`. See #66

## 1.4.4
- Expose HttpClient in APIs
- Fix #55: Typo in README.md
- Fix #61: DartVM when the YouTube explode client is closed.

## 1.4.3
- Fix #59
- Implement for tests #47
- Better performance for VideoClient.get

## 1.4.2
- Fix Decipher error #53

## 1.4.1+3
- Fix decipherer

## 1.4.1+2
- Implement Container.toString()

## 1.4.1+1
- Bug fixes

## 1.4.1
- Implement `getUploadsFromPage` to a channel uploaded videos directly from the YouTube page.

## 1.4.0
- Add ChannelId property to Video class.
- Implement `thumbnails` for playlists. The playlist's thumbnail is the same as the thumbnail of its first video. If the playlist is empty, then this property is `null`.
- Update for age restricted videos.

## 1.3.3
- Error handling when using `getStream` if the connection fails. If it fails more than 5 times on the same request the exception will be thrown anyways.
- Caching of player source for 10 minutes.

## 1.3.2
- Minor caching changes.

## 1.3.1
- Implement caching of some results.

## 1.3.0
- Added api get youtube comments of a video.

## 1.2.3
- Fix duplicated bytes when downloading a stream. See [#41][Comment41]

## 1.2.2
- Momentarily ignore `isRateLimited()` when getting streams.

## 1.2.1

- Fixed `SearchPage.nextPage`.
- Added more tests.

## 1.2.0
- Improved documentation.
- Deprecated `StreamInfoExt.getHighestBitrate`, use list.`sortByBitrate`.
- Implemented `withHighestBitrate` and `sortByBitrate` for `StreamInfo` iterables.
- Implemented `withHighestBitrate` for `VideoStreamInfo` iterables.
- Now `sortByVideoQuality` returns a List of `T`.
- `SearchQuery.nextPage` now returns null if there is no next page. 

## 1.1.0
- Implement parsing of the search page to retrieve information from youtube searches. See `SearchQuery`.


## 1.0.0
- Stable release

---

## 1.0.0-beta

- Updated to v5 of YouTube Explode for C#

## 1.0.1-beta

- Implement `SearchClient`.
- Implement `VideoStreamInfoExtension` for Iterables.
- Update `xml` dependency.
- Fixed closed caption api.

## 1.0.2-beta

- Fix video likes and dislikes count. #30
<hr>

## 0.0.1

- Initial version, created by Stagehand

## 0.0.2

- Implement channel api

## 0.0.3

- Remove `dart:io` dependency.

## 0.0.4

- Fix #3 : Head request to ge the content length
- Fix error when getting videos without any keyword.

## 0.0.5

- Implement Search Api (`SearchExtension`)

## 0.0.6

- Implement Caption Api ('CaptionExtension`)
- Add Custom Exceptions

## 0.0.7

- Implement Video Purchase error
- Implement Equatable for models

## 0.0.8

- Downgrade xml to `^3.5.0`

## 0.0.9

- Bug Fix(PR [11][11]): Use url when retrieving the video's content length.

[11]: https://github.com/Hexer10/youtube_explode_dart/pull/11

## 0.0.10

- Bug fix: Don't throw when captions are not present.
- New extension: CaptionListExtension adding `getByTime` function.

## 0.0.11

- New extension: DownloadExtension adding `downloadStream` function.

## 0.0.12

- Bug fix(#15): Fix invalid upload date.

## 0.0.13

- Bug fix(#15): Fix valid channel expression

## 0.0.14

- getChannelWatchPage and getVideoWatchPage methods are now public
- New method: getChannelIdFromVideo

## 0.0.15

- Workaround (#15): Now when a video is not available a `VideoUnavailable` exception is thrown
- Removed disable_polymer parameter when requests ( https://github.com/Tyrrrz/YoutubeExplode/issues/341 )
- Removed `dart:io` dependency

## 0.0.16

- When a video is not available(403) a `VideoStreamUnavailableException` 

## 0.0.17

- Fixed bug in #23



[Comment41]: https://github.com/Hexer10/youtube_explode_dart/issues/41#issuecomment-646974990
