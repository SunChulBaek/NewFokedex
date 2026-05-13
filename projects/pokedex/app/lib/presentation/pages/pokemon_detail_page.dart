import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/providers/pokemon_detail_provider.dart';
import '../../domain/providers/pokemon_species_provider.dart';
import '../../domain/providers/favorites_provider.dart';
import '../../core/constants/type_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/pokemon_detail.dart';
import '../widgets/type_badge.dart';
import '../widgets/stat_bar.dart';
import '../widgets/evolution_chain_widget.dart';

class PokemonDetailPage extends ConsumerStatefulWidget {
  final int pokemonId;
  final String pokemonName;

  const PokemonDetailPage({
    super.key,
    required this.pokemonId,
    required this.pokemonName,
  });

  @override
  ConsumerState<PokemonDetailPage> createState() =>
      _PokemonDetailPageState();
}

class _PokemonDetailPageState extends ConsumerState<PokemonDetailPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _favController;
  late Animation<double> _favScale;
  late AnimationController _bounceController;
  late Animation<double> _bounceOffset;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this); // 능력치/특성/진화
    _favController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _favScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(
      parent: _favController,
      curve: Curves.easeInOut,
    ));

    // 바운스 애니메이션: 위아래 살랑이기
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _bounceOffset = Tween<double>(begin: 0, end: -10).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _favController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final detailAsync = ref.watch(pokemonDetailProvider(widget.pokemonId));
    final speciesAsync = ref.watch(pokemonSpeciesProvider(widget.pokemonId));
    final isFav = ref.watch(favoritesProvider).contains(widget.pokemonId);

    // 한국어 이름: species에서 로드, 없으면 영어 capitalize 사용
    final koreanName = speciesAsync.when(
      data: (s) => s.koreanName,
      loading: () => null,
      error: (_, __) => null,
    );

    return detailAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(title: Text(_capitalize(widget.pokemonName))),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(title: Text(_capitalize(widget.pokemonName))),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(e.toString()),
            ],
          ),
        ),
      ),
      data: (pokemon) {
        final displayName =
            koreanName ?? _capitalize(pokemon.name);
        final type1Color = TypeColors.getColor(pokemon.primaryType);
        final type2Color = pokemon.types.length > 1
            ? TypeColors.getColor(pokemon.types[1].type.name)
            : Colors.white;

        return Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (context, _) => [
              SliverAppBar(
                expandedHeight: 280,
                pinned: true,
                backgroundColor: type1Color,
                foregroundColor: Colors.white,
                actions: [
                  ScaleTransition(
                    scale: _favScale,
                    child: IconButton(
                      icon: Icon(
                        isFav ? Icons.favorite : Icons.favorite_outline,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        _favController.forward(from: 0.0);
                        ref
                            .read(favoritesProvider.notifier)
                            .toggle(pokemon.id);
                      },
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background:
                      _buildHeader(pokemon, type1Color, type2Color),
                ),
              ),
            ],
            body: Column(
              children: [
                _buildNameSection(context, pokemon, displayName),
                TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: '능력치'),
                    Tab(text: '특성'),
                    Tab(text: '진화'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _StatsTab(pokemon: pokemon),
                      _AbilitiesTab(pokemon: pokemon),
                      _EvolutionTab(pokemonId: widget.pokemonId),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(
      PokemonDetail pokemon, Color type1Color, Color type2Color) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // 배경 그라데이션
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                type1Color,
                type2Color == Colors.white
                    ? type1Color.withOpacity(0.6)
                    : type2Color,
              ],
            ),
          ),
        ),
        // 레트로 노이즈 오버레이
        CustomPaint(
          painter: _RetroNoisePainter(),
        ),
        // 포켓몬 이미지 + 바운스
        SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 48, bottom: 16),
              child: AnimatedBuilder(
                animation: _bounceOffset,
                builder: (context, child) => Transform.translate(
                  offset: Offset(0, _bounceOffset.value),
                  child: child,
                ),
                child: Hero(
                  tag: 'pokemon-image-${pokemon.id}',
                  child: CachedNetworkImage(
                    imageUrl: pokemon.officialArtworkUrl,
                    height: 180,
                    width: 180,
                    fit: BoxFit.contain,
                    placeholder: (context, url) => const SizedBox(
                      height: 180,
                      child: Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    ),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.catching_pokemon,
                      size: 120,
                      color: Colors.white54,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNameSection(
      BuildContext context, PokemonDetail pokemon, String displayName) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '#${pokemon.id.toString().padLeft(3, '0')}',
            style: GoogleFonts.rajdhani(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.outline,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  displayName,
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              Wrap(
                spacing: 6,
                children: pokemon.types
                    .map((t) => TypeBadge(type: t.type.name))
                    .toList(),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _infoChip('키', '${pokemon.height / 10}m'),
              const SizedBox(width: 16),
              _infoChip('몸무게', '${pokemon.weight / 10}kg'),
              const SizedBox(width: 16),
              _infoChip('기본 경험치', '${pokemon.baseExperience}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoChip(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 11,
                color: AppTheme.outline,
                fontWeight: FontWeight.w400)),
        Text(value,
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600)),
      ],
    );
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}

// ─── 능력치 탭 ────────────────────────────────────────────
class _StatsTab extends StatelessWidget {
  final PokemonDetail pokemon;
  const _StatsTab({required this.pokemon});

  @override
  Widget build(BuildContext context) {
    final total = pokemon.stats.fold(0, (sum, s) => sum + s.baseStat);
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...pokemon.stats.asMap().entries.map((entry) {
            final i = entry.key;
            final s = entry.value;
            return StatBar(
              label: statDisplayName(s.stat.name),
              value: s.baseStat,
              animationDelay: i * 50,
            );
          }),
          const Divider(height: 24),
          Row(
            children: [
              const SizedBox(
                width: 56,
                child: Text('합계',
                    style: TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 13)),
              ),
              const SizedBox(width: 8),
              Text(
                total.toString(),
                style: GoogleFonts.rajdhani(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1C1B1F),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── 특성 탭 ─────────────────────────────────────────────
class _AbilitiesTab extends StatelessWidget {
  final PokemonDetail pokemon;
  const _AbilitiesTab({required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: pokemon.abilities.map((a) {
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: Icon(
                a.isHidden ? Icons.star : Icons.auto_awesome,
                color: a.isHidden ? Colors.amber : AppTheme.primary,
              ),
              title: Text(
                _capitalize(a.ability.name.replaceAll('-', ' ')),
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              subtitle: a.isHidden
                  ? const Text('숨겨진 특성',
                      style:
                          TextStyle(color: Colors.amber, fontSize: 11))
                  : null,
            ),
          );
        }).toList(),
      ),
    );
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}

// ─── 진화 탭 ─────────────────────────────────────────────
class _EvolutionTab extends StatelessWidget {
  final int pokemonId;
  const _EvolutionTab({required this.pokemonId});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
            child: Text(
              '진화 체인',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          EvolutionChainWidget(pokemonId: pokemonId),
        ],
      ),
    );
  }
}

// ─── 레트로 노이즈 Painter ────────────────────────────────
class _RetroNoisePainter extends CustomPainter {
  final _rng = math.Random();

  @override
  void paint(Canvas canvas, Size size) {
    // 1. 스캔라인 (수평 줄)
    final scanPaint = Paint()
      ..color = Colors.black.withOpacity(0.10)
      ..strokeWidth = 1.0;
    for (double y = 0; y < size.height; y += 3) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), scanPaint);
    }

    // 2. 랜덤 정전기 픽셀
    final noisePaint = Paint()..strokeWidth = 1.5;
    final pixelCount = (size.width * size.height * 0.012).toInt();
    for (int i = 0; i < pixelCount; i++) {
      final x = _rng.nextDouble() * size.width;
      final y = _rng.nextDouble() * size.height;
      final bright = _rng.nextBool();
      noisePaint.color = (bright ? Colors.white : Colors.black)
          .withOpacity(_rng.nextDouble() * 0.35 + 0.05);
      canvas.drawCircle(Offset(x, y), 0.8, noisePaint);
    }

    // 3. 가벼운 비네팅
    final vignettePaint = Paint()
      ..shader = RadialGradient(
        center: Alignment.center,
        radius: 1.0,
        colors: [Colors.transparent, Colors.black.withOpacity(0.25)],
        stops: const [0.55, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      vignettePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
