# Create new superadmin credentials

## Context

The app has a single highest-privilege role: `admin` (enum `app_role`), checked via `has_role(uid, 'admin')`. It already grants access to every admin-only screen and RPC. We'll provision a new auth user and assign that role — no schema or code changes needed.

## Credentials to provision

- **Email:** `superadmin@nocap.life`
- **Temporary password:** `swipe2GO#` (change immediately after first login via `/reset-password`)
- **Email confirmed:** yes (no verification step required)

> If you want a different email or password, tell me before approving and I'll update the migration.

## Steps

1. **Create the auth user** via a one-shot SQL migration that calls `auth.admin`-equivalent inserts into `auth.users` with a bcrypt-hashed password (`crypt(...)` from `pgcrypto`), email confirmed.
2. **Trigger `handle_new_user**` runs automatically and creates:
  - `profiles` row (with generated referral code)
  - `wallets` row
  - `user_roles` row with default `member`
3. **Insert `admin` role** into `user_roles` for the new user_id (in addition to `member`).
4. **Set `full_name**` on the profile to "Super Admin".

## After approval

- Log in at `/admin-login` with the credentials above.
- Immediately change the password from `/my-profile` or via password reset.
- Optionally set a 6-digit PIN at `/set-pin`.

## Security note

Storing initial credentials in a migration is a one-time bootstrap. The password hash will be in migration history — that's why rotating it on first login is required. I will also update the security memory to note that the seeded password must be rotated.