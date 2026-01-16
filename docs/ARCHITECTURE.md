# UI Architecture (Proposed)

Goal: production-ready Flutter app with clean separation between UI, state, and API.

## Layers

1) **Presentation (UI)**
- Screens/pages
- Widgets
- Navigation

2) **Application (State/Use-cases)**
- Controllers / Notifiers
- Form validation and orchestration

3) **Domain (Models)**
- DTOs / domain models
- Minimal logic (pure)

4) **Infrastructure (API/Storage)**
- HTTP client
- Interceptors (request id, auth header)
- Local persistence (optional)

## Suggested folder structure
(Once Flutter scaffold exists)

- `lib/app/` (app bootstrap, routing, theme)
- `lib/features/` (feature modules)
  - `pasien/`
  - `billing/`
- `lib/shared/` (reusable widgets, utilities)
- `lib/infrastructure/` (http client, storage)

## API integration
- API base URL comes from `--dart-define=API_BASE_URL=...`
- All requests to `/v1/*` must include `X-User-Id` header (current auth model)

## Production readiness checklist
- Logging (redact sensitive data)
- Error handling + user-friendly messages
- Build flavors (dev/staging/prod)
- CI: analyze + test + build
- No secrets in repo
