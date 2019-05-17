
import 'package:cloud_firestore/cloud_firestore.dart';

class SuperHero {

  final String name;
  final int strength;

  SuperHero({ this.name, this.strength });

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

  Weapon({ this.id, this.name, this.hitpoints, this.img, });

  factory Weapon.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    
    return Weapon(
      id: doc.documentID,
      name: data['name'] ?? '',
      hitpoints: data['hitpoints'] ?? 0,
      img: data['img'] ?? ''
    );
  }

}