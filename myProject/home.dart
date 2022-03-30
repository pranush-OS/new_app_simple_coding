import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_firebase/myProject/Screens/Screens.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  String country;
  Home({Key? key, required this.country}) : super(key: key);

  @override
  State<Home> createState() => _HomeState(country);
}

class _HomeState extends State<Home> {
  _HomeState(this.country);
  String country = 'us';
  List Countries = ['in', 'fr', 'us', 'hk', 'ru'];
  List Countries2 = ['india', 'france', 'UnitedStates', 'Hong Kong', 'russia'];
  String category = '';

  void SelectCountry() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
              child: Scaffold(
            appBar: AppBar(
                title: const Text(
              'Select Country',
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
            body: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: ListView.builder(
                  itemCount: Countries.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                country = Countries[index];
                              });
                              Navigator.pop(context);
                            },
                            child: Center(
                              child: Container(
                                height: 50,
                                width: 350,
                                child: Text('${Countries2[index]}'),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
            ),
          ));
        });
  }

  Future<void> getData() async {
    String url =
        "http://newsapi.org/v2/top-headlines?category=$category&country=$country&apiKey=$ApiKey";
    http.Response response = await http.get(Uri.parse(url));
    var jsonData = jsonDecode(response.body.toString());
    return jsonData;
  }

  @override
  Widget build(BuildContext context) {
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
                  SelectCountry();
                },
                child: Row(
                  children: const [
                    Text('Select Country'),
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
