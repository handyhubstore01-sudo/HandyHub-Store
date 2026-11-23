# Handy Hub Storefront — Supabase edition

This folder contains the storefront, supplied brand assets, and the SQL needed for a protected admin area.

## Already configured in the website
- WhatsApp order enquiry: **+91 79076 15643**. Product buttons open WhatsApp with the product name and price pre-filled.
- Instagram: **@handyhub_store**
- Email: **handyhubstore01@gmail.com**
- Currency: INR
- Logo, mascot and cover banner are stored in `assets/`.

Facebook URL/handle was not supplied, so no fake Facebook link has been added.

## Required setup before publishing

The website uses the Supabase project URL and publishable key previously supplied. The publishable key is intended for browser use; database security depends on the SQL policies below. Never put a Supabase `service_role` or secret key in this website.

1. Open the Supabase project: `https://bbbzodqqbacbgjmavyqo.supabase.co`.
2. Open **SQL Editor** and run the complete `supabase-setup.sql` file.
3. In **Authentication → Users**, create the owner account using `handyhubstore01@gmail.com` and a strong, unique password. Do not share that password.
4. Copy the new user's UUID from Authentication → Users.
5. In SQL Editor, run this statement after replacing `PASTE_AUTH_USER_UUID` with that exact UUID:

   ```sql
   insert into public.admin_users (user_id, email)
   values ('PASTE_AUTH_USER_UUID', 'handyhubstore01@gmail.com');
   ```

6. In **Authentication → URL Configuration**, add the final website URL to the allowed redirect URLs.
7. Disable public sign-ups in **Authentication → Settings** after creating the owner account. The site has no public registration screen.
8. Deploy the entire folder contents. Keep `index.html` and the `assets` folder together.

## How access is protected
- The old visible demo PIN has been removed.
- Sign-in uses Supabase email/password authentication.
- An authenticated user is admitted to the admin interface only if their Auth user UUID is in `public.admin_users`.
- Product reads and all create/update/delete actions are controlled by Row Level Security (RLS), not by hiding the admin page.
- Only allow-listed admins can upload or modify product images. Public visitors can view product images.
- Products and changes are stored centrally in Supabase and are shared across devices.

## Important limitations
- The WhatsApp button sends a pre-filled order enquiry; it does not automatically create a paid order or confirm stock.
- This is a product catalogue with WhatsApp ordering, not a payment gateway or full shipping/supplier integration.
- Configure and test Supabase before making the site public. Test public browsing in a signed-out/private browser and admin access with the owner account.
- No Facebook URL or separate phone number was supplied.
