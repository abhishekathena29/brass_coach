# BrassCoach AI

Flutter practice companion for brass players.

## Run with email sign-in

The welcome and sign-in screens use Supabase Auth. Create a Supabase project,
enable email authentication, and create an email/password user in the Supabase
dashboard. Then run the app with your project URL and publishable key:

```sh
flutter pub get
flutter run \
  --dart-define=SUPABASE_URL=https://YOUR_PROJECT.supabase.co \
  --dart-define=SUPABASE_PUBLISHABLE_KEY=YOUR_PUBLISHABLE_KEY
```

Use the same defines for a release build. When they are absent, the sign-in
screen explains that authentication needs configuration. The app restores an
existing Supabase session on launch and protects the tabbed screens until a
user signs in. The Profile screen provides sign-out.
