import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/providers/pokemon_list_provider.dart';
import '../../domain/providers/pokemon_index_provider.dart';
import '../../domain/providers/generation_filter_provider.dart';
import '../../domain/providers/korean_names_provider.dart';
import '../../domain/providers/pokemon_type_ids_provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/type_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../main.dart';
import '../widgets/pokemon_card.dart';
import '../widgets/pokemon_card_shimmer.dart';

// 검색어 provider
final searchQueryProvider = StateProvider<String>((ref) => '');

// 선택된 타입 필터 provider
final selectedTypeProvider = StateProvider<String?>((ref) => null);

class PokemonListPage extends ConsumerWidget {
  const PokemonListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pokemonListProvider);
    final indexState = ref.watch(pokemonIndexProvider);
    final searchQuery = ref.watch(searchQueryProvider);
    final selectedType = ref.watch(selectedTypeProvider);
    final selectedGen = ref.watch(selectedGenerationProvider);
    final koreanNames = ref.watch(koreanNamesProvider);
    final typeIdsMap = ref.watch(pokemonTypeIdsProvider);
    final typeIdsNotifier = ref.read(pokemonTypeIdsProvider.notifier);

    // 타입 필터 선택 시 해당 타입 ID 목록 fetch
    if (selectedType != null) {
      typeIdsNotifier.fetchIfAbsent(selectedType);
    }

    // 검색어 또는 세대/타입 필터가 있으면 전체 인덱스 사용, 없으면 페이징 목록 사용
    final needFullIndex = searchQuery.isNotEmpty || selectedGen != null || selectedType != null;
    final baseItems =
        needFullIndex && indexState.isReady
            ? indexState.allItems
            : state.items;

    // 검색 + 세대 + 타입 필터 적용
    var filtered = baseItems.where((item) {
      final q = searchQuery.toLowerCase();
      final korName = koreanNames[item.id]?.toLowerCase() ?? '';
      final matchesSearch = q.isEmpty ||
          item.name.toLowerCase().contains(q) ||
          item.id.toString() == q ||
          korName.contains(q);

      final matchesGen = selectedGen == null ||
          (() {
            final range = AppConstants.generationRanges[selectedGen];
            if (range == null) return true;
            return item.id >= range.start && item.id <= range.end;
          })();

      // 타입 필터: /type/{name} API 결과로 정확히 필터링
      final matchesType = selectedType == null ||
          (() {
            final ids = typeIdsMap[selectedType];
            if (ids == null) return true; // 아직 fetch 중 → 일단 표시
            return ids.contains(item.id);
          })();

      return matchesSearch && matchesGen && matchesType;
    }).toList();

    // 검색/필터 시 ID 오름차순 정렬
    if (searchQuery.isNotEmpty || selectedGen != null || selectedType != null) {
      filtered.sort((a, b) => a.id.compareTo(b.id));
    }

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => ref.read(pokemonListProvider.notifier).refresh(),
        child: CustomScrollView(
          slivers: [
            // SliverAppBar — floating + snap
            SliverAppBar(
              floating: true,
              snap: true,
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              title: const Text(
                '포켓몬 도감',
                style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    ref.watch(themeProvider) == ThemeMode.dark
                        ? Icons.light_mode
                        : ref.watch(themeProvider) == ThemeMode.light
                            ? Icons.brightness_auto
                            : Icons.dark_mode,
                    color: Colors.white,
                  ),
                  tooltip: '테마 변경',
                  onPressed: () {
                    final current = ref.read(themeProvider);
                    final next = current == ThemeMode.system
                        ? ThemeMode.light
                        : current == ThemeMode.light
                            ? ThemeMode.dark
                            : ThemeMode.system;
                    ref.read(themeProvider.notifier).state = next;
                  },
                ),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(56),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: _SearchBar(
                    onChanged: (v) =>
                        ref.read(searchQueryProvider.notifier).state = v,
                  ),
                ),
              ),
            ),

            // 세대 필터 Row
            SliverToBoxAdapter(
              child: _GenerationFilterRow(
                selected: selectedGen,
                onSelect: (gen) =>
                    ref.read(selectedGenerationProvider.notifier).state = gen,
              ),
            ),

            // 타입 필터 Row
            SliverToBoxAdapter(
              child: _TypeFilterRow(
                selected: selectedType,
                onSelect: (type) =>
                    ref.read(selectedTypeProvider.notifier).state = type,
              ),
            ),

            // 목록 or 상태
            if (state.items.isEmpty && state.isLoading)
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverGrid(
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.72,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (_, __) => const PokemonCardShimmer(),
                    childCount: 10,
                  ),
                ),
              )
            else if (needFullIndex && indexState.isLoading)
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
              )
            else if (selectedType != null && !typeIdsMap.containsKey(selectedType))
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
              )
            else if (state.items.isEmpty && state.error != null)
              SliverFillRemaining(child: _ErrorView(ref: ref))
            else if (filtered.isEmpty && (searchQuery.isNotEmpty || selectedGen != null || selectedType != null))
              const SliverFillRemaining(child: _EmptySearchView())
            else
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverGrid(
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.72,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      // 무한 스크롤: 검색/세대/타입 필터 없을 때만 동작
                      final isLoaderSlot = index == filtered.length &&
                          state.hasMore &&
                          searchQuery.isEmpty &&
                          selectedGen == null &&
                          selectedType == null;
                      if (isLoaderSlot) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          ref.read(pokemonListProvider.notifier).loadMore();
                        });
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        );
                      }
                      if (index >= filtered.length) return null;
                      return PokemonCard(item: filtered[index]);
                    },
                    childCount: filtered.length +
                        (state.hasMore && searchQuery.isEmpty && selectedGen == null && selectedType == null
                            ? 1
                            : 0),
                  ),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (!indexState.isReady) return;
          final allItems = indexState.allItems;
          if (allItems.isEmpty) return;
          final random = math.Random();
          final item = allItems[random.nextInt(allItems.length)];
          context.push('/pokemon/${item.id}?name=${item.name}');
        },
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        tooltip: '랜덤 포켓몬',
        child: const Icon(Icons.casino),
      ),
    );
  }
}

// ─── SearchBar ────────────────────────────────────────────
class _SearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const _SearchBar({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: '이름, 번호, 한국어 검색...',
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
        prefixIcon:
            Icon(Icons.search, color: Colors.white.withOpacity(0.8)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        contentPadding: const EdgeInsets.symmetric(vertical: 0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(color: Colors.white, width: 1.5),
        ),
      ),
    );
  }
}

// ─── 세대 필터 Row ─────────────────────────────────────────
class _GenerationFilterRow extends StatelessWidget {
  final int? selected;
  final ValueChanged<int?> onSelect;

  const _GenerationFilterRow({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: FilterChip(
              label: const Text('전체', style: TextStyle(fontSize: 11)),
              selected: selected == null,
              onSelected: (_) => onSelect(null),
              selectedColor: AppTheme.primaryContainer,
              checkmarkColor: AppTheme.primary,
              padding: const EdgeInsets.symmetric(horizontal: 4),
            ),
          ),
          ...List.generate(9, (i) {
            final gen = i + 1;
            final isSelected = selected == gen;
            return Padding(
              padding: const EdgeInsets.only(right: 6),
              child: FilterChip(
                label: Text(
                  AppConstants.generationLabels[i],
                  style: TextStyle(
                    fontSize: 11,
                    color: isSelected ? Colors.white : null,
                  ),
                ),
                selected: isSelected,
                onSelected: (_) => onSelect(isSelected ? null : gen),
                selectedColor: AppTheme.secondary,
                backgroundColor: const Color(0xFFF5F5F5),
                side: BorderSide(
                  color: isSelected ? AppTheme.secondary : AppTheme.outline,
                ),
                showCheckmark: false,
                padding: const EdgeInsets.symmetric(horizontal: 4),
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ─── 타입 필터 Row ─────────────────────────────────────────
class _TypeFilterRow extends StatelessWidget {
  final String? selected;
  final ValueChanged<String?> onSelect;

  const _TypeFilterRow({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: FilterChip(
              label: const Text('전체타입', style: TextStyle(fontSize: 11)),
              selected: selected == null,
              onSelected: (_) => onSelect(null),
              selectedColor: AppTheme.primaryContainer,
              checkmarkColor: AppTheme.primary,
              padding: const EdgeInsets.symmetric(horizontal: 4),
            ),
          ),
          ...AppConstants.pokemonTypes.map((type) {
            final typeColor = TypeColors.getColor(type);
            final korName = TypeColors.getKoreanName(type);
            final isSelected = selected == type;
            return Padding(
              padding: const EdgeInsets.only(right: 6),
              child: FilterChip(
                label: Text(
                  korName,
                  style: TextStyle(
                    color: isSelected ? Colors.white : null,
                    fontSize: 11,
                  ),
                ),
                selected: isSelected,
                onSelected: (_) => onSelect(isSelected ? null : type),
                selectedColor: typeColor,
                backgroundColor: const Color(0xFFF5F5F5),
                side: BorderSide(
                  color: isSelected ? typeColor : AppTheme.outline,
                ),
                showCheckmark: false,
                padding: const EdgeInsets.symmetric(horizontal: 4),
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ─── Error / Empty 뷰 ─────────────────────────────────────
class _ErrorView extends StatelessWidget {
  final WidgetRef ref;
  const _ErrorView({required this.ref});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text('불러오기 실패', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () =>
                ref.read(pokemonListProvider.notifier).loadMore(),
            child: const Text('다시 시도'),
          ),
        ],
      ),
    );
  }
}

class _EmptySearchView extends StatelessWidget {
  const _EmptySearchView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.catching_pokemon,
              size: 80, color: Colors.grey.withOpacity(0.4)),
          const SizedBox(height: 16),
          Text(
            '포켓몬을 찾을 수 없어요',
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: AppTheme.outline),
          ),
        ],
      ),
    );
  }
}
