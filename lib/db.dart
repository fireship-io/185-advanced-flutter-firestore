import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'models.dart';

class DatabaseService {
  final Firestore _db = Firestore.instance;

  Future<SuperHero> getHero(String id) async {
    var snap = await _db.collection('heroes').document(id).get();

    return SuperHero.fromMap(snap.data);
  }

  /// Get a stream of a single document
  Stream<SuperHero> streamHero(String id) {
    return _db
        .collection('heroes')
        .document(id)
        .snapshots()
        .map((snap) => SuperHero.fromMap(snap.data));
  }

  /// Query a subcollection
  Stream<List<Weapon>> streamWeapons(FirebaseUser user) {
    var ref = _db.collection('heroes').document(user.uid).collection('weapons');

    return ref.snapshots().map((list) =>
        list.documents.map((doc) => Weapon.fromFirestore(doc)).toList());
  }

  Future<void> createHero(FirebaseUser user) {
    return _db
        .collection('heroes')
        .document(user.uid)
        .setData({'name': 'DogMan ${user.uid.substring(0,5)}'});
  }

  Future<void> addWeapon(FirebaseUser user, dynamic weapon) {
    return _db
        .collection('heroes')
        .document(user.uid)
        .collection('weapons')
        .add(weapon);
  }

  Future<void> removeWeapon(FirebaseUser user, String id) {
    return _db
        .collection('heroes')
        .document(user.uid)
        .collection('weapons')
        .document(id)
        .delete();
  }
}
