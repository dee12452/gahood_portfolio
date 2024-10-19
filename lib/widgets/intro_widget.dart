import 'package:flutter/material.dart';
import 'package:gahood_portfolio/widgets/animated_icon.dart';
import 'package:gahood_portfolio/widgets/blinking_cursor.dart';
import 'package:gahood_portfolio/widgets/fade_in_widget.dart';
import 'package:gahood_portfolio/widgets/hover_image_button.dart';
import 'package:url_launcher/url_launcher.dart';

class IntroWidget extends StatelessWidget {
  const IntroWidget({super.key});

  Stream<MapEntry<String, bool>> textGenerator() async* {
    String text = 'Generating an awesome portfolio';
    String current = '';
    int index = 0;
    while (index != text.length) {
      await Future.delayed(const Duration(milliseconds: 50));
      current = '$current${text[index]}';
      index++;
      yield MapEntry(current, false);
    }
    for (int i = 0; i < 2; i++) {
      String text = '';
      for (int j = 0; j <= 3; j++) {
        await Future.delayed(const Duration(milliseconds: 300));
        text = '$text.';
        yield MapEntry('$current$text', false);
      }
      text = '';
      yield MapEntry(current, false);
    }
    current = '';
    yield MapEntry(current, false);
    text =
        'Adam Charlton|Software Developer|6+ years of amazing code reviews.|Loves complex systems, cooperative environments, and dogs.';
    current = '';
    index = 0;
    while (index != text.length) {
      await Future.delayed(const Duration(milliseconds: 35));
      current = '$current${text[index]}';
      index++;
      yield MapEntry(current, false);
    }
    yield MapEntry(current, true);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF212121), Color(0xFF303030)],
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        ),
      ),
      width: screenWidth,
      height: screenHeight,
      child: StreamBuilder<MapEntry<String, bool>>(
        initialData: const MapEntry('', false),
        stream: textGenerator(),
        builder: (context, snapshot) {
          final data = snapshot.data;
          final texts = (data?.key ?? '').split('|');
          final finished = (data?.value ?? false);
          final widgets = <Widget>[];
          for (int idx = 0; idx < texts.length; idx++) {
            Widget widget;
            final val = texts[idx];
            final double fontSize = idx < 2 ? 52.0 : 16.0;
            if (idx == texts.length - 1) {
              widget = Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      val,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: fontSize,
                        // adjust to your desired font size
                        fontWeight: FontWeight
                            .bold, // optional: adjust to your desired font weight
                      ),
                    ),
                  ),
                  const BlinkingCursor(
                    duration: Duration(milliseconds: 350),
                    fontSize: 32.0,
                  ),
                ],
              );
            } else {
              widget = Flexible(
                child: Text(
                  val,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: fontSize, // adjust to your desired font size
                    fontWeight: FontWeight
                        .bold, // optional: adjust to your desired font weight
                  ),
                ),
              );
            }

            widgets.add(widget);
            widgets.add(const SizedBox(
              height: 5,
            ));
          }

          return Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...widgets,
                  if (finished) ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FadeInWidget(
                          delay: Duration.zero,
                          duration: const Duration(milliseconds: 1500),
                          child: HoverImageButton(
                            imageFile: 'assets/linkedin.png',
                            onClick: () async {
                              await launchUrl(Uri.parse(
                                  'https://www.linkedin.com/in/adam-charlton-2b059039'));
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        FadeInWidget(
                          delay: Duration.zero,
                          duration: const Duration(milliseconds: 1500),
                          child: HoverImageButton(
                            imageFile: 'assets/github.png',
                            onClick: () async {
                              await launchUrl(
                                  Uri.parse('https://github.com/dee12452'));
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
              if (finished) ...[
                const Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 16.0),
                    child: ArrowIcon(
                      size: 64.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
