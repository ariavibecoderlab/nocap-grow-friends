UPDATE auth.users
SET encrypted_password = crypt('swipe2GO#', gen_salt('bf')),
    email_confirmed_at = COALESCE(email_confirmed_at, now()),
    updated_at = now(),
    banned_until = NULL,
    deleted_at = NULL
WHERE email = 'superadmin@nocap.life';