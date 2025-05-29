import 'package:amana_send/app/views/main_pages/home/widgets/cached_network_img_app.dart';
import 'package:amana_send/app/views/main_pages/provider/calculator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Sliders extends StatelessWidget {
  const Sliders({super.key});

  @override
  Widget build(BuildContext context) {
    final calculater = Provider.of<Calculator>(context);
 
    return SizedBox(
      width: double.infinity,
      height: 200,
      child: PageView(
        controller: calculater.pageController,
        children: calculater.sliders
            .map((e) => CachedNetworkImageApp(
                  urlImg: e.picUrl,
                ))
            .toList(),
      ),
    );
  }
}
