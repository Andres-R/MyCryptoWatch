import 'dart:convert';
import 'package:crypto_prices/data/models/asset.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class DataService {
  String key1 = "172d5f64-3e8e-42ed-8728-e3616d2a5ef9";
  String key2 = "1ee1f4c0-feb3-4e5e-8d9d-7efcbb7d2d12";

  Future<List<Asset>> getCryptos() async {
    String baseURL = "https://pro-api.coinmarketcap.com/v1";
    String category = "/cryptocurrency/listings/latest";
    String parameter1 = "?cryptocurrency_type=all";
    String parameter2 = "&CMC_PRO_API_KEY=";

    String endpoint = "$baseURL$category$parameter1$parameter2$key1";
    List<Asset> currencies = [];

    try {
      Uri uri = Uri.parse(endpoint);
      Response response = await http.get(uri);
      Map<String, dynamic> json = jsonDecode(response.body);
      List<dynamic> data = json['data'];

      for (dynamic item in data) {
        int id = item['id'];
        String name = item['name'];
        String symbol = item['symbol'];

        dynamic maxSupply = item['max_supply'];
        dynamic circulatingSupply = item['circulating_supply'];
        dynamic totalSupply = item['total_supply'];
        dynamic cmcRank = item['cmc_rank'];

        Map<String, dynamic> quote = item['quote'];
        Map<String, dynamic> usd = quote['USD'];

        dynamic price = usd['price'];
        dynamic percentChange_1h = usd['percent_change_1h'];
        dynamic percentChange_24h = usd['percent_change_24h'];
        dynamic percentChange_7d = usd['percent_change_7d'];
        dynamic percentChange_30d = usd['percent_change_30d'];
        dynamic percentChange_60d = usd['percent_change_60d'];
        dynamic percentChange_90d = usd['percent_change_90d'];
        dynamic marketCap = usd['market_cap'];
        dynamic marketCapDominance = usd['market_cap_dominance'];
        dynamic fullyDilutedMarketCap = usd['fully_diluted_market_cap'];
        dynamic volume24h = usd['volume_24h'];
        dynamic percentVolumeChange24h = usd['volume_change_24h'];

        currencies.add(
          Asset(
            id: id,
            name: name,
            symbol: symbol,
            price: price,
            percentChange1Hour: percentChange_1h,
            percentChange24Hour: percentChange_24h,
            percentChange7Day: percentChange_7d,
            percentChange30Day: percentChange_30d,
            percentChange60Day: percentChange_60d,
            percentChange90Day: percentChange_90d,
            marketCap: marketCap,
            marketCapDominance: marketCapDominance,
            fullyDilutedMarketCap: fullyDilutedMarketCap,
            volume24h: volume24h,
            percentVolumeChange24h: percentVolumeChange24h,
            maxSupply: maxSupply,
            circulatingSupply: circulatingSupply,
            totalSupply: totalSupply,
            cmcRank: cmcRank,
          ),
        );
      }
    } catch (e) {
      throw e;
    }

    return currencies;
  }

  Future<Asset> getAssetInformation(String cSymbol) async {
    String baseURL = "https://pro-api.coinmarketcap.com/v2";
    String category = "/cryptocurrency/quotes/latest";
    String parameter1 = "?symbol=$cSymbol";
    String parameter2 = "&CMC_PRO_API_KEY=";

    String endpoint = "$baseURL$category$parameter1$parameter2$key1";
    Asset asset = Asset(
      id: 1,
      name: 'name',
      symbol: 'symbol',
      price: 'price',
      percentChange1Hour: 'percentChange_1h',
      percentChange24Hour: 'percentChange_24h',
      percentChange7Day: 'percentChange_7d',
      percentChange30Day: 'percentChange_30d',
      percentChange60Day: 'percentChange_60d',
      percentChange90Day: 'percentChange_90d',
      marketCap: 'marketCap',
      marketCapDominance: 'marketCapDominance',
      fullyDilutedMarketCap: 'fullyDilutedMarketCap',
      volume24h: 'volume24h',
      percentVolumeChange24h: 'percentVolumeChange24h',
      maxSupply: 'maxSupply',
      circulatingSupply: 'circulatingSupply',
      totalSupply: 'totalSupply',
      cmcRank: 1,
    );

    try {
      Uri uri = Uri.parse(endpoint);
      Response response = await http.get(uri);
      Map<String, dynamic> json = jsonDecode(response.body);
      Map<String, dynamic> data = json['data'];

      List<dynamic> info = data[cSymbol];

      Map<String, dynamic> map = info[0];

      int id = map['id'];
      String name = map['name'];
      String symbol = map['symbol'];

      dynamic maxSupply = map['max_supply'];
      dynamic circulatingSupply = map['circulating_supply'];
      dynamic totalSupply = map['total_supply'];
      dynamic cmcRank = map['cmc_rank'];

      Map<String, dynamic> quote = map['quote'];
      Map<String, dynamic> usd = quote['USD'];

      dynamic price = usd['price'];
      dynamic percentChange_1h = usd['percent_change_1h'];
      dynamic percentChange_24h = usd['percent_change_24h'];
      dynamic percentChange_7d = usd['percent_change_7d'];
      dynamic percentChange_30d = usd['percent_change_30d'];
      dynamic percentChange_60d = usd['percent_change_60d'];
      dynamic percentChange_90d = usd['percent_change_90d'];
      dynamic marketCap = usd['market_cap'];
      dynamic marketCapDominance = usd['market_cap_dominance'];
      dynamic fullyDilutedMarketCap = usd['fully_diluted_market_cap'];
      dynamic volume24h = usd['volume_24h'];
      dynamic percentVolumeChange24h = usd['volume_change_24h'];

      asset = Asset(
        id: id,
        name: name,
        symbol: symbol,
        price: price,
        percentChange1Hour: percentChange_1h,
        percentChange24Hour: percentChange_24h,
        percentChange7Day: percentChange_7d,
        percentChange30Day: percentChange_30d,
        percentChange60Day: percentChange_60d,
        percentChange90Day: percentChange_90d,
        marketCap: marketCap,
        marketCapDominance: marketCapDominance,
        fullyDilutedMarketCap: fullyDilutedMarketCap,
        volume24h: volume24h,
        percentVolumeChange24h: percentVolumeChange24h,
        maxSupply: maxSupply,
        circulatingSupply: circulatingSupply,
        totalSupply: totalSupply,
        cmcRank: cmcRank,
      );
    } catch (e) {
      throw e;
    }

    return asset;
  }
}
