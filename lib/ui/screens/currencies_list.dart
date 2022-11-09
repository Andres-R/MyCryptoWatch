import 'package:crypto_prices/cubit/asset_cubit.dart';
import 'package:crypto_prices/cubit/favorite_item_cubit.dart';
import 'package:crypto_prices/data/models/asset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cards/asset_card.dart';

class CurrenciesList extends StatefulWidget {
  const CurrenciesList({
    Key? key,
    required this.userID,
    required this.sortCriteria,
  }) : super(key: key);

  final int userID;
  final String sortCriteria;

  @override
  State<CurrenciesList> createState() => _CurrenciesListState();
}

class _CurrenciesListState extends State<CurrenciesList> {
  late AssetCubit _assetCubit;

  @override
  void initState() {
    super.initState();
    _assetCubit = AssetCubit();
  }

  int sortComparison(Asset a, Asset b) {
    if (widget.sortCriteria == 'Price') {
      if (a.price < b.price) {
        return 1;
      } else if (a.price > b.price) {
        return -1;
      } else {
        return 0;
      }
    } else {
      if (a.marketCap < b.marketCap) {
        return 1;
      } else if (a.marketCap > b.marketCap) {
        return -1;
      } else {
        return 0;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AssetCubit>(
      create: (context) => _assetCubit,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.black,
          centerTitle: true,
          automaticallyImplyLeading: true,
          title: Text(
            widget.sortCriteria,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ),
        body: Container(
          color: Colors.black,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              children: [
                BlocBuilder<AssetCubit, AssetState>(
                  builder: (_, assetState) {
                    List<Asset> assets = [];
                    for (Asset a in assetState.assets) {
                      assets.add(a);
                    }
                    assets.sort(sortComparison);
                    return BlocBuilder<FavoriteItemCubit, FavoriteItemState>(
                      builder: (_, favoriteState) {
                        return Column(
                          children: [
                            ...List.generate(
                              assets.length,
                              (index) {
                                bool isFavorited = false;
                                for (Map map in favoriteState.assets) {
                                  if (map['currencySymbol'] ==
                                      assets[index].symbol) {
                                    isFavorited = true;
                                  }
                                }
                                Asset asset = assets[index];
                                return BlocProvider.value(
                                  value: BlocProvider.of<FavoriteItemCubit>(
                                      context),
                                  child: AssetCard(
                                    asset: asset,
                                    isFavorited: isFavorited,
                                    userID: widget.userID,
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
