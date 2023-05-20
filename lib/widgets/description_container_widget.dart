import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

class DescriptionContainer extends StatefulWidget {
  final String title;
  final String content;

  DescriptionContainer(this.title, this.content);

  @override
  _DescriptionContainerState createState() => _DescriptionContainerState();
}

class _DescriptionContainerState extends State<DescriptionContainer> {
  bool size = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          size = !size;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.grey),
          borderRadius: BorderRadius.circular(20),
        ),
        height: size ? MediaQuery.of(context).size.height / 2 : MediaQuery.of(context).size.height / 6,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10),
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              HtmlWidget(
                widget.content,
                textStyle: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}