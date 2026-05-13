# 포켓몬 도감 앱 — 디자인 가이드라인 및 UI 명세서

> 작성: 견희 (Designer)  
> 날짜: 2026-05-13  
> 버전: v1.0  
> 기반: Flutter 3.x / Material 3 / 라이트 테마

---

## 1. 컬러 시스템

### 1-1. 앱 전체 테마 (Light Theme)

| Role | Color | Hex |
|------|-------|-----|
| Primary | 포켓볼 레드 | `#E3350D` |
| Primary Container | 연한 레드 | `#FFDAD4` |
| On Primary | 흰색 | `#FFFFFF` |
| Secondary | 딥 다크 블루 | `#1A1A2E` |
| Secondary Container | 연한 블루 | `#E0E0F0` |
| Surface | 흰색 | `#FFFFFF` |
| Surface Variant | 밝은 회색 | `#F5F5F5` |
| Background | `#FAFAFA` | |
| On Background / On Surface | `#1C1B1F` | |
| Outline | `#938F99` | |
| Error | `#B3261E` | |

> **활용:** AppBar, FAB, 활성 탭 아이콘은 `Primary`. 카드 배경은 포켓몬 타입 컬러를 옅게 오버레이 (opacity 0.15).

---

### 1-2. 포켓몬 타입별 컬러 팔레트 (18개 타입)

| 타입 | 한국어 | Primary Hex | Container (15% opacity bg) |
|------|--------|-------------|---------------------------|
| normal | 노말 | `#A8A878` | `#A8A87826` |
| fire | 불꽃 | `#F08030` | `#F0803026` |
| water | 물 | `#6890F0` | `#6890F026` |
| electric | 전기 | `#F8D030` | `#F8D03026` |
| grass | 풀 | `#78C850` | `#78C85026` |
| ice | 얼음 | `#98D8D8` | `#98D8D826` |
| fighting | 격투 | `#C03028` | `#C0302826` |
| poison | 독 | `#A040A0` | `#A040A026` |
| ground | 땅 | `#E0C068` | `#E0C06826` |
| flying | 비행 | `#A890F0` | `#A890F026` |
| psychic | 에스퍼 | `#F85888` | `#F8588826` |
| bug | 벌레 | `#A8B820` | `#A8B82026` |
| rock | 바위 | `#B8A038` | `#B8A03826` |
| ghost | 고스트 | `#705898` | `#70589826` |
| dragon | 드래곤 | `#7038F8` | `#7038F826` |
| dark | 악 | `#705848` | `#70584826` |
| steel | 강철 | `#B8B8D0` | `#B8B8D026` |
| fairy | 페어리 | `#EE99AC` | `#EE99AC26` |

> **활용:**  
> - `TypeBadge` 배경: Primary Hex  
> - `PokemonCard` 배경: 첫 번째 타입의 Container  
> - `PokemonDetailPage` 상단 헤더 그라디언트: 타입1 → 타입2 (단일 타입이면 타입1 → white)

---

## 2. 타이포그래피

### 폰트 선택

| 역할 | 폰트 | 이유 |
|------|------|------|
| 기본 (한/영 혼용) | **Noto Sans KR** | 한국어 지원 최적, Google Fonts 제공 |
| 포켓몬 번호/수치 강조 | **Rajdhani** (영문 숫자 전용) | 게임 느낌의 모노 스타일 |

> `pubspec.yaml`에 `google_fonts` 패키지 사용. `ThemeData.textTheme`을 `GoogleFonts.notoSansKrTextTheme()`으로 설정.

---

### 크기 체계 (Material 3 TypeScale 매핑)

| Role | Size | Weight | 용도 |
|------|------|--------|------|
| `displayLarge` | 57sp | 700 | (미사용) |
| `displayMedium` | 45sp | 700 | (미사용) |
| `headlineLarge` | 32sp | 700 | 상세 페이지 포켓몬 이름 |
| `headlineMedium` | 28sp | 600 | 섹션 제목 (능력치, 진화 등) |
| `headlineSmall` | 24sp | 600 | 목록 페이지 타이틀 |
| `titleLarge` | 22sp | 600 | AppBar 타이틀 |
| `titleMedium` | 16sp | 500 | 카드 포켓몬 이름 |
| `titleSmall` | 14sp | 500 | 즐겨찾기 레이블 |
| `bodyLarge` | 16sp | 400 | 본문, 특성 설명 |
| `bodyMedium` | 14sp | 400 | 일반 본문 |
| `bodySmall` | 12sp | 400 | 보조 텍스트 |
| `labelLarge` | 14sp | 500 | 버튼, 탭 레이블 |
| `labelMedium` | 12sp | 500 | TypeBadge 텍스트 |
| `labelSmall` | 11sp | 400 | 캡션, 도움말 텍스트 |

> **포켓몬 번호** (`#0001` 형식): `Rajdhani`, 14sp, weight 600, color `Outline`.

---

## 3. 컴포넌트 명세

### 3-1. PokemonCard

```
┌─────────────────────────────┐
│  [배경: 타입 컬러 15% 오버레이] │
│                             │
│     [포켓몬 이미지 96x96]     │
│                             │
│  #0001          ♡ (즐겨찾기)  │
│  이상해씨                    │
│  [풀] [독]  ← TypeBadge      │
└─────────────────────────────┘
```

| 속성 | 값 |
|------|---|
| 크기 | 160×180dp |
| 모서리 | `BorderRadius.circular(16)` |
| Elevation | `2` (Material 3 ElevationTint 포함) |
| 이미지 | `CachedNetworkImage`, 96×96, `hero` 태그: `pokemon-{id}` |
| 번호 텍스트 | `labelSmall`, Rajdhani, color Outline |
| 이름 텍스트 | `titleMedium`, Noto Sans KR |
| 즐겨찾기 아이콘 | `Icons.favorite` / `Icons.favorite_border`, Primary/Outline |

**상태:**
- Default: elevation 2
- Pressed: scale 0.97, elevation 0 (InkWell ripple)
- Favorited: 하트 아이콘 Primary 컬러, 미세한 pulse 애니메이션

---

### 3-2. TypeBadge

```
┌──────────┐
│  🔥 불꽃  │
└──────────┘
```

| 속성 | 값 |
|------|---|
| 크기 | 높이 24dp, 좌우 패딩 8dp |
| 배경 | 타입 Primary Hex |
| 텍스트 | `labelMedium`, 흰색, 굵기 600 |
| 모서리 | `BorderRadius.circular(12)` (pill shape) |
| 아이콘 | 타입별 이모지 또는 커스텀 SVG 아이콘 (선택) |
| 간격 | 타입 뱃지 사이 `gap: 6dp` |

> 다중 타입 포켓몬은 Row로 나열. 최대 2개.

---

### 3-3. StatBar

```
HP        45  ████████░░░░░░░░  45/255
공격       49  ████████░░░░░░░░
```

| 속성 | 값 |
|------|---|
| 레이블 너비 | 56dp (고정) |
| 수치 너비 | 32dp (고정, Rajdhani 굵기) |
| 바 너비 | 나머지 공간 (Flexible) |
| 바 높이 | 8dp |
| 모서리 | `BorderRadius.circular(4)` |
| 배경색 | `Surface Variant` |
| 채움색 | 수치 구간별 색상 분기: |
|  | 0~44: `#FF5959` (낮음) |
|  | 45~89: `#FFAD33` (보통) |
|  | 90~134: `#9DB920` (좋음) |
|  | 135~: `#2DB52D` (최상) |
| 애니메이션 | 상세 페이지 진입 시 0 → 실제값으로 0.8s `CurvedAnimation(Curves.easeOut)` |

---

### 3-4. EvolutionChain

```
[이상해씨]  →  [이상해풀]  →  [이상해꽃]
  Lv.16            Lv.32
```

| 속성 | 값 |
|------|---|
| 레이아웃 | 가로 스크롤 `Row` (3단계 이상 시 scroll 허용) |
| 포켓몬 이미지 | 64×64dp |
| 이름 | `labelMedium`, 중앙 정렬 |
| 화살표 | `Icons.arrow_forward_ios`, Outline 컬러 |
| 진화 조건 텍스트 | `labelSmall`, Outline 컬러 (레벨, 아이템, 우정 등) |
| 현재 포켓몬 강조 | 테두리 `2dp`, Primary 컬러 |

---

### 3-5. SearchBar

Material 3 `SearchBar` 위젯 활용.

| 속성 | 값 |
|------|---|
| 배경 | `Surface Variant` |
| Hint | `"이름 또는 번호 검색..."` |
| 아이콘 | leading: `Icons.search`, trailing: X (입력 시) |
| 모서리 | `BorderRadius.circular(28)` (pill) |
| Debounce | 300ms (Riverpod `ref.debounce` 또는 `Timer`) |

---

### 3-6. TypeFilterChip

Material 3 `FilterChip` 활용.

| 속성 | 값 |
|------|---|
| 기본 상태 | 배경 `Surface Variant`, 테두리 `Outline` |
| 선택 상태 | 배경 타입 Primary Hex, 텍스트 흰색 |
| 크기 | 높이 32dp |
| 스크롤 | 가로 스크롤 `SingleChildScrollView` + `Row` |
| 간격 | `gap: 8dp` |

---

## 4. 화면별 레이아웃 가이드

### 4-1. PokemonListPage (홈/도감 탭)

```
┌──────────────────────────────────┐
│  AppBar: "포켓몬 도감"  [검색아이콘] │
├──────────────────────────────────┤
│  SearchBar (전체 너비, 수평 패딩 16) │
├──────────────────────────────────┤
│  TypeFilterChips (가로 스크롤)      │
│  [전체] [불꽃] [물] [풀] [전기] ... │
├──────────────────────────────────┤
│                                  │
│  PokemonGrid                     │
│  ┌──────┐ ┌──────┐               │
│  │ Card │ │ Card │  ← 2열 Grid   │
│  └──────┘ └──────┘               │
│  ┌──────┐ ┌──────┐               │
│  │ Card │ │ Card │               │
│  └──────┘ └──────┘               │
│  ... (무한 스크롤)                 │
│                                  │
│  [로딩 스피너 - 하단]              │
└──────────────────────────────────┘
```

| 속성 | 값 |
|------|---|
| Grid | `SliverGrid`, crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12 |
| 전체 패딩 | `EdgeInsets.all(16)` |
| AppBar | `SliverAppBar`, floating: true, snap: true (스크롤 시 숨겨짐) |
| 로딩 | `CircularProgressIndicator` (Primary 컬러) |
| 에러 | 중앙 에러 메시지 + 재시도 버튼 |
| 빈 상태 | "포켓몬을 찾을 수 없어요" + 포켓볼 아이콘 |

---

### 4-2. PokemonDetailPage (상세 페이지)

```
┌──────────────────────────────────┐
│  [타입 컬러 그라디언트 헤더 영역]    │
│                                  │
│  ← (뒤로가기)          ♡ (즐겨찾기) │
│                                  │
│        [포켓몬 이미지 200×200]      │  ← Hero 애니메이션
│                                  │
│  #0001                           │
│  이상해씨           [풀] [독]      │
├──────────────────────────────────┤
│  ┌────────┬──────────┬─────────┐ │
│  │ 능력치 │   특성   │  진화   │ │  ← TabBar
│  └────────┴──────────┴─────────┘ │
├──────────────────────────────────┤
│                                  │
│  [탭 내용 영역]                   │
│                                  │
│  < 능력치 탭 >                    │
│  키: 0.7m   무게: 6.9kg           │
│  HP     45  ████░░░              │
│  공격    49  ████░░░              │
│  방어    49  ████░░░              │
│  특수공격 65  █████░░             │
│  특수방어 65  █████░░             │
│  스피드  45  ████░░░              │
│  합계   318                      │
│                                  │
└──────────────────────────────────┘
```

| 속성 | 값 |
|------|---|
| 헤더 높이 | 280dp |
| 헤더 배경 | 타입1 → 타입2 LinearGradient (각도: 135°) |
| 이미지 크기 | 200×200dp, Hero 위젯으로 감쌈 |
| 이미지 위치 | 헤더 하단 경계에 걸쳐 오버플로우 (overlap 48dp) |
| 콘텐츠 카드 | 상단 모서리 `BorderRadius.circular(32)` |
| TabBar 인디케이터 | Primary 컬러, 두께 3dp |
| 탭 내용 패딩 | `EdgeInsets.symmetric(horizontal: 24, vertical: 16)` |

---

### 4-3. FavoritesPage (즐겨찾기 탭)

```
┌──────────────────────────────────┐
│  AppBar: "즐겨찾기"               │
├──────────────────────────────────┤
│                                  │
│  < 즐겨찾기 있을 때 >             │
│  PokemonGrid (ListPage와 동일)    │
│                                  │
│  < 즐겨찾기 없을 때 >             │
│                                  │
│      [포켓볼 아이콘 (흐림)]        │
│  "아직 즐겨찾기한 포켓몬이 없어요"  │
│  "하트를 눌러 추가해보세요 💕"     │
│                                  │
└──────────────────────────────────┘
```

| 속성 | 값 |
|------|---|
| 빈 상태 아이콘 | 포켓볼 SVG, 80×80dp, opacity 0.3 |
| 빈 상태 텍스트 | `bodyLarge`, color Outline |
| 그리드 | ListPage와 동일한 2열 구성 |

---

### 4-4. BottomNavigationBar

Material 3 `NavigationBar` 사용.

| 탭 | 아이콘 (inactive) | 아이콘 (active) | 레이블 |
|----|------------------|----------------|--------|
| 도감 | `Icons.catching_pokemon_outlined` | `Icons.catching_pokemon` | 도감 |
| 즐겨찾기 | `Icons.favorite_outline` | `Icons.favorite` | 즐겨찾기 |

---

## 5. 애니메이션 포인트

### 5-1. Hero 전환 (목록 → 상세)

| 항목 | 내용 |
|------|------|
| 트리거 | PokemonCard 탭 |
| Hero tag | `'pokemon-image-{id}'` |
| 이미지 | 카드의 96dp → 상세의 200dp로 자연스럽게 확대 |
| 배경 | `PageRouteBuilder`로 커스텀 루트, 상세 페이지 배경 fade in |
| 소요시간 | 기본 Hero 지속시간 (약 300ms) |
| 주의 | `CachedNetworkImage` + Hero 조합 시 `placeholderBuilder`에도 동일 크기 위젯 필요 |

---

### 5-2. StatBar 진입 애니메이션

| 항목 | 내용 |
|------|------|
| 트리거 | 능력치 탭 첫 진입 시 |
| 구현 | `AnimatedContainer` 또는 `TweenAnimationBuilder<double>` |
| 시작값 | width: 0 |
| 끝값 | width: (stat / 255) * maxBarWidth |
| 커브 | `Curves.easeOut` |
| 지속 | `800ms` |
| 딜레이 | 각 스탯 행마다 `50ms * index` 스태거 |

---

### 5-3. 타입 필터 전환

| 항목 | 내용 |
|------|------|
| 트리거 | TypeFilterChip 선택/해제 |
| 효과 | 그리드 아이템 `AnimatedSwitcher` or `SliverAnimatedList` |
| 칩 선택 | 배경색 `AnimatedContainer` 200ms 전환 |
| 칩 미선택 | 역방향 200ms |

---

### 5-4. 즐겨찾기 토글 애니메이션

| 항목 | 내용 |
|------|------|
| 트리거 | 하트 아이콘 탭 |
| 효과 | `ScaleTransition` — 1.0 → 1.3 → 1.0, 총 300ms |
| 색상 | `ColorTween(Outline → Primary)` |
| 진동 (선택) | `HapticFeedback.lightImpact()` |

---

### 5-5. 페이지 진입 (전반)

| 항목 | 내용 |
|------|------|
| ListPage 초기 로드 | 카드들 순차 `FadeIn` + 아래에서 위로 `SlideTransition`, 30ms 스태거 |
| DetailPage 콘텐츠 | 헤더 → 탭 영역 순서로 `FadeIn`, 100ms 딜레이 |

---

## 6. 기타 디자인 원칙

- **일관된 여백:** 기준 단위 8dp. 16dp (컨텐츠 여백), 24dp (섹션 간격), 32dp (헤더 내부).
- **다크 모드:** Phase 2에서 대응. 현재는 라이트 전용.
- **접근성:** 타입 컬러 배경 위 텍스트는 항상 흰색 (`#FFFFFF`) — 명도 대비 4.5:1 이상 확인 필요. 이미지에 `semanticsLabel` 제공.
- **로딩 스켈레톤:** `shimmer` 패키지 사용 권장. 카드 형태 그대로 shimmer 효과.

---

*디자인 가이드라인 끝. 질문 또는 수정 요청은 견희(Designer)에게 전달해주세요. 🌸*
