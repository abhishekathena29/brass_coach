# BrassCoach AI

Project context and implementation plan — kept up to date as work progresses. Read this before starting work on the repo; update the **Status** section whenever a phase's state changes.

## What this is

BrassCoach AI is a practice companion for brass players (trumpet, trombone, French horn, tuba). It records a player, compares the performance against pre-analyzed professional reference recordings, and turns the numerical differences into specific, plain-language coaching via Claude — not just a pitch-accuracy percentage.

**Problem it solves**: brass players practice alone most of the time. They can hear something is off but can't always diagnose *what* (flat pitch vs. airy tone, late rhythm vs. soft attack), and human teacher feedback is expensive and infrequent.

## Features (target scope)

1. **Real-time audio capture** — mic input via Web Audio API equivalent, segmented bar-by-bar in sync with a metronome so each chunk maps to the matching reference passage.
2. **Professional reference library** — curated recordings (scales, études, excerpts, pieces), organized by instrument/difficulty/technique, each pre-analyzed offline (pitch curve, rhythm grid, dynamics envelope, spectral fingerprint) so comparison is instant.
3. **Multi-dimensional audio analysis** — four dimensions per recorded segment:
   - *Pitch*: YIN autocorrelation, ±5 cents accuracy, DTW-aligned to the reference before comparison.
   - *Rhythm*: onset detection vs. reference grid, deviations reported in ms.
   - *Tone quality*: MFCCs + spectral centroid.
   - *Dynamics*: RMS amplitude envelope shape.
4. **Error visualization suite** — pitch lane (reference vs. user line + shaded error gap), waveform overlay, note × dimension error heatmap, score summary with AI feedback pills.
5. **AI feedback engine (Claude)** — analysis deltas + instrument/piece/player-history context sent to Claude, which returns specific coaching language (e.g. "intonation sharpens above G4 — sign of embouchure tension, try long tones on G4/A4 with a drone").
6. **Session history & progress tracking** — every session stored with full analysis; trend tracking per piece/technique/error-type over time.
7. **Adaptive practice goals** — AI sets next-session goals (specific bars, techniques, dynamic/tonal targets) based on session history; updates as the player improves or plateaus.

## Current state (as of 2026-09-05)

Flutter app with a fully **mocked UI**, no data/logic behind it yet:

- Screens: [today_page.dart](lib/features/today/presentation/pages/today_page.dart), [practice_page.dart](lib/features/practice/presentation/pages/practice_page.dart) (titled "Session"), [library_page.dart](lib/features/library/presentation/pages/library_page.dart), [progress_page.dart](lib/features/progress/presentation/pages/progress_page.dart), [profile_page.dart](lib/features/profile/presentation/pages/profile_page.dart) — tabbed via `go_router`'s `StatefulShellRoute` in [app_router.dart](lib/core/router/app_router.dart).
- Chart widgets already visually built with `CustomPaint` on hardcoded data: [pitch_lane_chart.dart](lib/features/practice/presentation/widgets/pitch_lane_chart.dart), [error_heatmap.dart](lib/features/practice/presentation/widgets/error_heatmap.dart), [waveform_bars.dart](lib/features/library/presentation/widgets/waveform_bars.dart), [trend_bar_chart.dart](lib/features/progress/presentation/widgets/trend_bar_chart.dart).
- Shared design system in [shared/widgets/](lib/shared/widgets/) (`Panel`, `Pill`, `StatTile`, `MeterRow`, `PhoneShell`, etc.) and [core/theme/](lib/core/theme/).
- `pubspec.yaml` deps: only `go_router`, `google_fonts`, `lucide_icons` — no state management, no networking, no audio, no backend.

The visual language is settled. Remaining work is entirely about building the real system behind these screens, without redesigning them.

## Architecture decisions

- **DSP work (YIN pitch tracking, DTW alignment, MFCC/spectral centroid, RMS envelopes) runs on a backend, not on-device.** Flutter/Dart has no mature DSP libraries for this; Python (`librosa`/`numpy`/`scipy`) does. One shared implementation analyzes both the reference library (offline) and user session uploads (on record), avoiding drift between the two. Tradeoff: per-segment upload latency instead of instant on-device feedback — acceptable since capture is bar-segmented, not frame-accurate real-time.
- **Backend**: FastAPI (Python).
- **Storage**: Postgres for structured data (users, sessions, scores, goals, reference metadata) + S3-compatible object storage for audio files.
- **AI**: Claude API (Messages API) called from the backend only — never from the client, so the API key isn't shipped.
- **Client state management**: introduce Riverpod (pairs cleanly with existing `go_router` usage).
- **Auth**: Supabase Auth or Firebase Auth — needed before session history/progress means anything per-user.
- **Data model (draft)**: `User`, `Instrument`, `ReferenceTrack`, `ReferenceAnalysis`, `PracticeSession`, `SegmentAnalysis`, `Feedback`, `Goal`.

## Implementation plan — phased

Recommended order: **0 → 1 → 2 → 3 → 4 → 5 → 6 → 7**. Phases 1 and 3 share the same DSP pipeline, so building it once in Phase 1 pays off immediately in Phase 3. Each phase produces something demoable.

### Phase 0 — Foundations
- Add `riverpod`/`flutter_riverpod`, `dio`, `just_audio` or `record` to `pubspec.yaml`.
- FastAPI skeleton + Postgres schema for the data model above.
- Repository layer in the client (`SessionRepository`, `LibraryRepository`, etc.) so widgets read from a data source instead of hardcoded lists — can land before the backend is finished (mock-backed at first).
- Auth wired in.

### Phase 1 — Professional Reference Library (feature 2)
- Build the DSP pipeline: ingest a recording → YIN pitch curve, onset/rhythm grid, MFCC + spectral centroid, RMS envelope, all bar-segmented.
- Admin/ingestion tooling to upload + tag reference recordings and run the pipeline offline → `ReferenceAnalysis`.
- Wire [library_page.dart](lib/features/library/presentation/pages/library_page.dart) / [track_card.dart](lib/features/library/presentation/widgets/track_card.dart) to real catalog data + filters.

### Phase 2 — Real-Time Audio Capture (feature 1)
- Mic capture (`record`/`flutter_sound`), metronome click track, bar-boundary segmentation aligned to the reference's bar structure.
- Upload segments as they complete; local playback/waveform preview immediate, analysis result arrives async.
- Wire [transport_controls.dart](lib/features/practice/presentation/widgets/transport_controls.dart) to real record/play/metronome state.

### Phase 3 — Multi-Dimensional Audio Analysis (feature 3)
- Same DSP pipeline as Phase 1, applied per uploaded user segment.
- DTW alignment (`dtw-python` or `fastdtw`) between user and reference pitch curves before scoring.
- Produce per-note, per-dimension error scores → `SegmentAnalysis` rows.

### Phase 4 — Error Visualization Suite (feature 4)
- Mostly data-wiring, not new UI — existing chart widgets just need real `SegmentAnalysis` data via the Phase 0 repository layer.
- Score summary + feedback pills on [practice_page.dart](lib/features/practice/presentation/pages/practice_page.dart) need Phase 5's AI output.

### Phase 5 — AI Feedback Engine (feature 5)
- Backend endpoint: dimension deltas + instrument/piece/player-history context → Claude → structured output (headline issue, explanation, suggested drill) + free-text coaching paragraph.
- Store as `Feedback` rows linked to the session.
- Design the prompt/response schema so it can also feed Phase 7 without a second round-trip.

### Phase 6 — Session History & Progress Tracking (feature 6)
- Persist every session with full analysis; backend aggregation queries for trend-over-time per piece/technique/error-type.
- Wire [progress_page.dart](lib/features/progress/presentation/pages/progress_page.dart) / [trend_bar_chart.dart](lib/features/progress/presentation/widgets/trend_bar_chart.dart) to these aggregates.

### Phase 7 — Adaptive Practice Goals (feature 7)
- Rule-based baseline first (worst-scoring dimension + bar range from last 3 sessions), then Claude-refined goal text once Phase 5's context pipeline exists.
- Recompute after each session; surface on [today_page.dart](lib/features/today/presentation/pages/today_page.dart)'s [warmup_list.dart](lib/features/today/presentation/widgets/warmup_list.dart), replacing the static list.

## Cross-cutting concerns

- **Audio privacy/retention**: decide raw recording retention period; add deletion from Profile settings.
- **Async UX**: Practice screen needs a pending/processing state per segment (analysis isn't instant) — not in the current mock.
- **Testing**: DSP pipeline needs golden-file tests (known input → expected output) since it's the correctness-critical core.
- **Cost**: Claude calls and audio storage scale with session volume — meter early.

## Status

| Phase | Status |
|---|---|
| 0 — Foundations | Not started |
| 1 — Reference Library | Not started |
| 2 — Audio Capture | Not started |
| 3 — Multi-Dimensional Analysis | Not started |
| 4 — Error Visualization | Not started (UI shell exists, mocked) |
| 5 — AI Feedback Engine | Not started |
| 6 — Session History & Progress | Not started |
| 7 — Adaptive Practice Goals | Not started |
