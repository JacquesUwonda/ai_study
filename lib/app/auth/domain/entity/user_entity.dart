import 'package:firebase_auth/firebase_auth.dart';

class UserEntity {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoURL;

  UserEntity({required this.uid, this.email, this.displayName, this.photoURL});

  factory UserEntity.fromFirebaseUser(User? user) {
    return UserEntity(
      uid: user?.uid ?? '',
      email: user?.email,
      displayName: user?.displayName,
      photoURL: user?.photoURL,
    );
  }
}
