part of 'asset_cubit.dart';

class AssetState {
  const AssetState({
    required this.assets,
  });

  final List<Asset> assets;

  @override
  List<Object> get props => [assets];
}
