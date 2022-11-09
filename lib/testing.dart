import 'package:crypto_prices/data/database/database_controller.dart';
import 'package:flutter/material.dart';

class Testing extends StatefulWidget {
  const Testing({Key? key}) : super(key: key);

  @override
  State<Testing> createState() => _TestingState();
}

class _TestingState extends State<Testing> {
  late DatabaseController db;

  @override
  void initState() {
    super.initState();
    db = DatabaseController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () async {
            print(await db.getFavoriteItems(1));
            //db.deleteDB();
          },
          child: Container(
            color: Colors.black,
            height: 100,
            width: 100,
          ),
        ),
      ),
    );
  }
}
