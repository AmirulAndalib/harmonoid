/// This file is a part of Harmonoid (https://github.com/harmonoid/harmonoid).
///
/// Copyright © 2020-2022, Hitesh Kumar Saini <saini123hitesh@gmail.com>.
/// All rights reserved.
///
/// Use of this source code is governed by the End-User License Agreement for Harmonoid that can be found in the EULA.txt file.
///

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:harmonoid/state/lyrics.dart';
import 'package:harmonoid/state/now_playing_launcher.dart';
import 'package:libmpv/libmpv.dart';
import 'package:provider/provider.dart';

import 'package:harmonoid/core/collection.dart';
import 'package:harmonoid/core/playback.dart';
import 'package:harmonoid/models/media.dart';
import 'package:harmonoid/utils/dimensions.dart';
import 'package:harmonoid/utils/rendering.dart';
import 'package:harmonoid/utils/widgets.dart';
import 'package:harmonoid/interface/collection/track.dart';
import 'package:harmonoid/constants/language.dart';
import 'package:url_launcher/url_launcher.dart';

class NowPlayingScreen extends StatefulWidget {
  const NowPlayingScreen({Key? key}) : super(key: key);

  NowPlayingState createState() => NowPlayingState();
}

class NowPlayingState extends State<NowPlayingScreen>
    with TickerProviderStateMixin {
  double scale = 0.0;

  Widget build(BuildContext context) {
    return Consumer<Playback>(
      builder: (context, playback, _) => isDesktop
          ? Scaffold(
              body: Stack(
                children: [
                  DesktopAppBar(
                    leading: NavigatorPopButton(
                      onTap: () {
                        NowPlayingLauncher.instance.maximized = false;
                      },
                    ),
                    title: Language.instance.NOW_PLAYING,
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: desktopTitleBarHeight + kDesktopAppBarHeight,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Center(
                            child: Container(
                              constraints: BoxConstraints(
                                maxWidth: 640.0,
                                maxHeight: 640.0,
                              ),
                              padding: EdgeInsets.all(32.0),
                              child: MouseRegion(
                                onEnter: (e) => setState(() {
                                  scale = 1.0;
                                }),
                                onExit: (e) => setState(() {
                                  scale = 0.0;
                                }),
                                child: Card(
                                  clipBehavior: Clip.antiAlias,
                                  elevation: 8.0,
                                  child: LayoutBuilder(
                                    builder: (context, constraints) => Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Image(
                                          image: Collection.instance
                                              .getAlbumArt(playback
                                                  .tracks[playback.index]),
                                          fit: BoxFit.cover,
                                          height: min(constraints.maxHeight,
                                              constraints.maxWidth),
                                          width: min(constraints.maxHeight,
                                              constraints.maxWidth),
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            AnimatedScale(
                                              scale: scale,
                                              duration:
                                                  Duration(milliseconds: 100),
                                              curve: Curves.easeInOut,
                                              child: Material(
                                                color: Colors.transparent,
                                                borderRadius:
                                                    BorderRadius.circular(28.0),
                                                elevation: 4.0,
                                                child: InkWell(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          28.0),
                                                  onTap: () {
                                                    trackPopupMenuHandle(
                                                      context,
                                                      playback.tracks[
                                                          playback.index],
                                                      2,
                                                    );
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              28.0),
                                                      color: Colors.black54,
                                                    ),
                                                    height: 56.0,
                                                    width: 56.0,
                                                    child: Icon(
                                                      Icons.add,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 12.0),
                                            if (Plugins.isExternalMedia(playback
                                                .tracks[playback.index].uri))
                                              AnimatedScale(
                                                scale: scale,
                                                duration:
                                                    Duration(milliseconds: 100),
                                                curve: Curves.easeInOut,
                                                child: Material(
                                                  color: Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          28.0),
                                                  elevation: 4.0,
                                                  child: InkWell(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            28.0),
                                                    onTap: () {
                                                      launch(playback
                                                          .tracks[
                                                              playback.index]
                                                          .uri
                                                          .toString());
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(28.0),
                                                        color: Colors.black54,
                                                      ),
                                                      height: 56.0,
                                                      width: 56.0,
                                                      child: Icon(
                                                        Icons.launch,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        VerticalDivider(
                          width: 1.0,
                          thickness: 1.0,
                        ),
                        Expanded(
                          child: DefaultTabController(
                            length: 2,
                            child: Column(
                              children: [
                                Material(
                                  color: Colors.transparent,
                                  child: TabBar(
                                    unselectedLabelColor: Theme.of(context)
                                        .textTheme
                                        .headline1
                                        ?.color,
                                    labelStyle: Theme.of(context)
                                        .textTheme
                                        .headline4
                                        ?.copyWith(
                                            color:
                                                Theme.of(context).primaryColor),
                                    indicatorColor:
                                        Theme.of(context).primaryColor,
                                    labelColor: Theme.of(context).primaryColor,
                                    tabs: [
                                      Tab(
                                        text: Language.instance.COMING_UP
                                            .toUpperCase(),
                                      ),
                                      Tab(
                                        text: Language.instance.LYRICS
                                            .toUpperCase(),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  thickness: 1.0,
                                  height: 1.0,
                                ),
                                Expanded(
                                  child: TabBarView(
                                    children: [
                                      CustomListView(
                                        children: segment.map((track) {
                                          final index = segment.indexOf(track);
                                          return Material(
                                            color: Colors.transparent,
                                            child: TrackTile(
                                              leading: Text(
                                                '${index + 1}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline4,
                                              ),
                                              track: track,
                                              index: 0,
                                              onPressed: () {
                                                playback.jump(playback.tracks
                                                    .indexOf(track));
                                              },
                                              disableContextMenu: true,
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                      Consumer<Lyrics>(
                                        builder: (context, lyrics, _) => lyrics
                                                .current.isNotEmpty
                                            ? CustomListView(
                                                shrinkWrap: true,
                                                padding: EdgeInsets.all(16.0),
                                                children: lyrics.current
                                                    .map(
                                                      (lyric) => Text(
                                                        lyric.words,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline4,
                                                        textAlign:
                                                            TextAlign.start,
                                                      ),
                                                    )
                                                    .toList(),
                                              )
                                            : Center(
                                                child: Text(
                                                  Language.instance
                                                      .LYRICS_NOT_FOUND,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline4,
                                                  textAlign: TextAlign.start,
                                                ),
                                              ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : Container(),
    );
  }

  List<Track> get segment {
    if (Playback.instance.tracks.isEmpty ||
        Playback.instance.index < 0 ||
        Playback.instance.index >= Playback.instance.tracks.length) return [];
    return Playback.instance.tracks
        .skip(Playback.instance.index)
        .take(20)
        .toList();
  }
}
