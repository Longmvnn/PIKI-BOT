-- Run this once in Supabase SQL Editor if user changes still fail because of permissions.
-- This allows the Netlify frontend anon key to read/write the shared app state and storage objects used by the app.

alter table public.report_settings enable row level security;

drop policy if exists "piki report settings read" on public.report_settings;
drop policy if exists "piki report settings insert" on public.report_settings;
drop policy if exists "piki report settings update" on public.report_settings;

create policy "piki report settings read"
on public.report_settings for select
to anon, authenticated
using (true);

create policy "piki report settings insert"
on public.report_settings for insert
to anon, authenticated
with check (true);

create policy "piki report settings update"
on public.report_settings for update
to anon, authenticated
using (true)
with check (true);

insert into storage.buckets (id, name, public)
values ('generated-reports','generated-reports',false)
on conflict (id) do nothing;

drop policy if exists "piki storage read" on storage.objects;
drop policy if exists "piki storage insert" on storage.objects;
drop policy if exists "piki storage update" on storage.objects;
drop policy if exists "piki storage delete" on storage.objects;

create policy "piki storage read"
on storage.objects for select
to anon, authenticated
using (bucket_id = 'generated-reports');

create policy "piki storage insert"
on storage.objects for insert
to anon, authenticated
with check (bucket_id = 'generated-reports');

create policy "piki storage update"
on storage.objects for update
to anon, authenticated
using (bucket_id = 'generated-reports')
with check (bucket_id = 'generated-reports');

create policy "piki storage delete"
on storage.objects for delete
to anon, authenticated
using (bucket_id = 'generated-reports');
