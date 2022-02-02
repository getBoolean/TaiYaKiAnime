import 'package:flutter/material.dart';

import 'taiyaki_image.dart';
import 'taiyaki_size.dart';

class Tiles extends StatelessWidget {
  final String image;
  final String title;

  // final int? id;

  final VoidCallback onTap;

  const Tiles({
    Key? key,
    required this.image,
    required this.onTap,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          height: TaiyakiSize.height * 0.15,
          width: TaiyakiSize.width * 0.9,
          child: Row(
            children: [
              TaiyakiImage(
                url: image,
                height: TaiyakiSize.height * 0.15,
                width: TaiyakiSize.height * 0.12,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: SizedBox(
                  width: TaiyakiSize.height * 0.33,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                        maxLines: 3,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SourceTiles extends StatelessWidget {
  // final String image;
  final String name;
  final String dev;

  // final int? id;

  final VoidCallback onTap;

  const SourceTiles({
    Key? key,
    // required this.image,
    required this.onTap,
    required this.name,
    this.dev = 'Taiyaki',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          height: TaiyakiSize.height * 0.15,
          width: TaiyakiSize.width * 0.9,
          child: Row(
            children: [
              // TaiyakiImage(
              //   url: image,
              //   height: TaiyakiSize.height * 0.15,
              //   width: TaiyakiSize.height * 0.12,
              // ),
              SizedBox(
                width: TaiyakiSize.height * 0.12,
                height: TaiyakiSize.height * 0.15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: SizedBox(
                  width: TaiyakiSize.height * 0.33,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 17),
                        maxLines: 3,
                      ),
                      Text(
                        dev,
                        style: const TextStyle(fontWeight: FontWeight.w400),
                        maxLines: 1,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
