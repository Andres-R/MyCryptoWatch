part of 'favorite_item_cubit.dart';

class FavoriteItemState extends Equatable {
  const FavoriteItemState({
    required this.assets,
  });

  final List<Map<String, dynamic>> assets;

  @override
  List<Object> get props => [assets];
}
