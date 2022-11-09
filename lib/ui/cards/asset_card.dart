import 'package:crypto_prices/cubit/favorite_item_cubit.dart';
import 'package:crypto_prices/data/database/database_controller.dart';
import 'package:crypto_prices/data/models/asset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:crypto_prices/data/logos.dart';

class AssetCard extends StatefulWidget {
  const AssetCard({
    Key? key,
    required this.asset,
    required this.isFavorited,
    required this.userID,
  }) : super(key: key);

  final Asset asset;
  final bool isFavorited;
  final int userID;

  @override
  State<AssetCard> createState() => _AssetCardState();
}

class _AssetCardState extends State<AssetCard> {
  DatabaseController db = DatabaseController();
  late bool isFavorited;
  bool hasBeenPressed = false;
  double cardHeight = 80;

  @override
  void initState() {
    super.initState();
    isFavorited = widget.isFavorited;
  }

  Color determineColor(double percentage) {
    if (percentage > 0) {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }

  IconData determineIcon(double percentage) {
    if (percentage > 0) {
      return Icons.call_made_rounded;
    } else {
      return Icons.call_received_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat.currency(locale: 'en_US', symbol: '');

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8.0,
      ),
      child: GestureDetector(
        onTap: () {
          setState(() {
            hasBeenPressed = !hasBeenPressed;
            cardHeight = hasBeenPressed ? 200 : 80;
          });
        },
        child: Container(
          height: cardHeight,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(25),
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.black,
                Color(0xFF081b4b),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        logos.containsKey(widget.asset.symbol)
                            ? SizedBox(
                                height: 30,
                                child: Image.asset(
                                  'assets/images/${logos[widget.asset.symbol]}',
                                ),
                              )
                            : Container(
                                height: 30,
                                width: 30,
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
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.asset.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.asset.symbol,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '\$${numberFormat.format(widget.asset.price)}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  '${widget.asset.percentChange24Hour.toStringAsFixed(2)}%',
                                  style: TextStyle(
                                    color: determineColor(
                                      widget.asset.percentChange24Hour,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  determineIcon(
                                    widget.asset.percentChange24Hour,
                                  ),
                                  color: determineColor(
                                    widget.asset.percentChange24Hour,
                                  ),
                                  size: 16,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () async {
                            bool isInList =
                                await db.checkForFavoriteItem(widget.asset);
                            setState(() {
                              if (isInList) {
                                isFavorited = false;
                                BlocProvider.of<FavoriteItemCubit>(context)
                                    .removeFavoriteItem(
                                  widget.asset,
                                  widget.userID,
                                );
                              } else {
                                isFavorited = true;
                                BlocProvider.of<FavoriteItemCubit>(context)
                                    .addFavoriteItem(
                                  widget.asset,
                                  widget.userID,
                                );
                              }
                            });
                          },
                          child: Container(
                            height: 22,
                            width: 22,
                            color: Colors.transparent,
                            child: Center(
                              child: Icon(
                                isFavorited ? Icons.star : Icons.star_outline,
                                color: Colors.yellow,
                                size: 22,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                //const SizedBox(height: 16),

                //const SizedBox(height: 16),
                hasBeenPressed
                    ? Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 0,
                              vertical: 16,
                            ),
                            child: Divider(
                              color: Colors.grey.withOpacity(0.5),
                              thickness: 1,
                              height: 0,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Past hour',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    '${widget.asset.percentChange1Hour.toStringAsFixed(2)}%',
                                    style: TextStyle(
                                      color: determineColor(
                                          widget.asset.percentChange1Hour),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Today',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    '${widget.asset.percentChange24Hour.toStringAsFixed(2)}%',
                                    style: TextStyle(
                                      color: determineColor(
                                          widget.asset.percentChange24Hour),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    'This week',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    '${widget.asset.percentChange7Day.toStringAsFixed(2)}%',
                                    style: TextStyle(
                                      color: determineColor(
                                          widget.asset.percentChange7Day),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    '30 days',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    '${widget.asset.percentChange30Day.toStringAsFixed(2)}%',
                                    style: TextStyle(
                                      color: determineColor(
                                          widget.asset.percentChange30Day),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    '60 days',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    '${widget.asset.percentChange60Day.toStringAsFixed(2)}%',
                                    style: TextStyle(
                                      color: determineColor(
                                          widget.asset.percentChange60Day),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    '90 days',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    '${widget.asset.percentChange90Day.toStringAsFixed(2)}%',
                                    style: TextStyle(
                                      color: determineColor(
                                          widget.asset.percentChange90Day),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
