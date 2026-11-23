-- Handy Hub secure Supabase setup
-- Run this in Supabase Dashboard > SQL Editor > New query.

create extension if not exists pgcrypto;

create table if not exists public.admin_users (
  user_id uuid primary key references auth.users(id) on delete cascade,
  email text not null unique,
  created_at timestamptz not null default now()
);

create table if not exists public.products (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  category text not null,
  price numeric(12,2) not null check (price >= 0),
  old_price numeric(12,2),
  description text default '',
  status text not null default 'available' check (status in ('available','out')),
  badge text,
  image_url text,
  created_at timestamptz not null default now()
);

alter table public.admin_users enable row level security;
alter table public.products enable row level security;

-- Explicit API privileges; RLS policies below still decide which rows/actions are allowed.
grant select on public.admin_users to authenticated;
grant select on public.products to anon, authenticated;
grant insert, update, delete on public.products to authenticated;

create or replace function public.is_handyhub_admin()
returns boolean
language sql
stable
security definer
set search_path = public, auth
as $$
  select exists (
    select 1 from public.admin_users
    where user_id = (select auth.uid())
  );
$$;

revoke all on function public.is_handyhub_admin() from public;
grant execute on function public.is_handyhub_admin() to anon, authenticated;

drop policy if exists "Admin can read own admin record" on public.admin_users;
create policy "Admin can read own admin record"
on public.admin_users for select to authenticated
using (user_id = (select auth.uid()));

drop policy if exists "Public can read available products" on public.products;
create policy "Public can read available products"
on public.products for select to anon, authenticated
using (status = 'available');

drop policy if exists "Admins can read all products" on public.products;
create policy "Admins can read all products"
on public.products for select to authenticated
using (public.is_handyhub_admin());

drop policy if exists "Admins can insert products" on public.products;
create policy "Admins can insert products"
on public.products for insert to authenticated
with check (public.is_handyhub_admin());

drop policy if exists "Admins can update products" on public.products;
create policy "Admins can update products"
on public.products for update to authenticated
using (public.is_handyhub_admin())
with check (public.is_handyhub_admin());

drop policy if exists "Admins can delete products" on public.products;
create policy "Admins can delete products"
on public.products for delete to authenticated
using (public.is_handyhub_admin());

-- Public product image viewing; only authorized admins can upload/update/delete.
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('product-images', 'product-images', true, 2097152,
        array['image/jpeg','image/png','image/webp'])
on conflict (id) do update set public = true, file_size_limit = 2097152,
  allowed_mime_types = excluded.allowed_mime_types;

drop policy if exists "Anyone can view product images" on storage.objects;
create policy "Anyone can view product images"
on storage.objects for select to anon, authenticated
using (bucket_id = 'product-images');

drop policy if exists "Admins can upload product images" on storage.objects;
create policy "Admins can upload product images"
on storage.objects for insert to authenticated
with check (bucket_id = 'product-images' and public.is_handyhub_admin());

drop policy if exists "Admins can update product images" on storage.objects;
create policy "Admins can update product images"
on storage.objects for update to authenticated
using (bucket_id = 'product-images' and public.is_handyhub_admin())
with check (bucket_id = 'product-images' and public.is_handyhub_admin());

drop policy if exists "Admins can delete product images" on storage.objects;
create policy "Admins can delete product images"
on storage.objects for delete to authenticated
using (bucket_id = 'product-images' and public.is_handyhub_admin());

-- OPTIONAL starter products (uncomment to add demo catalogue)
-- insert into public.products (name,category,price,old_price,description,status,badge)
-- values
-- ('Multi-Function Kitchen Chopper','Kitchen Appliances',349,499,'A handy everyday kitchen helper for quick food preparation.','available','trending'),
-- ('Classic Everyday Wrist Watch','Watches',499,699,'A simple everyday watch with a versatile look.','available','new'),
-- ('Comfort Casual Dress','Dresses',599,799,'An easy-to-style outfit for everyday wear.','available',null),
-- ('Kids Fun Building Toy Set','Kids Toys',299,399,'A playful activity set for little creators.','out','trending');
