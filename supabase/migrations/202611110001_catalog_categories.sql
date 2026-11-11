-- Glassmart category management
-- Run this file once in Supabase SQL Editor before using Admin > Categories.

create table if not exists public.catalog_categories (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  slug text not null unique,
  parent_id uuid null references public.catalog_categories(id) on delete restrict,
  sort_order integer not null default 0,
  active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists catalog_categories_parent_sort_idx
  on public.catalog_categories(parent_id, sort_order);

alter table public.catalog_categories enable row level security;

drop policy if exists "Public can read active catalog categories" on public.catalog_categories;
create policy "Public can read active catalog categories"
  on public.catalog_categories for select
  using (active = true);

drop policy if exists "Admins manage catalog categories" on public.catalog_categories;
create policy "Admins manage catalog categories"
  on public.catalog_categories for all
  to authenticated
  using (
    exists (
      select 1 from public.profiles
      where profiles.id = auth.uid() and profiles.role = 'admin'
    )
  )
  with check (
    exists (
      select 1 from public.profiles
      where profiles.id = auth.uid() and profiles.role = 'admin'
    )
  );

-- Seed the five approved main categories and their currently approved subcategories.
do $$
declare
  plywood_id uuid;
  hardware_id uuid;
  main_id uuid;
  item text;
  idx integer;
begin
  insert into public.catalog_categories(name, slug, parent_id, sort_order, active)
  values ('Plywood', 'plywood', null, 1, true)
  on conflict (slug) do update set name = excluded.name, sort_order = excluded.sort_order, active = true
  returning id into plywood_id;
  if plywood_id is null then select id into plywood_id from public.catalog_categories where slug='plywood'; end if;

  insert into public.catalog_categories(name, slug, parent_id, sort_order, active)
  values ('Hardware', 'hardware', null, 2, true)
  on conflict (slug) do update set name = excluded.name, sort_order = excluded.sort_order, active = true
  returning id into hardware_id;
  if hardware_id is null then select id into hardware_id from public.catalog_categories where slug='hardware'; end if;

  insert into public.catalog_categories(name, slug, parent_id, sort_order, active)
  values ('Glass', 'glass', null, 3, true),
         ('Laminates', 'laminates', null, 4, true),
         ('Modular Kitchen', 'modular-kitchen', null, 5, true)
  on conflict (slug) do update set name = excluded.name, sort_order = excluded.sort_order, active = true;

  idx := 0;
  foreach item in array array['Plywood','Block Board','MDP / Boards','Doors','Flexible Plywood','NFC Boards'] loop
    idx := idx + 1;
    insert into public.catalog_categories(name, slug, parent_id, sort_order, active)
    values (item, 'plywood-' || idx, plywood_id, idx, true)
    on conflict (slug) do update set name = excluded.name, parent_id = excluded.parent_id, sort_order = excluded.sort_order, active = true;
  end loop;

  idx := 0;
  foreach item in array array['Hinges','Tower Bolts','Aldrops','Latches','Handles','Goat Hooks','Baby Latches','Door Stoppers','Deluxe Window Stays','Wardrobe Handles & Knobs','Box Hinges','Telescope Channels'] loop
    idx := idx + 1;
    insert into public.catalog_categories(name, slug, parent_id, sort_order, active)
    values (item, 'hardware-' || idx, hardware_id, idx, true)
    on conflict (slug) do update set name = excluded.name, parent_id = excluded.parent_id, sort_order = excluded.sort_order, active = true;
  end loop;
end $$;
