import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:uni_help/core/di/service_locator.dart';
import 'package:uni_help/core/services/presence_service.dart';

class PresenceLifecycleObserver extends StatefulWidget {
  const PresenceLifecycleObserver({required this.child, super.key});

  final Widget child;

  @override
  State<PresenceLifecycleObserver> createState() => _PresenceLifecycleObserverState();
}

class _PresenceLifecycleObserverState extends State<PresenceLifecycleObserver> with WidgetsBindingObserver {
  final PresenceService _presenceService = serviceLocator<PresenceService>();
  StreamSubscription<User?>? _authSubscription;

  User? get _activeUser {
    final user = FirebaseAuth.instance.currentUser;
    return (user != null && user.emailVerified) ? user : null;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null && user.emailVerified) {
        _presenceService.goOnline(user.uid);
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final user = _activeUser;
    if (user == null) return;

    if (state == AppLifecycleState.resumed) {
      _presenceService.goOnline(user.uid);
    } else if (state == AppLifecycleState.paused) {
      _presenceService.goOffline(user.uid);
    }
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}