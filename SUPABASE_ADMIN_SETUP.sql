-- Glassmart admin catalog + image storage setup.
-- Run in Supabase SQL Editor as project owner after reviewing existing policies.

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('glassmart-images', 'glassmart-images', true, 5242880, array['image/jpeg','image/png','image/webp','image/gif'])
on conflict (id) do update set public = true, file_size_limit = 5242880,
  allowed_mime_types = array['image/jpeg','image/png','image/webp','image/gif'];

drop policy if exists "Public can view Glassmart images" on storage.objects;
create policy "Public can view Glassmart images" on storage.objects for select to public using (bucket_id = 'glassmart-images');

drop policy if exists "Admins can upload Glassmart images" on storage.objects;
create policy "Admins can upload Glassmart images" on storage.objects for insert to authenticated with check (
  bucket_id = 'glassmart-images' and exists (select 1 from public.profiles p where p.id = auth.uid() and p.role = 'admin')
);
drop policy if exists "Admins can update Glassmart images" on storage.objects;
create policy "Admins can update Glassmart images" on storage.objects for update to authenticated using (
  bucket_id = 'glassmart-images' and exists (select 1 from public.profiles p where p.id = auth.uid() and p.role = 'admin')
) with check (
  bucket_id = 'glassmart-images' and exists (select 1 from public.profiles p where p.id = auth.uid() and p.role = 'admin')
);
drop policy if exists "Admins can delete Glassmart images" on storage.objects;
create policy "Admins can delete Glassmart images" on storage.objects for delete to authenticated using (
  bucket_id = 'glassmart-images' and exists (select 1 from public.profiles p where p.id = auth.uid() and p.role = 'admin')
);

alter table public.products enable row level security;
drop policy if exists "Public can read products" on public.products;
create policy "Public can read products" on public.products for select to anon, authenticated using (true);
drop policy if exists "Admins can manage products" on public.products;
create policy "Admins can manage products" on public.products for all to authenticated
using (exists (select 1 from public.profiles p where p.id = auth.uid() and p.role = 'admin'))
with check (exists (select 1 from public.profiles p where p.id = auth.uid() and p.role = 'admin'));

alter table public.hardware_products enable row level security;
drop policy if exists "Public can read active hardware products" on public.hardware_products;
create policy "Public can read active hardware products" on public.hardware_products for select to anon, authenticated using (active = true);
drop policy if exists "Admins can manage hardware products" on public.hardware_products;
create policy "Admins can manage hardware products" on public.hardware_products for all to authenticated
using (exists (select 1 from public.profiles p where p.id = auth.uid() and p.role = 'admin'))
with check (exists (select 1 from public.profiles p where p.id = auth.uid() and p.role = 'admin'));

alter table public.hardware_variants enable row level security;
drop policy if exists "Public can read active hardware variants" on public.hardware_variants;
create policy "Public can read active hardware variants" on public.hardware_variants for select to anon, authenticated using (active = true);
drop policy if exists "Admins can manage hardware variants" on public.hardware_variants;
create policy "Admins can manage hardware variants" on public.hardware_variants for all to authenticated
using (exists (select 1 from public.profiles p where p.id = auth.uid() and p.role = 'admin'))
with check (exists (select 1 from public.profiles p where p.id = auth.uid() and p.role = 'admin'));

drop policy if exists "Admins can manage quotations" on public.quotations;
create policy "Admins can manage quotations" on public.quotations for all to authenticated
using (exists (select 1 from public.profiles p where p.id = auth.uid() and p.role = 'admin'))
with check (exists (select 1 from public.profiles p where p.id = auth.uid() and p.role = 'admin'));
