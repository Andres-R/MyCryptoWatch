part of 'info_screen_cubit.dart';

class InfoScreenState {
  const InfoScreenState({
    required this.asset,
  });

  final Asset asset;

  @override
  List<Object> get props => [asset];
}
