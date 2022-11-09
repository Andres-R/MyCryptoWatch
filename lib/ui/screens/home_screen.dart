import 'package:crypto_prices/ui/screens/watch_list_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
    required this.userID,
  }) : super(key: key);

  final int userID;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return WatchListScreen(userID: widget.userID);
  }
}
