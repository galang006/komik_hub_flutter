import 'package:pa_prak_mobile/chapter_image_list_model.dart';
import 'package:pa_prak_mobile/chapter_list_model.dart' as ChapList;
import 'package:pa_prak_mobile/load_data_source.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PageListChapterImages extends StatefulWidget {
  final String idChapter;
  final int index;
  final List<ChapList.Data> chapterList;
  const PageListChapterImages({Key? key, required this.index, required this.idChapter, required this.chapterList}) : super(key: key);
  @override
  State<PageListChapterImages> createState() => _PageListChapterImagesState();
}

class _PageListChapterImagesState extends State<PageListChapterImages> {
  late var index;
  late var chapList;
  late var totalChapter;
  late var currentChapId;
  bool _isLoading = false;
  bool _isDarkTheme = false;
  var appBarColor = Colors.deepPurpleAccent;
  var titleColor = Colors.black;

  @override
  void initState() {
    super.initState();
    // Inisialisasi variabel a ketika widget diinisialisasi
    _loadTheme();
    chapList = widget.chapterList;
    index = widget.index;
    totalChapter = widget.chapterList.length;
    currentChapId = widget.idChapter;
  }

  Future<void> _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkTheme = prefs.getBool('isDarkTheme') ?? false;
      appBarColor = _isDarkTheme ? Colors.deepPurpleAccent : Colors.deepPurpleAccent;
      titleColor = _isDarkTheme ? Colors.white : Colors.black;
    });
  }

  void _loadNextChapter() {
    index = index+1;
    currentChapId = chapList[index].id;
  }
  void _loadPreviousChapter() {
    index = index-1;
    currentChapId = chapList[index].id;
  }

  @override
  Widget build(BuildContext context) {
    int noChap = index + 1;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          chapList[index].title + noChap.toString(),
          style: TextStyle(color: titleColor),
        ),
        backgroundColor: appBarColor,
        iconTheme: IconThemeData(color: titleColor,),
        centerTitle: true,
      ),
      body: _isLoading ? _buildLoadingSection() : _buildListChapterImages(),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (index > 0 && index < totalChapter) // Prev
            FloatingActionButton(
              onPressed: () {
                setState(() {
                  _loadPreviousChapter();
                });
                _loadChapter();
              },
              child: Icon(Icons.arrow_back, color: titleColor,),
              backgroundColor: appBarColor,
            ),
          SizedBox(
              width:
              20),
          if (index >= 0 && index < totalChapter-1)
            FloatingActionButton(
              onPressed: () {
                setState(() {
                  _loadNextChapter();
                });
                _loadChapter();
              },
              child: Icon(Icons.arrow_forward, color: titleColor,),
              backgroundColor: appBarColor,
            ),
        ],
      ),
    );
  }

  Widget _buildListChapterImages() {
    return Container(
      child: FutureBuilder(
        future: ApiDataSource.instance.loadChapterImage(currentChapId),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            // Jika data ada error maka akan ditampilkan hasil error
            return _buildErrorSection();
          }
          if (snapshot.hasData) {
            // Jika data ada dan berhasil maka akan ditampilkan hasil datanya
            ChapterImageListModel chapterImageListModel = ChapterImageListModel.fromJson(snapshot.data);
            return _buildSuccessSection(chapterImageListModel);
          }
          return _buildLoadingSection();
        },
      ),
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

  Widget _buildSuccessSection(ChapterImageListModel data) {
    return ListView.builder(
      itemCount: data.data!.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildItemLatestKomik(data.data![index]);
      },
    );
  }

  Widget _buildItemLatestKomik(Data image) {
    return Container(
      child: Card(
        color: Color(0xFFF7EFF1),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                child: image.link != null
                    ? Image.network(
                  image.link!,
                  fit: BoxFit.cover, // Menyesuaikan gambar dengan container
                )
                    : Placeholder(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _loadChapter() async {
    setState(() {
      _isLoading = true;
    });

    await ApiDataSource.instance.loadChapterImage(currentChapId);

    setState(() {
      _isLoading = false;
    });
  }
}