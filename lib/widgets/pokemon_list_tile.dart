import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemoncards/models/pokemon.dart';
import 'package:pokemoncards/providers/pokemon_data_providers.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PokemonListTile extends ConsumerWidget {
  final String pokemonURL;

  late FavoritePokemonsProvider _favoritePokemonsProvider;

  late List<String> _favoritePokemons;

  PokemonListTile({super.key, required this.pokemonURL});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    _favoritePokemonsProvider = ref.watch(favoritePokemonsProvider.notifier);
    _favoritePokemons = ref.watch(favoritePokemonsProvider);
    final pokemon = ref.watch(pokemonDataProvider(pokemonURL));
    return pokemon.when(data: (pokemon) {
      return _tile(context, false, pokemon);
    }, loading: () {
      return _tile(context, true, null);
    }, error: (error, stack) {
      return Text("Error: $error");
    });
  }

  Widget _tile(
    BuildContext context,
    bool isLoading,
    Pokemon? pokemon,
  ) {
    return Skeletonizer(
      enabled: isLoading,
      child: ListTile(
        leading: pokemon != null
            ? CircleAvatar(
                backgroundImage: NetworkImage(pokemon.sprites!.frontDefault!),
              )
            : CircleAvatar(),
        title: Text(pokemon != null
            ? pokemon.name!.toUpperCase()
            : "currently loading name for pokemon"),
        subtitle: Text("Has ${pokemon?.moves?.length.toString() ?? 0} moves"),
        trailing: IconButton(
          onPressed: () {
            if (_favoritePokemons.contains(pokemonURL)) {
              _favoritePokemonsProvider.removeFavoritePokemon(pokemonURL);
            } else {
              _favoritePokemonsProvider.addFavoritePokemon(pokemonURL);
            }
          },
          icon: Icon(
            _favoritePokemons.contains(pokemonURL)
                ? Icons.favorite
                : Icons.favorite_border,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
