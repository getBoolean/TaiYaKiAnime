import 'package:flutter/material.dart';

import '../../models/taiyaki/sync.dart';
import 'taiyaki_image.dart';
import 'taiyaki_size.dart';

class AnimeListStatusCards extends StatelessWidget {
  final String statusName;
  final List<AnimeListModel> data;
  final VoidCallback onTap;

  const AnimeListStatusCards(
      {Key? key, required this.statusName, required this.onTap, this.data = const []}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 6,
        child: Container(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(statusName,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(data.length.toString() + ' total items'),
                    ]),
              ),
              SizedBox(
                height: TaiyakiSize.height * 0.13,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 4.0, vertical: 2.0),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: List.generate(3, (index) {
                      if (data.length >= 3) return data[index];
                      return data.first;
                    })
                        .map((i) => Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 2.0,
                                vertical: 2.0,
                              ),
                              child: TaiyakiImage(
                                  url: i.coverImage,
                                  width: TaiyakiSize.height * 0.09,
                                  height: TaiyakiSize.height * 0.05),
                            ))
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
