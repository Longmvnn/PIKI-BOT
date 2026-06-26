
create table if not exists public.report_settings (
  id uuid primary key default gen_random_uuid(),
  setting_name text unique not null,
  setting_value jsonb default '{}'::jsonb,
  updated_by uuid,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

alter table public.report_settings enable row level security;

drop policy if exists "Allow anon read report settings" on public.report_settings;
create policy "Allow anon read report settings"
on public.report_settings
for select
to anon
using (true);

drop policy if exists "Allow anon insert report settings" on public.report_settings;
create policy "Allow anon insert report settings"
on public.report_settings
for insert
to anon
with check (true);

drop policy if exists "Allow anon update report settings" on public.report_settings;
create policy "Allow anon update report settings"
on public.report_settings
for update
to anon
using (true)
with check (true);

insert into storage.buckets (id, name, public)
values ('generated-reports', 'generated-reports', false)
on conflict (id) do nothing;

drop policy if exists "Allow anon read generated reports" on storage.objects;
create policy "Allow anon read generated reports"
on storage.objects
for select
to anon
using (bucket_id = 'generated-reports');

drop policy if exists "Allow anon upload generated reports" on storage.objects;
create policy "Allow anon upload generated reports"
on storage.objects
for insert
to anon
with check (bucket_id = 'generated-reports');

drop policy if exists "Allow anon update generated reports" on storage.objects;
create policy "Allow anon update generated reports"
on storage.objects
for update
to anon
using (bucket_id = 'generated-reports')
with check (bucket_id = 'generated-reports');

drop policy if exists "Allow anon delete generated reports" on storage.objects;
create policy "Allow anon delete generated reports"
on storage.objects
for delete
to anon
using (bucket_id = 'generated-reports');
