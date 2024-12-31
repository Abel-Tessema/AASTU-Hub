import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config/config_prefs.dart';
import '../../config/constants.dart';
import '../../utils/cached_image_wrapper.dart';

class Location {
  double longitude;
  double latitude;
  Location({required this.longitude, required this.latitude});
}

class LoungeCard extends StatelessWidget {
  final String name;
  final Location location;
  final String image;
  final String activeHours;
  final bool isAvailable;
  // final bool favorited;
  // final Function()? onHeartTap;

  const LoungeCard(
      {super.key,
      required this.name,
      required this.location,
      required this.image,
      required this.activeHours,
      // required this.favorited,
      // this.onHeartTap,
      required this.isAvailable});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: kCardShadow()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: cachedNetworkImageWrapper(
                  imageUrl: image,
                  imageBuilder: (context, imageProvider) =>
                      LargeCardImageHolder(
                    image: Image.network(
                      image,
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.15,
                      fit: BoxFit.cover,
                    ),
                  ),
                  placeholderBuilder: (context, path) => Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.15,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.grey.withOpacity(0.2)),
                      child: Container(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.5),
                      )),
                  errorWidgetBuilder: (context, path, object) =>
                      LargeCardImageHolder(
                    image: Image.asset(
                      'assets/images/logo_${ConfigPreference.getThemeIsLight() ? 'light' : 'dark'}.png',
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.15,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 15,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF4B39EF),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      isAvailable ? 'Open' : 'Closed',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    // GestureDetector(
                    //   onTap: onHeartTap,
                    //   child: Icon(
                    //     favorited
                    //         ? EneftyIcons.heart_bold
                    //         : EneftyIcons.heart_outline,
                    //     color: Theme.of(context).colorScheme.primary,
                    //   ),
                    // ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                GestureDetector(
                  onTap: () =>
                      openGoogleMaps(location.latitude, location.longitude),
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: Theme.of(context).colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: AutoSizeText(
                            'Open in Maps',
                            maxLines: 2,
                            minFontSize: 5,
                            maxFontSize: 10,
                            stepGranularity: 0.5,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.watch_later,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      activeHours,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(fontSize: 10),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LargeCardImageHolder extends StatelessWidget {
  const LargeCardImageHolder({
    super.key,
    required this.image,
  });

  final Image image;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15),
      ),
      child: image,
    );
  }
}

Future<void> openGoogleMaps(double latitude, double longitude) async {
  final String googleMapsUrl =
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

  // if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
  await launchUrl(Uri.parse(googleMapsUrl),
      mode: LaunchMode.externalApplication);
  // } else {
  //   throw 'Could not open Google Maps.';
  // }
}
