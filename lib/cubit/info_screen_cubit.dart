//import 'dart:html';

import 'package:bloc/bloc.dart';
import 'package:crypto_prices/data/data_service.dart';
import 'package:crypto_prices/data/models/asset.dart';
import 'package:meta/meta.dart';

part 'info_screen_state.dart';

class InfoScreenCubit extends Cubit<InfoScreenState> {
  InfoScreenCubit({
    required this.symbol,
  }) : super(
          InfoScreenState(
            asset: Asset(
              id: 1,
              name: 'name',
              symbol: 'symbol',
              price: 1.0,
              percentChange1Hour: 0.0,
              percentChange24Hour: 0.0,
              percentChange7Day: 0.0,
              percentChange30Day: 0.0,
              percentChange60Day: 0.0,
              percentChange90Day: 0.0,
              marketCap: 0.0,
              marketCapDominance: 0.0,
              fullyDilutedMarketCap: 0.0,
              volume24h: 0.0,
              percentVolumeChange24h: 0.0,
              maxSupply: 0.0,
              circulatingSupply: 0.0,
              totalSupply: 0.0,
              cmcRank: 1,
            ),
          ),
        ) {
    initializeInfo(symbol);
  }

  DataService dataService = DataService();
  String symbol;

  void initializeInfo(String symbol) async {
    Asset asset = await dataService.getAssetInformation(symbol);
    emit(InfoScreenState(asset: asset));
  }
}
