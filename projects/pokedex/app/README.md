# 포켓몬 도감 Flutter App

PokeAPI 기반 Flutter 포켓몬 도감 앱 (Sprint 1).

## 빠른 시작

```bash
cd projects/pokedex/app

# 패키지 설치
flutter pub get

# 코드 생성 (Freezed + json_serializable + Riverpod)
dart run build_runner build --delete-conflicting-outputs

# 실행 (안드로이드 기기 또는 에뮬레이터)
flutter run
```

## 프로젝트 구조

```
lib/
├── main.dart                        # 앱 진입점
├── core/
│   ├── constants/
│   │   ├── app_constants.dart       # API URL, 페이지 크기 등
│   │   └── type_colors.dart        # 타입별 색상 + 한국어 이름
│   ├── router/
│   │   └── app_router.dart         # go_router 라우팅 설정
│   └── theme/
│       └── app_theme.dart          # 라이트/다크 테마
├── data/
│   ├── api/
│   │   └── poke_api_client.dart    # Dio HTTP 클라이언트
│   ├── models/
│   │   ├── pokemon_list_item.dart  # 목록 아이템 모델 (Freezed)
│   │   └── pokemon_detail.dart    # 상세 정보 모델 (Freezed)
│   └── repositories/
│       └── pokemon_repository.dart # 데이터 레이어
├── domain/
│   └── providers/
│       ├── pokemon_list_provider.dart   # 목록 상태 (무한 스크롤)
│       ├── pokemon_detail_provider.dart # 상세 정보 Provider
│       └── favorites_provider.dart     # 즐겨찾기 (SharedPreferences)
└── presentation/
    ├── pages/
    │   ├── pokemon_list_page.dart   # 포켓몬 목록 (3열 그리드)
    │   ├── pokemon_detail_page.dart # 포켓몬 상세 (SliverAppBar)
    │   └── favorites_page.dart     # 즐겨찾기 목록
    └── widgets/
        ├── app_shell.dart          # BottomNavigationBar 쉘
        ├── pokemon_card.dart       # 그리드 카드
        ├── type_badge.dart         # 타입 배지 (한글)
        └── stat_bar.dart           # 능력치 막대 그래프
```

## 디자인 통합 내역 (v1.1)

견희(Designer) 명세 기반 UI 전면 적용:

- ✅ **AppTheme** — 포켓볼 레드 `#E3350D` + Material 3 ColorScheme
- ✅ **Noto Sans KR** (한국어 폰트) + **Rajdhani** (수치 강조)
- ✅ **PokemonCard** — Hero 태그, 즐겨찾기 ScaleTransition, 타입 컬러 배경
- ✅ **TypeBadge** — pill shape (borderRadius 12), 타입별 색상
- ✅ **StatBar** — 수치 구간별 색상 + 스태거 애니메이션 (0→값, 800ms)
- ✅ **PokemonListPage** — SearchBar + TypeFilterChip + SliverAppBar(floating/snap) + 2열 그리드
- ✅ **PokemonDetailPage** — 타입 그라디언트 헤더 + Hero 이미지 + TabBar(능력치/특성)
- ✅ **FavoritesPage** — 빈 상태 명세 적용
- ✅ **즐겨찾기 토글** — ScaleTransition + HapticFeedback

## Sprint 1 완료 기능

- ✅ Flutter 프로젝트 구조 (clean architecture)
- ✅ pubspec.yaml (riverpod, dio, go_router, freezed, cached_network_image)
- ✅ PokeAPI 클라이언트 (Dio)
- ✅ Pokemon 데이터 모델 (Freezed 어노테이션)
- ✅ 포켓몬 목록 페이지 (무한 스크롤, 3열 그리드)
- ✅ 포켓몬 상세 페이지 (기본 정보 + 능력치 바)
- ✅ 즐겨찾기 (SharedPreferences 로컬 저장)
- ✅ 타입별 색상 + 한국어 이름
- ✅ BottomNavigationBar 쉘

## Sprint 2 예정

- 검색 기능 (실시간)
- 타입 필터 칩
- 진화 체인 표시
- UI 폴리싱

## 주의사항

- `build_runner` 실행 전에는 `.freezed.dart`, `.g.dart` 파일이 없어 컴파일 에러 발생
- Flutter SDK 설치 필요: https://flutter.dev/docs/get-started/install
