# Recruitment Management Web App (HR Dashboard)

React + Vite + Tailwind + Supabase app for secure multi-tenant recruitment management.

## Quick Run (Windows)

- Double-click `run-site.bat`
- Or double-click `تشغيل-الموقع.bat`
- If browser does not open, use: `http://127.0.0.1:5173`

## Features

- Supabase Auth (signup/login/logout)
- Protected routes (`/dashboard`, `/candidates`)
- Strict tenant isolation with `user_id` + RLS
- Candidate CRUD + quick status updates
- Search by name/email
- Follow-up tracking + overdue highlights
- Dashboard cards + chart
- CV upload to Supabase Storage bucket (`cvs`)
- Responsive UI (mobile/tablet/iPad/laptop/desktop)
- Arabic + English friendly labels

## Setup

1. Install dependencies:

```bash
npm install
```

2. Set env values in `.env`:

```env
VITE_SUPABASE_URL=...
VITE_SUPABASE_ANON_KEY=...
```

3. Run `supabase.sql` in Supabase SQL Editor.

4. In Supabase Authentication settings:
- Disable email confirmation for quick local testing (optional)

5. Run app:

```bash
npm run dev
```

## Production Check (Before Sending to HR)

```bash
npm run lint
npm run build
```

If both commands pass, project is ready for deployment.

## Security

- RLS policies ensure each user accesses only their own candidates.
- Storage policies restrict CV files to each user's own folder.
- Frontend uses only anon key; access control is enforced in database/storage rules.
