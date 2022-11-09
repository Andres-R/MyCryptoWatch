import 'package:crypto_prices/cubit/notification_cubit.dart';
import 'package:crypto_prices/data/logos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeleteNotificationScreen extends StatefulWidget {
  const DeleteNotificationScreen({
    Key? key,
    required this.userID,
    required this.screenID,
    required this.name,
    required this.symbol,
    required this.settings,
  }) : super(key: key);

  final int userID;
  final int screenID;
  final String name;
  final String symbol;
  final List<Map<String, dynamic>> settings;

  @override
  State<DeleteNotificationScreen> createState() =>
      _DeleteNotificationScreenState();
}

class _DeleteNotificationScreenState extends State<DeleteNotificationScreen> {
  int selectedsettingID = -1;
  late List<bool> cardOption;

  @override
  void initState() {
    super.initState();
    cardOption = List.generate(
      widget.settings.length,
      (index) {
        return false;
      },
    );
  }

  int getSelectedSettingID() {
    for (int i = 0; i < widget.settings.length; i++) {
      if (cardOption[i]) {
        return widget.settings[i]['id'];
      }
    }
    return -1;
  }

  void deleteSetting() {
    if (selectedsettingID == -1) {
    } else {
      BlocProvider.of<NotificationCubit>(context).deleteNotificationByID(
        selectedsettingID,
        widget.userID,
        widget.screenID,
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: const Text(
          'Delete notification',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: Colors.black,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.black,
              Colors.black,
              Color(0xFF081b4b),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              AssetLogo(symbol: widget.symbol),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    'Select a setting to delete from your ${widget.name} notification settings',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ...List.generate(
                widget.settings.length,
                (index) {
                  Map<String, dynamic> info = widget.settings[index];
                  return GestureDetector(
                    onTap: () {
                      setState(
                        () {
                          if (cardOption[index]) {
                            cardOption[index] = false;
                          } else {
                            cardOption[index] = true;
                            for (int i = 0; i < widget.settings.length; i++) {
                              if (i != index) {
                                cardOption[i] = false;
                              }
                            }
                          }
                          selectedsettingID = getSelectedSettingID();
                        },
                      );
                    },
                    child: SettingCard(
                      name: info['currencyName'],
                      criteria: info['criteria'],
                      percent: info['criteriaPercent'].toDouble(),
                      hasBeenPressed: cardOption[index] ? true : false,
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: GestureDetector(
                  onTap: deleteSetting,
                  child: const DeleteButton(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DeleteButton extends StatelessWidget {
  const DeleteButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(25)),
        color: const Color(0xFF081b4b).withOpacity(0.8),
      ),
      child: const Center(
        child: Text(
          'Delete',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}

class SettingCard extends StatefulWidget {
  const SettingCard({
    Key? key,
    required this.name,
    required this.criteria,
    required this.percent,
    required this.hasBeenPressed,
  }) : super(key: key);

  final String name;
  final String criteria;
  final double percent;
  final bool hasBeenPressed;

  @override
  State<SettingCard> createState() => _SettingCardState();
}

class _SettingCardState extends State<SettingCard> {
  @override
  Widget build(BuildContext context) {
    Color determineColor = widget.criteria == 'up' ? Colors.green : Colors.red;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: widget.hasBeenPressed
              ? const Color(0xFF081b4b).withOpacity(0.8)
              : Colors.black,
          borderRadius: const BorderRadius.all(Radius.circular(25)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Container(
                height: 25,
                width: 25,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    text:
                        'Send a notification for ${widget.name} when the price '
                        'in the past 24h is ',
                    children: [
                      TextSpan(
                        text: '${widget.criteria} ${widget.percent}%',
                        style: TextStyle(
                          color: determineColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AssetLogo extends StatelessWidget {
  const AssetLogo({
    Key? key,
    required this.symbol,
  }) : super(key: key);

  final String symbol;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: logos.containsKey(symbol)
          ? SizedBox(
              height: 120,
              child: Image.asset(
                'assets/images/${logos[symbol]}',
              ),
            )
          : Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 1,
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.question_mark,
                  color: Colors.white,
                ),
              ),
            ),
    );
  }
}
