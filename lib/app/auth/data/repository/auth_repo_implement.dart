import 'package:ai_study/app/auth/data/datasource/firebase_auth_datasource.dart';
import 'package:ai_study/app/auth/domain/entity/user_entity.dart';
import 'package:ai_study/app/auth/domain/repository/auth_repo.dart';

class AuthRepositoryImplement implements AuthRepository {
  final FirebaseAuthDatasource _datasource = FirebaseAuthDatasource();

  @override
  Future<UserEntity?> signInWithGoogle() async {
    final userCredential = await _datasource.signInWithGoogle();
    return UserEntity.fromFirebaseUser(userCredential.user);
  }

  @override
  Future<void> signOut() async {
    await _datasource.signOut();
  }
}
