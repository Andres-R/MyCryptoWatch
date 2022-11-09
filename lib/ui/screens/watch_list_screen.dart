import 'package:crypto_prices/cubit/favorite_item_cubit.dart';
import 'package:crypto_prices/data/logos.dart';
import 'package:crypto_prices/ui/cards/favorite_item_card.dart';
import 'package:crypto_prices/ui/screens/currencies_list.dart';
import 'package:crypto_prices/ui/screens/favorite_item_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WatchListScreen extends StatefulWidget {
  const WatchListScreen({
    Key? key,
    required this.userID,
  }) : super(key: key);

  final int userID;

  @override
  State<WatchListScreen> createState() => _WatchListScreenState();
}

class _WatchListScreenState extends State<WatchListScreen> {
  late FavoriteItemCubit _favoriteItemCubit;

  @override
  void initState() {
    super.initState();
    _favoriteItemCubit = FavoriteItemCubit(userID: widget.userID);
  }

  // int mySortComparison(Asset a, Asset b) {
  //   if (a.marketCap < b.marketCap) {
  //     return 1;
  //   } else if (a.marketCap > b.marketCap) {
  //     return -1;
  //   } else {
  //     return 0;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<FavoriteItemCubit>(
          create: (context) => _favoriteItemCubit,
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.black,
          title: const AppBarTitle(),
        ),
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
                const SizedBox(height: 30),
                const LogoCollection(),
                const SizedBox(height: 30),
                const Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 48.0,
                  ),
                  child: Center(
                    child: Text(
                      'View all of your favorite cryptocurrencies from one place',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: const [
                      Text(
                        'Favorites',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                ),
                BlocBuilder<FavoriteItemCubit, FavoriteItemState>(
                  builder: (_, state) {
                    if (state.assets.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(
                          child: Text(
                            'Add currencies to your favorites list and setup custom notifications',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            ...List.generate(
                              state.assets.length,
                              (index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) {
                                          return BlocProvider.value(
                                            value: _favoriteItemCubit,
                                            child: FavoriteItemScreen(
                                              name: state.assets[index]
                                                  ['currencyName'],
                                              symbol: state.assets[index]
                                                  ['currencySymbol'],
                                              isFavorited: true,
                                              userID: widget.userID,
                                              screenID: state.assets[index]
                                                  ['id'],
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  child: FavoriteItemCard(
                                    name: state.assets[index]['currencyName'],
                                    symbol: state.assets[index]
                                        ['currencySymbol'],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: const [
                      Text(
                        'View cryptocurrencies',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) {
                            return BlocProvider.value(
                              value: _favoriteItemCubit,
                              child: CurrenciesList(
                                userID: widget.userID,
                                sortCriteria: 'Marketcap',
                              ),
                            );
                          },
                        ),
                      );
                    },
                    child: const ButtonContainer(title: 'Marketcap'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) {
                            return BlocProvider.value(
                              value: _favoriteItemCubit,
                              child: CurrenciesList(
                                userID: widget.userID,
                                sortCriteria: 'Price',
                              ),
                            );
                          },
                        ),
                      );
                    },
                    child: const ButtonContainer(title: 'Price'),
                  ),
                ),

                // BlocBuilder<AssetCubit, AssetState>(
                //   builder: (_, assetState) {
                //     List<Asset> assets = [];
                //     for (Asset a in assetState.assets) {
                //       assets.add(a);
                //     }
                //     assets.sort(mySortComparison);
                //     return BlocBuilder<FavoriteItemCubit, FavoriteItemState>(
                //       builder: (_, favoriteState) {
                //         return Column(
                //           children: [
                //             ...List.generate(
                //               assets.length,
                //               (index) {
                //                 bool isFavorited = false;
                //                 for (Map map in favoriteState.assets) {
                //                   if (map['currencySymbol'] ==
                //                       assets[index].symbol) {
                //                     isFavorited = true;
                //                   }
                //                 }
                //                 Asset asset = assets[index];
                //                 return BlocProvider.value(
                //                   value: _favoriteItemCubit,
                //                   child: AssetCard(
                //                     asset: asset,
                //                     isFavorited: isFavorited,
                //                   ),
                //                 );
                //               },
                //             ),
                //           ],
                //         );
                //       },
                //     );
                //   },
                // ),
                // -----
                //
                //
                // -----
                // BlocBuilder<AssetCubit, AssetState>(
                //   builder: (_, assetState) {
                //     return BlocConsumer<FavoriteItemCubit, FavoriteItemState>(
                //       listener: (_, listenState) {
                //         if (listenState.rebuildFavorites) {
                //           _assetCubit.rebuild();
                //           //_favoriteItemCubit.rebuildFavorites();
                //         }
                //       },
                //       builder: (_, favoriteState) {
                //         List<Asset> assets = [];
                //         for (Asset a in assetState.assets) {
                //           assets.add(a);
                //         }
                //         assets.sort(mySortComparison);
                //         return Column(
                //           children: [
                //             ...List.generate(
                //               assets.length,
                //               (index) {
                //                 bool isFavorited = false;
                //                 for (Map map in favoriteState.assets) {
                //                   if (map['currencySymbol'] ==
                //                       assets[index].symbol) {
                //                     isFavorited = true;
                //                   }
                //                 }
                //                 Asset asset = assets[index];
                //                 return BlocProvider.value(
                //                   value: _favoriteItemCubit,
                //                   child: AssetCard(
                //                     asset: asset,
                //                     isFavorited: isFavorited,
                //                   ),
                //                 );
                //               },
                //             ),
                //           ],
                //         );
                //       },
                //     );
                //   },
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LogoCollection extends StatelessWidget {
  const LogoCollection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double cheight = 300;
    double dith = MediaQuery.of(context).size.width;

    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        Container(
          height: cheight,
          //color: Colors.blue,
        ),
        SizedBox(
          height: 80,
          child: Image.asset(
            'assets/images/${logos['BTC']}',
          ),
        ),
        Positioned(
          bottom: cheight * 0.4,
          right: dith * 0.2,
          child: RotationTransition(
            turns: const AlwaysStoppedAnimation(15 / 360),
            child: SizedBox(
              height: 60,
              child: Image.asset(
                'assets/images/${logos['SOL']}',
              ),
            ),
          ),
        ),
        Positioned(
          bottom: cheight * 0.6,
          left: dith * 0.2,
          child: RotationTransition(
            turns: const AlwaysStoppedAnimation(-15 / 360),
            child: SizedBox(
              height: 60,
              child: Image.asset(
                'assets/images/${logos['USDT']}',
              ),
            ),
          ),
        ),
        Positioned(
          bottom: cheight * 0.25,
          left: dith * 0.2,
          child: RotationTransition(
            turns: const AlwaysStoppedAnimation(-5 / 360),
            child: SizedBox(
              height: 90,
              child: Image.asset(
                'assets/images/${logos['ETH']}',
              ),
            ),
          ),
        ),
        Positioned(
          top: cheight * 0.15,
          right: dith * 0.25,
          child: RotationTransition(
            turns: const AlwaysStoppedAnimation(-5 / 360),
            child: SizedBox(
              height: 70,
              child: Image.asset(
                'assets/images/${logos['BNB']}',
              ),
            ),
          ),
        ),
        Positioned(
          top: cheight * 0.15,
          right: dith * 0.25,
          child: RotationTransition(
            turns: const AlwaysStoppedAnimation(-5 / 360),
            child: SizedBox(
              height: 70,
              child: Image.asset(
                'assets/images/${logos['BNB']}',
              ),
            ),
          ),
        ),
        Positioned(
          bottom: cheight * 0.15,
          right: dith * 0.5,
          child: RotationTransition(
            turns: const AlwaysStoppedAnimation(20 / 360),
            child: SizedBox(
              height: 50,
              child: Image.asset(
                'assets/images/${logos['AVAX']}',
              ),
            ),
          ),
        ),
        Positioned(
          bottom: cheight * 0.20,
          left: dith * 0.57,
          child: RotationTransition(
            turns: const AlwaysStoppedAnimation(20 / 360),
            child: SizedBox(
              height: 50,
              child: Image.asset(
                'assets/images/${logos['ADA']}',
              ),
            ),
          ),
        ),
        Positioned(
          bottom: cheight * 0.12,
          right: dith * 0.2,
          child: RotationTransition(
            turns: const AlwaysStoppedAnimation(110 / 360),
            child: SizedBox(
              height: 40,
              child: Image.asset(
                'assets/images/${logos['MATIC']}',
              ),
            ),
          ),
        ),
        Positioned(
          top: cheight * 0.15,
          left: dith * 0.4,
          child: RotationTransition(
            turns: const AlwaysStoppedAnimation(0 / 360),
            child: SizedBox(
              height: 50,
              child: Image.asset(
                'assets/images/${logos['FLOW']}',
              ),
            ),
          ),
        ),
        Positioned(
          top: cheight * 0.4,
          left: dith * 0.1,
          child: RotationTransition(
            turns: const AlwaysStoppedAnimation(0 / 360),
            child: SizedBox(
              height: 50,
              child: Image.asset(
                'assets/images/${logos['APE']}',
              ),
            ),
          ),
        ),
        Positioned(
          bottom: cheight * 0.2,
          left: dith * 0.15,
          child: RotationTransition(
            turns: const AlwaysStoppedAnimation(-30 / 360),
            child: SizedBox(
              height: 40,
              child: Image.asset(
                'assets/images/${logos['DOGE']}',
              ),
            ),
          ),
        ),
        Positioned(
          top: cheight * 0.3,
          right: dith * 0.15,
          child: RotationTransition(
            turns: const AlwaysStoppedAnimation(-20 / 360),
            child: SizedBox(
              height: 30,
              child: Image.asset(
                'assets/images/${logos['DOT']}',
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ButtonContainer extends StatelessWidget {
  const ButtonContainer({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFF081b4b).withOpacity(0.5),
        borderRadius: const BorderRadius.all(
          Radius.circular(25),
        ),
        // gradient: LinearGradient(
        //   begin: Alignment.topLeft,
        //   end: Alignment.bottomRight,
        //   colors: [
        //     Color(0xFF081b4b),
        //     Colors.black,
        //     Color(0xFF081b4b),
        //   ],
        // ),
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}

class AppBarTitle extends StatelessWidget {
  const AppBarTitle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [
        Text(
          'CryptoWatch',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        Text(
          'Today',
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
