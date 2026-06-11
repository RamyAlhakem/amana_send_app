import 'package:amana_send/app/views/main_pages/home/widgets/cached_network_img_app.dart';
import 'package:amana_send/app/views/main_pages/provider/calculator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Sliders extends StatelessWidget {
  const Sliders({super.key});

  @override
  Widget build(BuildContext context) {
    final calculater = Provider.of<Calculator>(context);

    if (calculater.sliders.isEmpty) {
      return const SizedBox.shrink();
    }

    // final sliderHeight = kIsWeb ? 400.0 : 200.0;

    return SizedBox(
      width: double.infinity,
      height: 200.0,
      child: CarouselSlider(
        options: CarouselOptions(
          height: 200.0,
          viewportFraction: 1,
          autoPlay: true,
          enableInfiniteScroll: true,
        ),
        items: calculater.sliders
            .map((e) => SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: CachedNetworkImageApp(
                    urlImg: e.picUrl,
                  ),
                ))
            .toList(),
      ),
    );
  }
}
