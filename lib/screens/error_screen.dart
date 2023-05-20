import 'package:flutter/material.dart';
import '../utils/class.dart';
import '../widgets/description_container_widget.dart';

class ErrorPage extends StatefulWidget {
  const ErrorPage({super.key});

  @override
  State<ErrorPage> createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favoriler"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            favoritedList.length != 0 ? Column(
              children: [
                for (int i = 0; i < favoritedList.length; i += 2)
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: DescriptionContainer(favoritedList[i], favoritedList[i + 1]),
                  )
              ],
            ) : Text("Favori Listesi Boş!"),
          ],
        ),
      ),
    );
  }
}