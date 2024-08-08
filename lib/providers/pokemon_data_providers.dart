import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:pokemoncards/models/pokemon.dart';
import 'package:pokemoncards/services/database_service.dart';
import 'package:pokemoncards/services/http_service.dart';

final pokemonDataProvider =
    FutureProvider.family<Pokemon?, String>((ref, url) async {
  HttpService _httpService = GetIt.instance.get<HttpService>();
  Response? res = await _httpService.get(url);
  if (res != null && res.data != null) {
    Pokemon pokemon = Pokemon.fromJson(res.data);
    return pokemon;
  }
  return null;
});

final favoritePokemonsProvider =
    StateNotifierProvider<FavoritePokemonsProvider, List<String>>((ref) {
  return FavoritePokemonsProvider([]);
});

class FavoritePokemonsProvider extends StateNotifier<List<String>> {
  final DatabaseService _databaseService =
      GetIt.instance.get<DatabaseService>();

  String FAVORITE_POKEMONS_LIST_KEY = "FAVORITE_POKEMONS_LIST_KEY";
  FavoritePokemonsProvider(super._state) {
    _setup();
  }
  Future<void> _setup() async {
    List<String>? result =
        await _databaseService.getList(FAVORITE_POKEMONS_LIST_KEY);
    state = result ?? [];
  }

  void addFavoritePokemon(String url) {
    state = [...state, url];
    _databaseService.saveList(FAVORITE_POKEMONS_LIST_KEY, state);
  }

  void removeFavoritePokemon(String url) {
    state = state.where((element) => element != url).toList();
    _databaseService.saveList(FAVORITE_POKEMONS_LIST_KEY, state);
  }
}
