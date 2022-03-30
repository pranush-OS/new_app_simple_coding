import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_firebase/myProject/Screens/Screens.dart';
import 'package:flutter_firebase/myProject/home.dart';
import 'package:http/http.dart' as http;

class caterogryNews extends StatelessWidget {
  String category;
  String country;
  caterogryNews({Key? key, required this.country, required this.category})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<void> getData() async {
      String url =
          "http://newsapi.org/v2/top-headlines?category=$category&country=$country&apiKey=$ApiKey";
      http.Response response = await http.get(Uri.parse(url));
      var jsonData = jsonDecode(response.body.toString());
      return jsonData;
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'News Feed',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            Center(child: Text('Country: $country')),
            const SizedBox(
              width: 10,
            ),
            TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Categories(
                                country: country,
                              )));
                },
                child: Row(
                  children: const [
                    Text('Catergories '),
                    Icon(
                      Icons.category_outlined,
                      size: 20,
                      color: Colors.white,
                    )
                  ],
                )),
            const SizedBox(
              width: 10,
            ),
            TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Home(country: country)));
                },
                child: Row(
                  children: const [
                    Text('Home'),
                    Icon(
                      Icons.location_on_outlined,
                      size: 20,
                      color: Colors.white,
                    )
                  ],
                )),
          ],
        ),
        body: FutureBuilder(
            future: getData(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                print('Sucess1');
                print('$category');
                if (snapshot.data["status"] == "ok") {
                  return ListView.builder(
                      itemCount: snapshot.data["articles"].length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Container(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white.withOpacity(0.1),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Center(
                                      child: Text(
                                    '${snapshot.data["articles"][index]["title"]}',
                                    style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold),
                                  )),
                                  Center(
                                    child: Container(
                                      height: 200,
                                      width: 350,
                                      child: Image(
                                        image: NetworkImage(
                                            '${snapshot.data["articles"][index]["urlToImage"]}'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Text(
                                      '${snapshot.data["articles"][index]["description"]}'),
                                  Text(
                                      '${snapshot.data["articles"][index]["content"]}'),
                                  Text(
                                      'Date Published: ${snapshot.data["articles"][index]["publishedAt"]}'),
                                  Text(
                                      '${snapshot.data["articles"][index]["url"]}'),
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                } else {
                  return const AlertDialog(
                    title: Text('Alert'),
                    actions: [Text('There was an error occured')],
                  );
                }
              } else {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.green,
                  ),
                );
              }
            }));
  }
}
