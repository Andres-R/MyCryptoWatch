//import 'dart:html';

import 'package:bloc/bloc.dart';
import 'package:crypto_prices/data/data_service.dart';
import 'package:crypto_prices/data/models/asset.dart';
import 'package:meta/meta.dart';

part 'asset_state.dart';

class AssetCubit extends Cubit<AssetState> {
  AssetCubit() : super(const AssetState(assets: [])) {
    initializeAssets();
  }

  DataService dataService = DataService();

  void initializeAssets() async {
    List<Asset> assets = await dataService.getCryptos();
    emit(AssetState(assets: assets));
  }
}
