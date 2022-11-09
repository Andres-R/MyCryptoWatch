import 'package:crypto_prices/cubit/notification_cubit.dart';
import 'package:crypto_prices/data/logos.dart';
import 'package:crypto_prices/utils/utilities.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateNotificationScreen extends StatefulWidget {
  const CreateNotificationScreen({
    Key? key,
    required this.userID,
    required this.screenID,
    required this.currencyName,
    required this.symbol,
  }) : super(key: key);

  final int userID;
  final int screenID;
  final String currencyName;
  final String symbol;

  @override
  State<CreateNotificationScreen> createState() =>
      _CreateNotificationScreenState();
}

class _CreateNotificationScreenState extends State<CreateNotificationScreen> {
  FocusNode focusNode = FocusNode();
  TextEditingController textController = TextEditingController();
  bool up = true;
  bool down = false;

  @override
  void initState() {
    super.initState();
    focusNode.addListener(
      () {
        bool hasFocus = focusNode.hasFocus;
        if (hasFocus) {
          KeyboardOverlay.showOverlay(context);
        } else {
          KeyboardOverlay.removeOverlay();
        }
      },
    );
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  void createNotification() {
    String criteria = up ? 'up' : 'down';
    String percent = textController.text;
    if (percent.length > 5) {
      //print('ERROR');
    } else if (percent.isEmpty) {
      //print('ERROR');
    } else {
      double officialPercent = double.parse(percent);
      officialPercent *= criteria == 'down' ? -1.0 : 1.0;

      BlocProvider.of<NotificationCubit>(context).addNotificationSetting(
        widget.currencyName,
        widget.symbol,
        criteria,
        officialPercent,
        widget.userID,
        widget.screenID,
      );

      Navigator.of(context).pop();
      // print('criteria: $criteria');
      // print('percent: $percent');
      // print('officialPercent: $officialPercent');
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
          'Create notification',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
      ),
      resizeToAvoidBottomInset: true,
      body: Container(
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
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              AssetLogo(symbol: widget.symbol),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    'Send a notification when the price of ${widget.currencyName} in the past 24h is ',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      // Color(0xFF222222)
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            if (up) {
                              up = false;
                            } else {
                              up = true;
                              down = false;
                            }
                          });
                        },
                        child: CriteriaOption(
                          criteria: 'Up',
                          isPressed: up,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            if (down) {
                              down = false;
                            } else {
                              down = true;
                              up = false;
                            }
                          });
                        },
                        child: CriteriaOption(
                          criteria: 'Down',
                          isPressed: down,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: CustomTextFormField(
                  controller: textController,
                  focusNode: focusNode,
                  hint: 'Percent',
                  icon: Icons.percent,
                  obscureText: false,
                  inputType: TextInputType.number,
                  enableNumberFormat: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: GestureDetector(
                  onTap: createNotification,
                  child: const CreateButton(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CreateButton extends StatelessWidget {
  const CreateButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFF081b4b).withOpacity(0.7),
        borderRadius: const BorderRadius.all(Radius.circular(25)),
      ),
      child: const Center(
        child: Text(
          'Create',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}

class InputDoneView extends StatelessWidget {
  const InputDoneView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF222222),
      child: Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
          child: CupertinoButton(
            padding: const EdgeInsets.only(right: 24.0, top: 8.0, bottom: 8.0),
            onPressed: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: const Text(
              "Done",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class KeyboardOverlay {
  static OverlayEntry? _overlayEntry;

  static showOverlay(BuildContext context) {
    if (_overlayEntry != null) {
      return;
    }

    OverlayState? overlayState = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            right: 0.0,
            left: 0.0,
            child: const InputDoneView());
      },
    );

    overlayState!.insert(_overlayEntry!);
  }

  static removeOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }
}

class CriteriaOption extends StatelessWidget {
  const CriteriaOption({
    Key? key,
    required this.criteria,
    required this.isPressed,
  }) : super(key: key);

  final String criteria;
  final bool isPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color:
            isPressed ? const Color(0xFF081b4b).withOpacity(0.7) : Colors.black,
        borderRadius: const BorderRadius.all(
          Radius.circular(25),
        ),
        border: Border.all(
          color: isPressed
              ? const Color(0xFF081b4b).withOpacity(0.7)
              : Colors.black,
          width: 1,
        ),
      ),
      child: Center(
        child: Text(
          criteria,
          style: const TextStyle(
            color: Colors.white,
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
