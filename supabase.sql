create extension if not exists "pgcrypto";

create table if not exists public.candidates (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  name text not null,
  email text not null,
  phone text not null,
  job_title text not null,
  skills text[] not null default '{}',
  status text not null check (status in ('Applied', 'Interview', 'Offer', 'Hired', 'Rejected', 'Waiting')),
  notes text not null default '',
  cv_url text not null default '',
  last_contact_date date,
  next_followup_date date,
  created_at timestamptz not null default now()
);

alter table public.candidates drop constraint if exists candidates_status_check;
alter table public.candidates
add constraint candidates_status_check
check (status in ('Applied', 'Interview', 'Offer', 'Hired', 'Rejected', 'Waiting'));

create index if not exists candidates_user_id_idx on public.candidates(user_id);
create index if not exists candidates_created_at_idx on public.candidates(created_at desc);

alter table public.candidates enable row level security;

drop policy if exists "candidates_select_own" on public.candidates;
create policy "candidates_select_own"
on public.candidates
for select
to authenticated
using (auth.uid() = user_id);

drop policy if exists "candidates_insert_own" on public.candidates;
create policy "candidates_insert_own"
on public.candidates
for insert
to authenticated
with check (auth.uid() = user_id);

drop policy if exists "candidates_update_own" on public.candidates;
create policy "candidates_update_own"
on public.candidates
for update
to authenticated
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

drop policy if exists "candidates_delete_own" on public.candidates;
create policy "candidates_delete_own"
on public.candidates
for delete
to authenticated
using (auth.uid() = user_id);

insert into storage.buckets (id, name, public)
values ('cvs', 'cvs', false)
on conflict (id) do nothing;

drop policy if exists "cvs_insert_own" on storage.objects;
create policy "cvs_insert_own"
on storage.objects
for insert
to authenticated
with check (bucket_id = 'cvs' and split_part(name, '/', 1) = auth.uid()::text);

drop policy if exists "cvs_select_own" on storage.objects;
create policy "cvs_select_own"
on storage.objects
for select
to authenticated
using (bucket_id = 'cvs' and split_part(name, '/', 1) = auth.uid()::text);
