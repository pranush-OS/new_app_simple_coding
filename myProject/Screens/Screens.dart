import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase/myProject/Screens/categorynews.dart';

class Categories extends StatefulWidget {
  String country;
  Categories({Key? key, required this.country}) : super(key: key);

  @override
  State<Categories> createState() => _CategoriesState(country);
}

class _CategoriesState extends State<Categories> {
  String country;
  _CategoriesState(this.country);
  @override
  Widget build(BuildContext context) {
    Future<List> getData() async {
      var jsonData = await rootBundle.loadString('assets/json/categories.json');
      var newData = json.decode(jsonData.toString());
      var list = newData as List<dynamic>;
      return list;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Select Catergories',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: FutureBuilder(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => caterogryNews(
                                        category: snapshot.data[index]["title"],
                                        country: country,
                                      )));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 300,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16)),
                            child: Stack(children: [
                              Image(
                                image: NetworkImage(
                                    '${snapshot.data[index]["imageUrl"]}'),
                                fit: BoxFit.cover,
                              ),
                              Center(
                                child: Text(
                                  '${snapshot.data[index]["title"]}',
                                  style: const TextStyle(
                                      fontSize: 50,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ]),
                          ),
                        ),
                      );
                    }),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
