# Handy Hub Storefront — Supabase edition

## Configured
- WhatsApp order enquiries: +91 79076 15643
- Instagram: @handyhub_store
- Email: handyhubstore01@gmail.com
- Currency: INR
- Brand images: cover.jpg, handy-hub-logo.png, handy-hub-mascot.png in the repository root.

No Facebook page URL was supplied, so a Facebook link has not been invented.

## Required setup before public launch
1. Open https://bbbzodqqbacbgjmavyqo.supabase.co and open SQL Editor.
2. Run the complete supabase-setup.sql file.
3. In Authentication > Users, create the owner account: handyhubstore01@gmail.com. Use a strong unique password.
4. Copy that user's UUID.
5. Run this SQL after replacing the placeholder with the exact UUID:
   `insert into public.admin_users (user_id, email) values ('PASTE_AUTH_USER_UUID', 'handyhubstore01@gmail.com');`
6. In Authentication > URL Configuration, add the GitHub Pages URL: https://handyhubstore01-sudo.github.io/HandyHub-Store/
7. Disable public sign-ups after creating the owner account.
8. Keep index.html and all three image files together in the repository root.

## Security
The previous visible demo PIN has been removed. Admin login uses Supabase email/password and access is limited to the UUID allow-listed in public.admin_users. Product create/update/delete and product image uploads are restricted by Row Level Security. Never put a Supabase service_role or secret key in this website; only the publishable key belongs in browser code.

## Limitations
WhatsApp opens a pre-filled order enquiry; it does not take payment or automatically confirm an order. This is a product catalogue with WhatsApp ordering, not a payment gateway, supplier integration, or full shipping system. Configure and test Supabase before accepting orders. No Facebook page URL was provided.
