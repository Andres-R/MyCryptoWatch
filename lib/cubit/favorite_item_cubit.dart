import 'package:bloc/bloc.dart';
import 'package:crypto_prices/data/database/database_controller.dart';
import 'package:crypto_prices/data/models/asset.dart';
import 'package:equatable/equatable.dart';

part 'favorite_item_state.dart';

class FavoriteItemCubit extends Cubit<FavoriteItemState> {
  FavoriteItemCubit({
    required this.userID,
  }) : super(const FavoriteItemState(assets: [])) {
    initializeFavoriteItems();
  }

  DatabaseController dbController = DatabaseController();
  int userID;

  void initializeFavoriteItems() async {
    List<Map<String, dynamic>> items =
        await dbController.getFavoriteItems(userID);
    emit(FavoriteItemState(assets: items));
  }

  void addFavoriteItem(Asset asset, int userID) async {
    bool isInList = await dbController.checkForFavoriteItem(asset);
    if (!isInList) {
      await dbController.addFavoriteItem(asset, userID);
      List<Map<String, dynamic>> items =
          await dbController.getFavoriteItems(userID);
      emit(FavoriteItemState(assets: items));
    }
  }

  void addFavoriteItemSymbol(String name, String symbol, int userID) async {
    bool isInList = await dbController.checkForFavoriteItemSymbol(symbol);
    if (!isInList) {
      await dbController.addFavoriteItemSymbol(name, symbol, userID);
      List<Map<String, dynamic>> items =
          await dbController.getFavoriteItems(userID);
      emit(FavoriteItemState(assets: items));
    }
  }

  void removeFavoriteItem(Asset asset, int userID) async {
    bool isInList = await dbController.checkForFavoriteItem(asset);
    if (isInList) {
      await dbController.removeFavoriteItem(asset, userID);
      await dbController.deleteNotificationSettings(asset.symbol);
      List<Map<String, dynamic>> items =
          await dbController.getFavoriteItems(userID);
      emit(FavoriteItemState(assets: items));
    }
  }

  void removeFavoriteItemSymbol(String symbol, int userID) async {
    bool isInList = await dbController.checkForFavoriteItemSymbol(symbol);
    if (isInList) {
      await dbController.removeFavoriteItemSymbol(symbol, userID);
      await dbController.deleteNotificationSettings(symbol);
      List<Map<String, dynamic>> items =
          await dbController.getFavoriteItems(userID);
      emit(FavoriteItemState(assets: items));
    }
  }

  void rebuildFavorites() async {
    List<Map<String, dynamic>> items =
        await dbController.getFavoriteItems(userID);
    emit(FavoriteItemState(assets: items));
  }
}
