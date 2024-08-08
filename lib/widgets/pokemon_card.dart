import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemoncards/models/pokemon.dart';
import 'package:pokemoncards/providers/pokemon_data_providers.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PokemonCard extends ConsumerWidget {
  final String pokemonURL;

  const PokemonCard({
    super.key,
    required this.pokemonURL,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pokemon = ref.watch(pokemonDataProvider(pokemonURL));
    return pokemon.when(data: (data) {
      return _card(context, false, data);
    }, loading: () {
      return _card(context, true, null);
    }, error: (error, stack) {
      return Text("Error: $error");
    });
  }

  Widget _card(BuildContext context, bool isLoading, Pokemon? pokemon) {
    return Skeletonizer(
      enabled: isLoading,
      ignoreContainers: true,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.sizeOf(context).width * 0.03,
          vertical: MediaQuery.sizeOf(context).width * 0.01,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.sizeOf(context).width * 0.03,
          vertical: MediaQuery.sizeOf(context).width * 0.01,
        ),
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(color: Colors.black26, spreadRadius: 2, blurRadius: 10)
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pokemon?.name?.toUpperCase() ?? "Pokemon",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                Text(
                  "#${pokemon?.id?.toString()}" ?? "Pokemon",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                )
              ],
            ),
            Expanded(
              child: CircleAvatar(
                radius: MediaQuery.sizeOf(context).height * 0.05,
                backgroundImage: pokemon != null
                    ? NetworkImage(pokemon!.sprites!.frontDefault!)
                    : null,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "${pokemon?.moves?.length} Moves",
                  style: TextStyle(color: Colors.white),
                ),
                Icon(Icons.favorite, color: Colors.red)
              ],
            )
          ],
        ),
      ),
    );
  }
}
