import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'db.dart';
import 'models.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User?>.value(
          value: FirebaseAuth.instance.authStateChanges(),
          initialData: null,
        )
      ],
      child: MaterialApp(
        // theme: ThemeData(brightness: Brightness.dark),
        home: Scaffold(
          body: Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.deepOrange, Colors.orange],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
            ),
            child: Center(
              child: HeroScreen(),
            ),
          ),
        ),
      ),
    );
  }
}

class HeroScreen extends StatelessWidget {
  HeroScreen({super.key});
  
  final auth = FirebaseAuth.instance;
  final db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User?>(context);
    bool loggedIn = user != null;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        if (loggedIn) ...[
          SizedBox(
            width: 150,
            child: Image.asset('assets/dog.png'),
          ),

          StreamProvider<List<Weapon>>.value(
            value: db.streamWeapons(user),
            initialData: const [],
            child: const WeaponsList(),
          ),

          StreamBuilder<SuperHero>(
            stream: db.streamHero(user.uid),
            builder: (context, snapshot) {
              var hero = snapshot.data;

              if (hero != null) {
                return Column(
                  children: <Widget>[
                    Text('Equip ${hero.name}',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.displayMedium),
                    ButtonBar(
                      alignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                          child: const Text('Add Knife'),
                          onPressed: () => db.addWeapon(user,
                              {'name': 'knife', 'hitpoints': 20, 'img': '🗡️'}),
                        ),
                        ElevatedButton(
                          child: const Text('Add Gun'),
                          onPressed: () => db.addWeapon(user,
                              {'name': 'gun', 'hitpoints': 75, 'img': '🔫'}),
                        ),
                        ElevatedButton(
                          child: const Text('Add Veggie'),
                          onPressed: () => db.addWeapon(user, {
                            'name': 'cucumber',
                            'hitpoints': 5,
                            'img': '🥒'
                          }),
                        )
                      ],
                    ),
                  ],
                );
              } else {
                return ElevatedButton(
                    child: const Text('Create'),
                    onPressed: () => db.createHero(user));
              }
            },
          ),

          // RaisedButton(child: Text('Sign out'), onPressed: auth.signOut),
        ],
        if (!loggedIn) ...[
          ElevatedButton(
            onPressed: FirebaseAuth.instance.signInAnonymously,
            child: const Text('Login'),
          )
        ]
      ],
    );
  }
}

class WeaponsList extends StatelessWidget {
  const WeaponsList({super.key});

  @override
  Widget build(BuildContext context) {
    var weapons = Provider.of<List<Weapon>>(context);
    var user = Provider.of<User>(context);

    return SizedBox(
      height: 300,
      child: ListView(
        children: weapons.map((weapon) {
          return Card(
            child: ListTile(
              leading: Text(weapon.img, style: const TextStyle(fontSize: 50)),
              title: Text(weapon.name),
              subtitle: Text('Deals ${weapon.hitpoints} hitpoints of damage'),
              onTap: () => DatabaseService().removeWeapon(user, weapon.id),
            ),
          );
        }).toList(),
      ),
    );
  }
}
