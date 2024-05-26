import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'komik_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PageFavorites extends StatefulWidget {
  const PageFavorites({Key? key}) : super(key: key);

  @override
  State<PageFavorites> createState() => _PageFavoritesState();
}

class _PageFavoritesState extends State<PageFavorites> {
  bool _isDarkTheme = false;
  var appBarColor = Colors.deepPurpleAccent;
  var titleColor = Colors.black;
  var cardColor = Colors.white30;
  late Box favoritesBox;

  @override
  void initState() {
    super.initState();
    _loadTheme();
    favoritesBox = Hive.box('favorites');
  }

  Future<void> _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkTheme = prefs.getBool('isDarkTheme') ?? false;
      appBarColor = _isDarkTheme ? Colors.deepPurpleAccent : Colors.deepPurpleAccent;
      titleColor = _isDarkTheme ? Colors.white : Colors.black;
      cardColor = _isDarkTheme ? Colors.black : Colors.white30;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorite Komiks", style: TextStyle(color: titleColor),),
        backgroundColor: appBarColor,
        iconTheme: IconThemeData(color: titleColor,),
        centerTitle: true,
      ),
      body: ValueListenableBuilder(
        valueListenable: favoritesBox.listenable(),
        builder: (context, Box box, widget) {
          if (box.isEmpty) {
            return Center(
              child: Text("No favorites added yet!"),
            );
          }

          List<String> favoriteIds = box.keys.cast<String>().toList();

          return ListView.builder(
            itemCount: favoriteIds.length,
            itemBuilder: (context, index) {
              String idKomik = favoriteIds[index];
              Map<String, dynamic> komikJson = box.get(idKomik);
              Data komik = Data.fromJson(komikJson);

              return Card(
                color: cardColor,
                child: ListTile(
                  leading: komik.thumb != null
                      ? Image.network(komik.thumb!)
                      : Placeholder(),
                  title: Text(komik.title!, style: TextStyle(color: titleColor),),
                  subtitle: Text("Chapter: ${komik.totalChapter}", style: TextStyle(color: titleColor),),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _removeFavorite(idKomik);
                    },
                    color: titleColor,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _removeFavorite(String idKomik) {
    favoritesBox.delete(idKomik);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Removed from favorites!'),
    ));
  }
}
