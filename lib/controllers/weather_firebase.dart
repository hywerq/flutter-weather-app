import 'package:cloud_firestore/cloud_firestore.dart';

class StoredCities {
  static List<String> cities = [];
  static Map<String, String> favorites = {};

  static Future<void> getStoredCities() async {
    cities.clear();
    favorites.clear();

    await FirebaseFirestore.instance.collection('favorite').get().then((QuerySnapshot querySnapshot) => {
      querySnapshot.docs.forEach((doc) {
        favorites.addAll({doc['value'] : doc.id});
      })
    });

    await FirebaseFirestore.instance.collection('city').get().then((QuerySnapshot querySnapshot) => {
      querySnapshot.docs.forEach((doc) {
        cities.add(doc['value']);
      })
    });
  }

  static Future<void> addFavorite(String city) async {
    await FirebaseFirestore.instance.collection('favorite').add({'value': city})
    .then((docRef) => { favorites.addAll({city: docRef.id}) });
  }

  static Future<void> removeFavorite(String city) async {
    await FirebaseFirestore.instance.collection('favorite').doc(favorites[city]).delete();
    favorites.remove(city);
  }
}