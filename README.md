# BrassCoach AI

Flutter practice companion for brass players.

## Run the app

Install dependencies and start the app:

```sh
flutter pub get
flutter run
```

The welcome screen leads to a temporary local sign-in. Enter any name or email
and any password, or leave both blank, to explore the app. The sign-in state is
kept only while the app is running; it resets on restart. Profile has a button
to return to the welcome screen.

## Practice flow

Practice has separate Warm-up, Main practice, and Cool-down pages. Warm-up has
suggested exercises and search. Main practice has range, fluency, and music
sections. Choosing a Library piece sets the metronome to that piece's listed
tempo. The speed buttons adjust the click from 50% to 150% of the original BPM.

You can import an audio recording to play it at the same chosen speed. Enter its
original BPM from the score to match the click; BPM detection from audio is not
implemented. Library cards contain piece names and tempo metadata, but no audio
files. Profile has an app-wide dark mode setting that is saved on the device.
