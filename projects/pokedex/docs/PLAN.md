# Flutter 안드로이드 포켓몬 도감 앱 — 기획서 및 기능 명세서

> 작성: 사마의 (Planner)  
> 날짜: 2026-05-13  
> 버전: v1.0

---

## 1. 프로젝트 개요

포켓몬 도감(Pokédex) 앱. 안드로이드 타겟. Flutter로 개발.  
PokeAPI를 기반으로 포켓몬 정보를 탐색하고, 즐겨찾기를 로컬에 저장한다.

---

## 2. 기능 범위

### MVP (Phase 1)
| 기능 | 설명 |
|------|------|
| 포켓몬 목록 | 전 세대 포켓몬 페이지네이션(무한 스크롤) |
| 검색 | 이름 또는 번호로 실시간 검색 |
| 타입 필터 | 불꽃, 물, 풀 등 18개 타입별 필터링 |
| 상세 정보 | 이미지, 타입, 능력치(HP/공격/방어 등), 특성, 진화 체인 |
| 즐겨찾기 | 하트 토글 → 로컬 저장, 즐겨찾기 목록 페이지 |

### 추후 확장 (Phase 2+)
| 기능 | 설명 |
|------|------|
| 세대별 필터 | 1~9세대 분류 |
| 기술(Move) 상세 | 포켓몬이 배울 수 있는 기술 목록 |
| 비교 기능 | 두 포켓몬 능력치 나란히 비교 |
| 오프라인 캐시 | 로컬 DB에 자주 보는 포켓몬 캐싱 |
| 다국어 지원 | 한국어 포켓몬 이름 표시 |
| 위젯 | 홈 화면 즐겨찾기 포켓몬 위젯 |

---

## 3. 사용 API

**PokeAPI** (https://pokeapi.co)

무료, 인증 불필요, RESTful. 주요 엔드포인트:

| 용도 | 엔드포인트 |
|------|-----------|
| 목록 | `GET /api/v2/pokemon?limit=20&offset=0` |
| 상세 | `GET /api/v2/pokemon/{id or name}` |
| 타입 | `GET /api/v2/type/{id}` |
| 진화 체인 | `GET /api/v2/evolution-chain/{id}` |
| 포켓몬 종 (한국어 이름 등) | `GET /api/v2/pokemon-species/{id}` |

**고려사항:**
- 응답 캐싱 필수 (동일 요청 반복 방지) → `dio` + `dio_cache_interceptor` 사용
- 이미지: `https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/{id}.png`

---

## 4. 화면 구성 및 네비게이션

```
AppShell (BottomNavigationBar)
├── 🏠 홈 / 도감 탭
│   └── PokemonListPage
│       ├── SearchBar (상단)
│       ├── TypeFilterChips
│       └── PokemonGrid (무한 스크롤)
│           └── [tap] → PokemonDetailPage
│               ├── 기본 정보 (이름, 번호, 타입, 이미지)
│               ├── 능력치 탭 (Stats)
│               ├── 특성 탭 (Abilities)
│               └── 진화 탭 (Evolution Chain)
└── ❤️ 즐겨찾기 탭
    └── FavoritesPage
        └── PokemonGrid (즐겨찾기 목록)
            └── [tap] → PokemonDetailPage
```

**라우팅:** `go_router` 사용. Named routes로 딥링크 대비.

---

## 5. 기술 스택

### 코어
| 항목 | 선택 | 이유 |
|------|------|------|
| 프레임워크 | Flutter 3.x | 요구사항 |
| 언어 | Dart 3.x | Flutter 기본 |
| 상태관리 | **Riverpod 2.x** | 선언적, 테스트 용이, 코드 생성 지원 |

### 주요 패키지
| 패키지 | 용도 |
|--------|------|
| `riverpod` + `flutter_riverpod` | 상태관리 |
| `riverpod_generator` | Provider 코드 생성 |
| `dio` | HTTP 클라이언트 |
| `dio_cache_interceptor` | API 응답 캐싱 |
| `go_router` | 네비게이션 |
| `shared_preferences` | 즐겨찾기 로컬 저장 |
| `cached_network_image` | 이미지 캐싱 |
| `freezed` | 불변 데이터 모델 |
| `json_serializable` | JSON 직렬화 |

### 아키텍처
```
lib/
├── core/           # 공통 유틸, 테마, 상수
├── data/
│   ├── api/        # PokeAPI 클라이언트
│   ├── models/     # Freezed 데이터 모델
│   └── repositories/
├── domain/
│   └── providers/  # Riverpod providers
└── presentation/
    ├── pages/
    └── widgets/
```

**패턴:** Repository Pattern + Riverpod Provider.  
비즈니스 로직은 Provider에, UI는 ConsumerWidget에.

---

## 6. 개발 우선순위

### Sprint 1 — 뼈대 (MVP 기반)
1. 프로젝트 세팅, 패키지 설치, 폴더 구조
2. PokeAPI 클라이언트 + 응답 모델 정의
3. 포켓몬 목록 페이지 (무한 스크롤)
4. 포켓몬 상세 페이지 (기본 정보 + 능력치)

### Sprint 2 — 핵심 기능 완성
5. 검색 기능 (실시간)
6. 타입 필터
7. 즐겨찾기 (로컬 저장 + 목록 페이지)
8. 진화 체인 표시

### Sprint 3 — 품질 및 확장
9. 오프라인 캐싱 강화
10. UI 폴리싱 (애니메이션, 타입별 컬러 테마)
11. Phase 2 기능 중 우선순위 재협의

---

## 7. 비고

- 한국어 이름은 `pokemon-species` API의 `names` 필드 활용 (language: `ko`)
- 타입별 컬러는 하드코딩 상수로 관리 (불꽃=주황, 물=파랑 등)
- BLoC 대신 Riverpod 선택 이유: 보일러플레이트가 적고 소규모~중규모 앱에 적합. 추후 팀 확장 시 재검토 가능.

---

*기획서 끝. 질문 또는 수정 사항은 조조(Manager)를 통해 에스컬레이션 바랍니다.*
