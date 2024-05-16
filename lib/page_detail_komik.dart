import 'package:pa_prak_mobile/chapter_list_model.dart' as ChapterListModel;
import 'package:pa_prak_mobile/komik_model.dart' as KomikModel;
import 'package:pa_prak_mobile/load_data_source.dart';
import 'package:flutter/material.dart';
import 'package:pa_prak_mobile/page_list_chapter_images.dart';

class PageDetailKomik extends StatefulWidget {
  final String idKomik;
  const PageDetailKomik({Key? key, required this.idKomik}) : super(key: key);
  @override
  State<PageDetailKomik> createState() => _PageDetailKomikState();
}

class _PageDetailKomikState extends State<PageDetailKomik> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Detail Komik",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF994422),
        centerTitle: true,
      ),
      // body: _buildDetailKomik(),
      body: Column(
        children: [
          Expanded(
              child: FractionallySizedBox(
                child: _buildDetailKomik(),
              )
          ),
          Expanded(
              child: FractionallySizedBox(
                child: _buildListChapterKomik(),
              )
          ),
        ],
      ),
    );
  }

  Widget _buildDetailKomik() {
    return Container(
      child: FutureBuilder(
        future: ApiDataSource.instance.loadKomik(widget.idKomik),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            // Jika data ada error maka akan ditampilkan hasil error
            return _buildErrorSection();
          }
          if (snapshot.hasData) {
            // Jika data ada dan berhasil maka akan ditampilkan hasil datanya
            KomikModel.KomikModel komikModel = KomikModel.KomikModel.fromJson(snapshot.data);
            return _buildSuccessSectionKomik(komikModel);
          }
          return _buildLoadingSection();
        },
      ),
    );
  }

  Widget _buildListChapterKomik() {
    return Container(
      child: FutureBuilder(
        future: ApiDataSource.instance.loadChapter(widget.idKomik),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            // Jika data ada error maka akan ditampilkan hasil error
            return _buildErrorSection();
          }
          if (snapshot.hasData) {
            // Jika data ada dan berhasil maka akan ditampilkan hasil datanya
            ChapterListModel.ChapterListModel chapterListModel = ChapterListModel.ChapterListModel.fromJson(snapshot.data);
            return _buildSuccessSectionChapter(chapterListModel);
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

  Widget _buildSuccessSectionKomik(KomikModel.KomikModel data) {
    KomikModel.Data komik = data.data!;
    return InkWell(
      onTap: () {
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => PageListMeals(
        //           category: category.strCategory!,
        //         )));
      },
      child: Card(
          color: Color(0xFFF7EFF1),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 200,
                  child: komik.thumb != null
                      ? Image.network(komik.thumb!)
                      : Placeholder(),
                ),
                SizedBox(
                  height: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(komik.title!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10), // Tambahkan jarak horizontal di sini
                      child: Text(
                        komik.summary!,
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )

      ),
    );
  }

  Widget _buildSuccessSectionChapter(ChapterListModel.ChapterListModel data) {
    return ListView.builder(
      itemCount: data.data!.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildItemChapterKomik(data.data![index]);
      },
    );
  }

  Widget _buildItemChapterKomik(ChapterListModel.Data chapter) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PageListChapterImages(
                  idChapter: chapter.id!,
                )));
      },
      child: Card(
          color: Color(0xFFF7EFF1),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(chapter.title!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                  ],
                ),
              ],
            ),
          )

      ),
    );
  }
}
