import 'package:harmonoid/models/playable.dart';

/// Extensions for [Playable].
extension PlayableExtensions on Playable {
  /// Lyrics API name.
  String get lyricsApiName => [title, ...subtitle].join(' ');

  /// Playlist entry title.
  /// Ref: media_library/lib/src/extensions/track.dart
  String get playlistEntryTitle => [title, subtitle.join(', ')].where((e) => e.isNotEmpty).join(' • ');
}
