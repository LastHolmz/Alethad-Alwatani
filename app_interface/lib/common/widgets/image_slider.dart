import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce/common/widgets/skeleton.dart';
import 'package:e_commerce/constants/global_variables.dart';

class ImageSlider extends StatefulWidget {
  final List<String?> images;
  final double width;
  final double height;
  final double indicatorWidth;
  final double indicatorHeight;

  const ImageSlider({
    super.key,
    required this.images,
    this.width = 150,
    this.height = 150,
    this.indicatorWidth = 8,
    this.indicatorHeight = 8,
  });

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  int _current = 0;

  final CarouselSliderController _controller = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    return widget.images.isEmpty
        ? Skeleton(
            height: widget.height,
            width: widget.width,
          )
        : Column(
            children: [
              CarouselSlider.builder(
                carouselController: _controller,
                itemCount: widget.images.length,
                options: CarouselOptions(
                  animateToClosest: true,
                  initialPage: widget.images.length,
                  autoPlay: true,
                  aspectRatio: 2.0,
                  enlargeCenterPage: true,
                  height: widget.height,
                  onPageChanged: (index, reason) => {
                    setState(() {
                      _current = index;
                    })
                  },
                ),
                itemBuilder: (context, index, realIdx) {
                  return ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(
                        GlobalVariables.defaultPadding,
                      ),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: widget.images[index]!,
                      fit: BoxFit.cover,
                      width: widget.width,
                      placeholder: (context, url) => Skeleton(
                        height: widget.height,
                        width: widget.width,
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.images.asMap().entries.map((entry) {
                  return GestureDetector(
                    onTap: () => _controller.animateToPage(entry.key),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: _current == entry.key
                          ? widget.indicatorWidth + 10
                          : widget.indicatorWidth,
                      height: widget.indicatorHeight,
                      margin: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 4.0,
                      ),
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(widget.width / 2),
                        color:
                            (Theme.of(context).colorScheme.primary).withOpacity(
                          _current == entry.key ? 0.9 : 0.4,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          );
  }
}
