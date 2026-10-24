# BrassCoach AI

Flutter practice companion for brass players.

## Run the app

Install dependencies and start the app:

```sh
flutter pub get
flutter run
```

The welcome screen leads to Firebase email and password sign-in. New users can
create an account from the same screen. The app uses the Firebase project already
configured in `lib/firebase_options.dart`.

After signing in, players enter their name, instrument, experience level, and
practice goal before using the app. They can edit all four later in Profile.
Accounts missing any of these details are prompted to complete setup. No
instrument or piece is chosen for a new player.

Before running against Firebase, enable **Email/Password** in Firebase Console →
Authentication → Sign-in method, create a **Cloud Firestore** database, and deploy
the included per-user rules:

```sh
npm_config_cache=/private/tmp/brass_coach_npm_cache npx --yes firebase-tools login
npm_config_cache=/private/tmp/brass_coach_npm_cache npx --yes firebase-tools deploy --only firestore:rules --project brass-coach
```

Practice choices, personal details, dark mode, standalone metronome BPM, and saved practice
sessions live under `users/{uid}` in Firestore. Today, Progress, and Profile read
the saved account data. Firestore rules only allow the signed-in account to read
and write its own document and session history.

## Practice flow

Practice has separate Warm-up, Main practice, and Cool-down pages. Warm-up has
suggested exercises and search. Main practice has range, fluency, and music
sections. Choosing a Library piece sets the metronome to that piece's listed
tempo. The speed buttons adjust the click from 50% to 150% of the original BPM.

You can import an audio recording to play it at the same chosen speed. Enter its
original BPM from the score to match the click; BPM detection from audio is not
implemented. Library cards contain piece names and tempo metadata, but no audio
files. Imported audio files remain on the device; Firestore stores their title
and tempo settings, not the audio bytes.
