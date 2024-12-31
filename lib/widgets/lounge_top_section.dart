import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../config/config_prefs.dart';
import '../utils/cached_image_wrapper.dart';
import 'cards/lounge_card.dart';

class LoungeDetailScreenTopSection extends StatelessWidget {
  final String image;
  final String name;
  final Location location;
  // final bool favorited;
  LoungeDetailScreenTopSection({
    super.key,
    required this.image,
    required this.name,
    required this.location,
    // required this.favorited,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                      child: Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                    ),
                  )),
                ),
              ),
            ),
            cachedNetworkImageWrapper(
              imageUrl: image,
              imageBuilder: (context, imageProvider) => Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  // color: maincolor,
                  shape: BoxShape.circle,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.network(
                    image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              placeholderBuilder: (context, path) => Container(
                  width: MediaQuery.of(context).size.height * 0.12,
                  height: MediaQuery.of(context).size.height * 0.12,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey.withOpacity(0.2)),
                  child: Container(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.5),
                  )),
              errorWidgetBuilder: (context, path, object) => Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  // color: maincolor,
                  shape: BoxShape.circle,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.asset(
                    'assets/images/logo_${ConfigPreference.getThemeIsLight() ? "light" : 'dark'}.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            // Container(
            //   width: 50,
            //   height: 50,
            //   decoration: const BoxDecoration(
            //     // color: maincolor,
            //     shape: BoxShape.circle,
            //   ),
            //   child: ClipRRect(
            //     borderRadius: BorderRadius.circular(100),
            //     child: Image.network(
            //       'https://images.pexels.com/photos/1639557/pexels-photo-1639557.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
            //       fit: BoxFit.cover,
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: AutoSizeText(
                      'Open in Maps',
                      maxLines: 1,
                      minFontSize: 5,
                      maxFontSize: 10,
                      stepGranularity: 0.5,
                      overflow: TextOverflow.visible,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 10),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
