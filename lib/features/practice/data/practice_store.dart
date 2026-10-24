import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../../auth/domain/auth_service.dart';

class PracticeSession {
  const PracticeSession({
    required this.piece,
    required this.focus,
    required this.at,
  });

  final String piece;
  final String focus;
  final DateTime at;

  factory PracticeSession.fromMap(Map<String, dynamic> map) => PracticeSession(
    piece: map['piece'] as String? ?? 'Practice',
    focus: map['focus'] as String? ?? 'Practice with music',
    at: (map['at'] as Timestamp?)?.toDate() ?? DateTime.now(),
  );
}

class PracticeData {
  const PracticeData({
    this.darkMode = false,
    this.displayName = '',
    this.level = '',
    this.goal = '',
    this.selectedWarmup,
    this.coolDownCompleted = const [],
    this.song = '',
    this.customTitle = '',
    this.customBpm = '',
    this.focus = 'Practice with music',
    this.speedPercent = 100,
    this.metronomeBpm = 100,
    this.instrument = '',
  });

  final bool darkMode;
  final String displayName;
  final String level;
  final String goal;
  final String? selectedWarmup;
  final List<int> coolDownCompleted;
  final String song;
  final String customTitle;
  final String customBpm;
  final String focus;
  final int speedPercent;
  final int metronomeBpm;
  final String instrument;

  bool get hasCompletedProfile =>
      displayName.trim().isNotEmpty &&
      instrument.trim().isNotEmpty &&
      level.trim().isNotEmpty &&
      goal.trim().isNotEmpty;

  factory PracticeData.fromMap(Map<String, dynamic>? map) {
    final data = map ?? const <String, dynamic>{};
    return PracticeData(
      darkMode: data['darkMode'] == true,
      displayName: data['displayName'] as String? ?? '',
      level: data['level'] as String? ?? '',
      goal: data['goal'] as String? ?? '',
      selectedWarmup: data['selectedWarmup'] as String?,
      coolDownCompleted: (data['coolDownCompleted'] as List<dynamic>? ?? [])
          .whereType<int>()
          .toList(),
      song: data['song'] as String? ?? '',
      customTitle: data['customTitle'] as String? ?? '',
      customBpm: data['customBpm'] as String? ?? '',
      focus: data['focus'] as String? ?? 'Practice with music',
      speedPercent: data['speedPercent'] as int? ?? 100,
      metronomeBpm: data['metronomeBpm'] as int? ?? 100,
      instrument: data['instrument'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
    'darkMode': darkMode,
    'displayName': displayName,
    'level': level,
    'goal': goal,
    'selectedWarmup': selectedWarmup,
    'coolDownCompleted': coolDownCompleted,
    'song': song,
    'customTitle': customTitle,
    'customBpm': customBpm,
    'focus': focus,
    'speedPercent': speedPercent,
    'metronomeBpm': metronomeBpm,
    'instrument': instrument,
  };
}

abstract class PracticeStore extends ChangeNotifier {
  PracticeData get data;
  bool get hasCompletedProfile => data.hasCompletedProfile;
  List<PracticeSession> get sessions;
  String? get error;
  bool get isLoaded;

  Future<void> save(Map<String, dynamic> fields);
  Future<void> logSession(String piece, String focus);
}

class FirestorePracticeStore extends PracticeStore {
  FirestorePracticeStore(this._firestore, this._auth) {
    _auth.addListener(_onAuthChanged);
    _onAuthChanged();
  }

  final FirebaseFirestore _firestore;
  final AuthService _auth;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _userSub;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _sessionsSub;
  Timer? _loadTimeout;
  String? _uid;
  PracticeData _data = const PracticeData();
  PracticeData _confirmedData = const PracticeData();
  List<PracticeSession> _sessions = const [];
  String? _error;
  bool _isLoaded = false;
  bool _creatingUser = false;

  @override
  PracticeData get data => _data;

  @override
  bool get hasCompletedProfile => _confirmedData.hasCompletedProfile;

  @override
  List<PracticeSession> get sessions => _sessions;

  @override
  String? get error => _error;

  @override
  bool get isLoaded => _isLoaded;

  void _onAuthChanged() {
    final uid = _auth.uid;
    if (uid == _uid) return;
    _userSub?.cancel();
    _sessionsSub?.cancel();
    _loadTimeout?.cancel();
    _uid = uid;
    _data = const PracticeData();
    _confirmedData = const PracticeData();
    _sessions = const [];
    _error = null;
    _isLoaded = uid == null;
    _creatingUser = false;
    notifyListeners();
    if (uid == null) return;

    final user = _firestore.collection('users').doc(uid);
    _loadTimeout = Timer(const Duration(seconds: 8), () {
      if (_uid != uid || _isLoaded) return;
      _error = 'Waiting for Firestore. Check your connection to load saved settings.';
      _isLoaded = true;
      notifyListeners();
    });
    _userSub = user
        .snapshots(includeMetadataChanges: true)
        .listen(
          (snapshot) {
            if (_uid != uid) return;
            if (!snapshot.exists && snapshot.metadata.isFromCache) return;
            _loadTimeout?.cancel();
            _data = PracticeData.fromMap(snapshot.data());
            if (!snapshot.metadata.hasPendingWrites) {
              _confirmedData = _data;
              _error = null;
            }
            _isLoaded = true;
            notifyListeners();
            if (!snapshot.exists && !_creatingUser) {
              _creatingUser = true;
              user
                  .set({
                    'email': _auth.email,
                    'createdAt': FieldValue.serverTimestamp(),
                  }, SetOptions(merge: true))
                  .catchError((Object error) {
                    if (_uid != uid) return;
                    _error = 'Could not create your practice profile: $error';
                    notifyListeners();
                  });
            }
          },
          onError: (Object error) {
            if (_uid != uid) return;
            _loadTimeout?.cancel();
            _error = 'Could not load your practice settings: $error';
            _isLoaded = true;
            notifyListeners();
          },
        );
    _sessionsSub = user
        .collection('sessions')
        .orderBy('at', descending: true)
        .snapshots()
        .listen(
          (snapshot) {
            if (_uid != uid) return;
            _sessions = snapshot.docs
                .map((doc) => PracticeSession.fromMap(doc.data()))
                .toList();
            notifyListeners();
          },
          onError: (Object error) {
            if (_uid != uid) return;
            _error = 'Could not load your sessions: $error';
            notifyListeners();
          },
        );
  }

  @override
  Future<void> save(Map<String, dynamic> fields) async {
    final uid = _uid;
    if (uid == null) throw StateError('Sign in to save your practice.');
    _data = PracticeData.fromMap({..._data.toMap(), ...fields});
    notifyListeners();
    try {
      await _firestore.collection('users').doc(uid).set({
        ...fields,
        'email': _auth.email,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      if (_uid == uid) {
        _confirmedData = PracticeData.fromMap({
          ..._confirmedData.toMap(),
          ...fields,
        });
        notifyListeners();
      }
    } catch (error) {
      if (_uid == uid) {
        final current = _data.toMap();
        final confirmed = _confirmedData.toMap();
        for (final entry in fields.entries) {
          final value = current[entry.key];
          final stillPending = value is List && entry.value is List
              ? listEquals(value, entry.value as List)
              : value == entry.value;
          if (stillPending) {
            current[entry.key] = confirmed[entry.key];
          }
        }
        _data = PracticeData.fromMap(current);
        _error = 'Could not save your changes: $error';
        notifyListeners();
      }
      rethrow;
    }
  }

  @override
  Future<void> logSession(String piece, String focus) async {
    final uid = _uid;
    if (uid == null) throw StateError('Sign in to save your session.');
    try {
      await _firestore.collection('users').doc(uid).collection('sessions').add({
        'piece': piece,
        'focus': focus,
        'at': FieldValue.serverTimestamp(),
      });
    } catch (error) {
      if (_uid == uid) {
        _error = 'Could not save your session: $error';
        notifyListeners();
      }
      rethrow;
    }
  }

  @override
  void dispose() {
    _auth.removeListener(_onAuthChanged);
    _userSub?.cancel();
    _sessionsSub?.cancel();
    _loadTimeout?.cancel();
    super.dispose();
  }
}

/// Keeps widget tests independent from Firebase while exercising the same UI.
class MemoryPracticeStore extends PracticeStore {
  PracticeData _data = const PracticeData();
  final List<PracticeSession> _sessions = [];

  @override
  PracticeData get data => _data;

  @override
  List<PracticeSession> get sessions => List.unmodifiable(_sessions);

  @override
  String? get error => null;

  @override
  bool get isLoaded => true;

  @override
  Future<void> save(Map<String, dynamic> fields) async {
    _data = PracticeData.fromMap({..._data.toMap(), ...fields});
    notifyListeners();
  }

  @override
  Future<void> logSession(String piece, String focus) async {
    _sessions.insert(
      0,
      PracticeSession(piece: piece, focus: focus, at: DateTime.now()),
    );
    notifyListeners();
  }
}
