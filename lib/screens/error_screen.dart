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
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    backgroundColor: Theme.of(context).primaryColor,
                    title: Text("Favoriler", textAlign: TextAlign.center),
                    titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                    ),
                    content: Text(textAlign: TextAlign.center, "Bu ekranda favorileriniz gözükmektedir. Eğer uygulamayı açtıktan sonra bu ekranı görürseniz bir bağlantı problemi yaşıyorsunuz demektir. Bu sırada sizler beğenmiş olduğunuz içerikleri internetsiz bir şekilde okumaya devam edebilirsiniz."),
                    contentTextStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                    ),
                  );
                },
              );
            },
            icon: Icon(Icons.info_outline_rounded),
          ),
        ],
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
            ) : Center(child: Column(
              children: [
                SizedBox(height: 10),
                Text(
                  "Favori Listesi Boş!",
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }
}