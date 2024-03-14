import 'package:adaptive_layouts/adaptive_layouts.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:media_library/media_library.dart' hide MediaLibrary;

import 'package:harmonoid/utils/constants.dart';
import 'package:harmonoid/utils/rendering.dart';
import 'package:harmonoid/utils/widgets.dart';

class ArtistItem extends StatelessWidget {
  final Artist artist;
  final double width;
  final double height;
  ArtistItem({
    super.key,
    required this.artist,
    required this.width,
    required this.height,
  });

  late final title = artist.artist.isNotEmpty ? artist.artist : kDefaultArtist;

  Widget _buildDesktopLayout(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Column(
        children: [
          Hero(
            tag: artist,
            child: Card(
              margin: EdgeInsets.zero,
              clipBehavior: Clip.antiAlias,
              shape: const CircleBorder(),
              child: Container(
                width: width,
                height: width,
                padding: const EdgeInsets.all(4.0),
                child: ClipOval(
                  child: Material(
                    child: InkWell(
                      onTap: () {
                        // TODO:
                      },
                      child: ScaleOnHover(
                        child: Ink.image(
                          width: width,
                          height: width,
                          fit: BoxFit.cover,
                          image: cover(
                            item: artist,
                            cacheWidth: (width * MediaQuery.of(context).devicePixelRatio).toInt(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: width,
              alignment: Alignment.center,
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleSmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    throw UnimplementedError();
  }

  Widget _buildMobileLayout(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Column(
        children: [
          Hero(
            tag: artist,
            child: OpenContainer(
              transitionDuration: Theme.of(context).extension<AnimationDuration>()?.medium ?? Duration.zero,
              closedColor: Theme.of(context).cardTheme.color ?? Colors.transparent,
              closedShape: const CircleBorder(),
              closedElevation: Theme.of(context).cardTheme.elevation ?? 0.0,
              openElevation: Theme.of(context).cardTheme.elevation ?? 0.0,
              closedBuilder: (context, action) {
                return Stack(
                  children: [
                    Container(
                      width: width,
                      height: width,
                      padding: const EdgeInsets.all(4.0),
                      child: ClipOval(
                        child: Image(
                          width: width,
                          height: width,
                          fit: BoxFit.cover,
                          image: cover(
                            item: artist,
                            cacheWidth: (width * MediaQuery.of(context).devicePixelRatio).toInt(),
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: action,
                        ),
                      ),
                    ),
                  ],
                );
              },
              openBuilder: (context, action) => const SizedBox.shrink(),
            ),
          ),
          Expanded(
            child: Container(
              width: width,
              alignment: Alignment.center,
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleSmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isDesktop) {
      return _buildDesktopLayout(context);
    }
    if (isTablet) {
      return _buildTabletLayout(context);
    }
    if (isMobile) {
      return _buildMobileLayout(context);
    }
    throw UnimplementedError();
  }
}
