import 'package:pa_prak_mobile/latest_komik_model.dart';
import 'package:pa_prak_mobile/load_data_source.dart';
import 'package:flutter/material.dart';

class PageListLatestKomik extends StatefulWidget {
  const PageListLatestKomik({Key? key}) : super(key: key);
  @override
  State<PageListLatestKomik> createState() => _PageListLatestKomikState();
}

class _PageListLatestKomikState extends State<PageListLatestKomik> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Meal Categories",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF994422),
        centerTitle: true,
      ),
      body: _buildListCategoryBody(),
    );
  }

  Widget _buildListCategoryBody() {
    return Container(
      child: FutureBuilder(
        future: ApiDataSource.instance.loadLatestKomik(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            // Jika data ada error maka akan ditampilkan hasil error
            return _buildErrorSection();
          }
          if (snapshot.hasData) {
            // Jika data ada dan berhasil maka akan ditampilkan hasil datanya
            LatestKomikModel latestKomikModel = LatestKomikModel.fromJson(snapshot.data);
            return _buildSuccessSection(latestKomikModel);
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

  Widget _buildSuccessSection(LatestKomikModel data) {
    return ListView.builder(
      itemCount: data.data!.length ?? 0,
      itemBuilder: (BuildContext context, int index) {
        return _buildItemCategory(data.data![index]);
      },
    );
  }

  Widget _buildItemCategory(Data latestKomik) {
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
                  child: latestKomik.thumb != null
                      ? Image.network(latestKomik.thumb!)
                      : Placeholder(),
                ),
                SizedBox(
                  height: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(latestKomik.title! ?? 'No Title', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10), // Tambahkan jarak horizontal di sini
                      child: Text(
                        latestKomik.summary!  ?? 'No Summary',
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
}
