import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemoncards/controllers/home_page_controller.dart';
import 'package:pokemoncards/models/page_data.dart';
import 'package:pokemoncards/models/pokemon.dart';
import 'package:pokemoncards/providers/pokemon_data_providers.dart';
import 'package:pokemoncards/widgets/pokemon_card.dart';
import 'package:pokemoncards/widgets/pokemon_list_tile.dart';

final homePageControllerProvider =
    StateNotifierProvider<HomePageController, HomePageData>((ref) {
  return HomePageController(HomePageData.initial());
});

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final ScrollController _allPokemonListScrollController = ScrollController();
  late HomePageController _homePageController;
  late HomePageData _homePageData;
  late List<String> _favoritePokemons;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _allPokemonListScrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _allPokemonListScrollController.removeListener(_scrollListener);
    _allPokemonListScrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_allPokemonListScrollController.offset >=
            _allPokemonListScrollController.position.maxScrollExtent * 1 &&
        !_allPokemonListScrollController.position.outOfRange) {
      _homePageController.loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    _homePageController = ref.watch(homePageControllerProvider.notifier);
    _homePageData = ref.watch(homePageControllerProvider);
    _favoritePokemons = ref.watch(favoritePokemonsProvider);
    return Scaffold(
      body: _buildUI(context),
    );
  }

  Widget _buildUI(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          width: MediaQuery.sizeOf(context).width,
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.sizeOf(context).width * 0.02),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _favoritePokemonsList(context),
              _allPokemonList(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _favoritePokemonsList(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Favorites",
            style: TextStyle(fontSize: 25),
          ),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.48,
            width: MediaQuery.sizeOf(context).width,
            child: Column(
              children: [
                if (_favoritePokemons.isNotEmpty)
                  Expanded(
                    child: GridView.builder(
                        scrollDirection: Axis.horizontal,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2),
                        itemCount: _favoritePokemons.length,
                        itemBuilder: (context, index) {
                          String pokemonURL = _favoritePokemons[index];
                          return PokemonCard(pokemonURL: pokemonURL);
                        }),
                  ),
                if (_favoritePokemons.isEmpty)
                  const Text("No favorite pokemons yet"),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _allPokemonList(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "All pokemons",
            style: TextStyle(fontSize: 25),
          ),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.60,
            child: ListView.builder(
                controller: _allPokemonListScrollController,
                itemCount: _homePageData.data?.results?.length ?? 0,
                itemBuilder: (context, index) {
                  PokemonListResult pokemon =
                      _homePageData.data!.results![index];
                  return PokemonListTile(pokemonURL: pokemon.url!);
                }),
          )
        ],
      ),
    );
  }
}
