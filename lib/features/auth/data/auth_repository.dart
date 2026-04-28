import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../domain/user_model.dart';

class AuthException implements Exception {
  final String message;
  AuthException(this.message);
  @override
  String toString() => message;
}

class AuthRepository {
  AuthRepository({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
    GoogleSignIn? googleSignIn,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  CollectionReference<Map<String, dynamic>> get _usersCol =>
      _firestore.collection('users');

  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapAuthError(e));
    }
  }

  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      await _ensureUserDocument(credential.user!);
      return credential;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapAuthError(e));
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw AuthException('Inicio de sesión con Google cancelado.');
      }
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential = await _auth.signInWithCredential(credential);
      await _ensureUserDocument(userCredential.user!);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapAuthError(e));
    }
  }

  Future<void> signOut() async {
    await Future.wait([
      _auth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  Future<UserModel?> getUserDocument(String uid) async {
    final doc = await _usersCol.doc(uid).get();
    if (!doc.exists) return null;
    return UserModel.fromFirestore(doc);
  }

  Stream<UserModel?> watchUserDocument(String uid) {
    return _usersCol.doc(uid).snapshots().map(
          (doc) => doc.exists ? UserModel.fromFirestore(doc) : null,
        );
  }

  Future<void> _ensureUserDocument(User firebaseUser) async {
    final docRef = _usersCol.doc(firebaseUser.uid);
    final snapshot = await docRef.get();
    if (snapshot.exists) return;
    final user = UserModel(
      uid: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      displayName: firebaseUser.displayName,
      photoUrl: firebaseUser.photoURL,
      createdAt: DateTime.now(),
    );
    await docRef.set(user.toFirestore());
  }

  Future<void> completeOnboarding({
    required String uid,
    required String username,
    required AccountType type,
    String? bio,
    String? website,
    String? category,
  }) async {
    await _usersCol.doc(uid).update({
      'username': username.trim().toLowerCase(),
      'type': type.name,
      if (bio != null) 'bio': bio.trim(),
      if (website != null && website.trim().isNotEmpty)
        'website': website.trim(),
      if (category != null && category.trim().isNotEmpty)
        'category': category.trim(),
    });
  }

  Future<bool> isUsernameAvailable(String username) async {
    final query = await _usersCol
        .where('username', isEqualTo: username.trim().toLowerCase())
        .limit(1)
        .get();
    return query.docs.isEmpty;
  }

  Future<void> updateProfile({
    required String uid,
    String? displayName,
    String? bio,
    String? photoUrl,
    String? website,
    String? category,
  }) async {
    final updates = <String, dynamic>{};
    if (displayName != null) {
      updates['displayName'] = displayName.trim().isEmpty
          ? null
          : displayName.trim();
    }
    if (bio != null) {
      updates['bio'] = bio.trim().isEmpty ? null : bio.trim();
    }
    if (photoUrl != null) {
      updates['photoUrl'] = photoUrl.trim().isEmpty ? null : photoUrl.trim();
    }
    if (website != null) {
      updates['website'] = website.trim().isEmpty ? null : website.trim();
    }
    if (category != null) {
      updates['category'] = category.trim().isEmpty ? null : category.trim();
    }
    if (updates.isEmpty) return;
    await _usersCol.doc(uid).update(updates);
  }

  String _mapAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'El correo no es válido.';
      case 'user-disabled':
        return 'Esta cuenta ha sido deshabilitada.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Correo o contraseña incorrectos.';
      case 'email-already-in-use':
        return 'Este correo ya está registrado.';
      case 'weak-password':
        return 'La contraseña debe tener al menos 6 caracteres.';
      case 'operation-not-allowed':
        return 'Este método de acceso no está habilitado.';
      case 'network-request-failed':
        return 'Error de conexión. Revisa tu internet.';
      default:
        return e.message ?? 'Error de autenticación (${e.code}).';
    }
  }
}
