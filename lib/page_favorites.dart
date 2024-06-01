import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'komik_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pa_prak_mobile/page_detail_komik.dart';
import 'package:pa_prak_mobile/ColorTheme.dart';

class PageFavorites extends StatefulWidget {
  const PageFavorites({Key? key}) : super(key: key);

  @override
  State<PageFavorites> createState() => _PageFavoritesState();
}

class _PageFavoritesState extends State<PageFavorites> {
  bool _isDarkTheme = false;
  var appBarColor = AppTheme.appBarColor;
  var titleAppBarColor = AppTheme.titleAppBarColor;
  var titleColor = AppTheme.titleColor;
  var cardColor = AppTheme.cardColor;
  var listColor = AppTheme.listColor;
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
      titleColor = _isDarkTheme ? Colors.white : Colors.black;
      cardColor = _isDarkTheme ? Color(0xFF242424) : Colors.white;
      listColor = _isDarkTheme ? Colors.black : Color(0xFFEDEFF1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Favorite Komiks",
          style: TextStyle(color: titleAppBarColor),
        ),
        backgroundColor: appBarColor,
        iconTheme: IconThemeData(
          color: titleAppBarColor,
        ),
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

          return Container(
            color: listColor,
            child: ListView.builder(
              itemCount: favoriteIds.length,
              itemBuilder: (context, index) {
                String idKomik = favoriteIds[index];
                Map<String, dynamic> komikJson = Map<String, dynamic>.from(box.get(idKomik));
                Data komik = Data.fromJson(komikJson);

                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PageDetailKomik(
                          idKomik: komik.id!,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    color: cardColor,
                    child: ListTile(
                      leading: komik.thumb != null
                          ? Image.network(komik.thumb!)
                          : Placeholder(),
                      title: Text(
                        komik.title!,
                        style: TextStyle(color: titleColor),
                      ),
                      subtitle: Text(
                        "Chapter: ${komik.totalChapter}",
                        style: TextStyle(color: titleColor),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _removeFavorite(idKomik);
                        },
                        color: titleColor,
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _removeFavorite(String idKomik) {
    favoritesBox.delete(idKomik);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Removed from favorites!'),
      backgroundColor: Colors.red,
    ));
  }
}
