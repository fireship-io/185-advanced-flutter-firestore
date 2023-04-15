
import 'package:cloud_firestore/cloud_firestore.dart';

class SuperHero {

  final String name;
  final int strength;

  SuperHero({ required this.name, required this.strength });

  factory SuperHero.fromMap(Map data) {
    return SuperHero(
      name: data['name'] ?? '',
      strength: data['strength'] ?? 100,
    );
  }

}

class Weapon {
  final String id;
  final String name;
  final int hitpoints;
  final String img;

  Weapon({ required this.id, required this.name, required this.hitpoints, required this.img, });

  factory Weapon.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    
    return Weapon(
      id: doc.id,
      name: data['name'] ?? '',
      hitpoints: data['hitpoints'] ?? 0,
      img: data['img'] ?? ''
    );
  }

}