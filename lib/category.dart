import 'package:flutter/material.dart';

import 'main.dart';

class Category extends StatelessWidget {
  Category(this.name);
  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Search()),
            );
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "♬" + name + "♬",
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(height: 20),
              Container(
                width: 600,
                child: Table(
                  columnWidths: <int, TableColumnWidth>{
                    0: FixedColumnWidth(30),
                    1: FixedColumnWidth(300),
                    2: FixedColumnWidth(150),
                  },
                  border: TableBorder.all(),
                  children: [
                    for (int i = 0; i < 100; i++)
                      TableRow(
                        children: <Widget>[
                          Text('${i + 1}', textAlign: TextAlign.center),
                          Text("title", textAlign: TextAlign.center),
                          Text("artist", textAlign: TextAlign.center),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
