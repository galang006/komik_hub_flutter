import 'package:pa_prak_mobile/chapter_image_list_model.dart';
import 'package:pa_prak_mobile/load_data_source.dart';
import 'package:flutter/material.dart';

class PageListChapterImages extends StatefulWidget {
  final String idChapter;
  const PageListChapterImages({Key? key, required this.idChapter}) : super(key: key);
  @override
  State<PageListChapterImages> createState() => _PageListChapterImagesState();
}

class _PageListChapterImagesState extends State<PageListChapterImages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Chapter Image",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF994422),
        centerTitle: true,
      ),
      body: _buildListChapterImages(),
    );
  }

  Widget _buildListChapterImages() {
    return Container(
      child: FutureBuilder(
        future: ApiDataSource.instance.loadChapterImage(widget.idChapter),
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
}
