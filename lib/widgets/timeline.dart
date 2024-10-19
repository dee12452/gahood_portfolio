import 'package:flutter/material.dart';
import 'package:gahood_portfolio/descriptions.dart';
import 'package:gahood_portfolio/widgets/description_text.dart';

class MyTimeline extends StatelessWidget {
  const MyTimeline({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Timeline',
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            letterSpacing: 1.2,
          ),
        ),
        SizedBox(
          width: 200,
          height: 20,
          child: Divider(
            thickness: 2,
          ),
        ),
        _TimelineItem(
          imageFile: 'assets/coupa.png',
          date: 'December 2022',
          title: 'Senior Software Engineer',
          location: 'Coupa Software - Seattle, WA (Hybrid)',
          description: coupaJobDescription,
        ),
        _TimelineItem(
          imageFile: 'assets/appomni.png',
          date: 'March 2022',
          title: 'Senior Software Engineer',
          location: 'AppOmni - Remote',
          description: appOmniJobDescription,
        ),
        _TimelineItem(
          imageFile: 'assets/appomni.png',
          date: 'August 2021',
          title: 'Software Engineer',
          location: 'GoGuardian - Remote',
          description: goguardianJobDescription,
        ),
        _TimelineItem(
          imageFile: 'assets/yapta.png',
          date: 'January 2018',
          title: 'Software Engineer',
          location: 'Yapta / Coupa - Seattle, WA (Hybrid)',
          description: yaptaJobDescription,
        ),
        _TimelineItem(
          imageFile: '',
          date: 'August 2016',
          title: 'Graduation from University',
          location: 'University of Washington - Bothell',
          description:
              'Earned a Bachelor’s of Science degree in Computer Science and Software Engineering, with an overall GPA of 3.6.',
        ),
        _TimelineItem(
          imageFile: 'assets/tecace.png',
          date: 'June 2016',
          title: 'Software Engineer',
          location: 'Tecace - Bellevue, WA',
          description: tecaceJobDescription,
        ),
      ],
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final String imageFile;
  final String date;
  final String title;
  final String location;
  final String description;

  const _TimelineItem({
    required this.imageFile,
    required this.date,
    required this.title,
    required this.location,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 2,
          height: 50,
          color: Colors.blueAccent,
        ),
        DescriptionText(text: date),
        Container(
          width: 500,
          padding: const EdgeInsets.only(top: 10, left: 20.0, right: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 2), // changes position of shadow
              ),
            ],
          ),
          child: ExpansionTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DescriptionText(
                  text: title,
                  fontSize: 22,
                ),
                DescriptionText(
                  text: location,
                  fontSize: 16,
                ),
              ],
            ),
            children: [
              DescriptionText(
                text: description,
                fontSize: 14,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
