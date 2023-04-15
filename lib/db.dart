import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'models.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<SuperHero> getHero(String id) async {
    var snap = await _db.collection('heroes').doc(id).get();

    return SuperHero.fromMap(snap.data as Map);
  }

  /// Get a stream of a single document
  Stream<SuperHero> streamHero(String id) {
    return _db
        .collection('heroes')
        .doc(id)
        .snapshots()
        .map((snap) => SuperHero.fromMap(snap.data as Map));
  }

  /// Query a subcollection
  Stream<List<Weapon>> streamWeapons(User user) {
    var ref = _db.collection('heroes').doc(user.uid).collection('weapons');

    return ref.snapshots().map((list) =>
        list.docs.map((doc) => Weapon.fromFirestore(doc)).toList());
  }

  Future<void> createHero(User user) {
    return _db
        .collection('heroes')
        .doc(user.uid)
        .set({'name': 'DogMan ${user.uid.substring(0,5)}'});
  }

  Future<void> addWeapon(User user, dynamic weapon) {
    return _db
        .collection('heroes')
        .doc(user.uid)
        .collection('weapons')
        .add(weapon);
  }

  Future<void> removeWeapon(User user, String id) {
    return _db
        .collection('heroes')
        .doc(user.uid)
        .collection('weapons')
        .doc(id)
        .delete();
  }
}
