import 'package:pa_prak_mobile/chapter_list_model.dart' as ChapterListModel;
import 'package:pa_prak_mobile/komik_model.dart' as KomikModel;
import 'package:pa_prak_mobile/load_data_source.dart';
import 'package:flutter/material.dart';
import 'package:pa_prak_mobile/page_list_chapter_images.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PageDetailKomik extends StatefulWidget {
  final String idKomik;
  const PageDetailKomik({Key? key, required this.idKomik}) : super(key: key);
  @override
  State<PageDetailKomik> createState() => _PageDetailKomikState();
}

class _PageDetailKomikState extends State<PageDetailKomik> {
  bool _isDarkTheme = false;
  var appBarColor = Colors.deepPurpleAccent;
  var titleColor = Colors.black;
  var cardColor = Colors.white30;
  late Box favoritesBox;
  KomikModel.Data? currentKomik;

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
        title: Text("Detail Komik", style: TextStyle(color: titleColor),),
        backgroundColor: appBarColor,
        iconTheme: IconThemeData(color: titleColor,),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.star),
            onPressed: _saveFavorite,
            color: titleColor,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildDetailKomik(),
            _buildListChapterKomik(),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailKomik() {
    return FutureBuilder(
      future: ApiDataSource.instance.loadKomik(widget.idKomik),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasError) {
          return _buildErrorSection();
        }
        if (snapshot.hasData) {
          KomikModel.KomikModel komikModel = KomikModel.KomikModel.fromJson(snapshot.data);
          currentKomik = komikModel.data; // Inisialisasi currentKomik
          return _buildSuccessSectionKomik(komikModel);
        }
        return _buildLoadingSection();
      },
    );
  }

  Widget _buildListChapterKomik() {
    return FutureBuilder(
      future: ApiDataSource.instance.loadChapter(widget.idKomik),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasError) {
          return _buildErrorSection();
        }
        if (snapshot.hasData) {
          ChapterListModel.ChapterListModel chapterListModel = ChapterListModel.ChapterListModel.fromJson(snapshot.data);
          return _buildSuccessSectionChapter(chapterListModel);
        }
        return _buildLoadingSection();
      },
    );
  }

  Widget _buildErrorSection() {
    return Text("Error");
  }

  Widget _buildLoadingSection() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildSuccessSectionKomik(KomikModel.KomikModel data) {
    KomikModel.Data komik = data.data!;
    return InkWell(
      onTap: () {},
      child: Card(
        color: cardColor,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                child: komik.thumb != null
                    ? Image.network(komik.thumb!)
                    : Placeholder(),
              ),
              SizedBox(height: 0),
              Center(
                child: Text(
                  komik.title!,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: titleColor),
                ),
              ),
              SizedBox(height: 10),
              Text("Summary", style: TextStyle(fontWeight: FontWeight.bold, color: titleColor)),
              SizedBox(height: 5),
              Text(
                komik.summary!,
                textAlign: TextAlign.justify,
                style: TextStyle(color: titleColor),
              ),
              SizedBox(height: 5),
              Text("Author", style: TextStyle(fontWeight: FontWeight.bold, color: titleColor)),
              SizedBox(height: 5),
              Text(
                komik.authors!.join(', '),  // Gabungkan daftar authors menjadi satu string
                textAlign: TextAlign.justify,
                style: TextStyle(color: titleColor),
              ),
              SizedBox(height: 10),
              Text("Status", style: TextStyle(fontWeight: FontWeight.bold, color: titleColor)),
              SizedBox(height: 5),
              Text(
                komik.status!,
                textAlign: TextAlign.justify,
                style: TextStyle(color: titleColor),
              ),
              SizedBox(height: 10),
              Text("Type", style: TextStyle(fontWeight: FontWeight.bold, color: titleColor)),
              SizedBox(height: 5),
              Text(
                komik.type!,
                textAlign: TextAlign.justify,
                style: TextStyle(color: titleColor),
              ),
              SizedBox(height: 10),
              Text("Posted On", style: TextStyle(fontWeight: FontWeight.bold, color: titleColor)),
              SizedBox(height: 5),
              Text(
                komik.createAt!.toString(),
                textAlign: TextAlign.justify,
                style: TextStyle(color: titleColor),
              ),
              SizedBox(height: 10),
              Text("Updated On", style: TextStyle(fontWeight: FontWeight.bold, color: titleColor)),
              SizedBox(height: 5),
              Text(
                komik.updateAt!.toString(),
                textAlign: TextAlign.justify,
                style: TextStyle(color: titleColor),
              ),
              SizedBox(height: 10),
              Text("Genres", style: TextStyle(fontWeight: FontWeight.bold, color: titleColor)),
              SizedBox(height: 5),
              Text(
                komik.genres!.join(', '),  // Gabungkan daftar genres menjadi satu string
                textAlign: TextAlign.justify,
                style: TextStyle(color: titleColor),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildSuccessSectionChapter(ChapterListModel.ChapterListModel data) {
    return Container(
      height: 400, // Menetapkan tinggi untuk daftar agar dapat digulir
      child: ListView.builder(
        itemCount: data.data!.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildItemChapterKomik(index, data.data![index], data.data!);
        },
      ),
    );
  }

  Widget _buildItemChapterKomik(int index,ChapterListModel.Data chapter, List<ChapterListModel.Data> chapList) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PageListChapterImages(
              idChapter: chapter.id!,
              chapterList: chapList,
              index: index,
            ),
          ),
        );
      },
      child: Card(
        color: cardColor,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            chapter.title!,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: titleColor),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  void _saveFavorite() {
    if (currentKomik != null) {
      if (!favoritesBox.containsKey(currentKomik!.id)) {
        favoritesBox.put(currentKomik!.id, currentKomik!.toJson());
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Added to favorites!'),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Already in favorites!'),
        ));
      }
    }
  }
}
