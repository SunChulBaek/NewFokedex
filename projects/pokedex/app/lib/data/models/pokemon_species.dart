class PokemonSpecies {
  final int id;
  final String name;
  final String? koreanName;
  final String? evolutionChainUrl;

  const PokemonSpecies({
    required this.id,
    required this.name,
    this.koreanName,
    this.evolutionChainUrl,
  });

  factory PokemonSpecies.fromJson(Map<String, dynamic> json) {
    final names = json['names'] as List? ?? [];
    String? korean;
    for (final n in names) {
      if ((n['language']?['name'] as String?) == 'ko') {
        korean = n['name'] as String?;
        break;
      }
    }
    final chainUrl =
        json['evolution_chain']?['url'] as String?;
    return PokemonSpecies(
      id: json['id'] as int,
      name: json['name'] as String,
      koreanName: korean,
      evolutionChainUrl: chainUrl,
    );
  }
}
