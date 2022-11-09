import 'package:crypto_prices/data/logos.dart';
import 'package:flutter/material.dart';

class FavoriteItemCard extends StatelessWidget {
  const FavoriteItemCard({
    Key? key,
    required this.name,
    required this.symbol,
  }) : super(key: key);

  final String name;
  final String symbol;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 16.0,
      ),
      child: Container(
        height: 150,
        width: 150,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(25)),
          color: const Color(0xFF081b4b).withOpacity(0.5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              logos.containsKey(symbol)
                  ? SizedBox(
                      height: 60,
                      child: Image.asset(
                        'assets/images/${logos[symbol]}',
                      ),
                    )
                  : Container(
                      height: 60,
                      width: 60,
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
              const Spacer(),
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              Text(
                symbol,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
