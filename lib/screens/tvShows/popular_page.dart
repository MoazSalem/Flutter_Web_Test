import 'package:flutter/material.dart';
import 'package:netflix_web/services/tv_service.dart';
import 'package:netflix_web/data/end_points.dart';
import 'package:netflix_web/widgets/list_widget.dart';
import 'package:netflix_web/widgets/drawer.dart';

int currentPage = 1;

// This is the main page
class PopularTPage extends StatefulWidget {
  const PopularTPage({Key? key}) : super(key: key);

  @override
  State<PopularTPage> createState() => _PopularTPageState();
}

class _PopularTPageState extends State<PopularTPage> {
  late List tvShowsList;
  bool loading = true;

  getMovies({required int page}) async {
    tvShowsList = await TVService()
        .getShows(page: page, endPoint: getEndPoint(categoryIndex: 0, typeIndex: 1));
    loading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getMovies(page: currentPage);
  }

  @override
  Widget build(BuildContext context) {
    double currentWidth = MediaQuery.of(context).size.width;
    ScrollController scrollController = ScrollController();
    ThemeData theme = Theme.of(context);
    return Scaffold(
      drawer: drawerWidget(theme: theme, context: context),
      backgroundColor: theme.canvasColor,
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 70,
        title: Text(
          "Popular",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: theme.primaryColor),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Center(
                child: Text(
              "Page $currentPage",
            )),
          ),
        ],
        backgroundColor: theme.canvasColor,
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : listWidget(
              scrollController: scrollController,
              currentWidth: currentWidth,
              list: tvShowsList,
              isMovie: false),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: Size(currentWidth * 0.3, 50),
              ),
              onPressed: currentPage == 1
                  ? null
                  : () async {
                      currentPage = 1;
                      setState(() {
                        loading = true;
                      });
                      getMovies(page: 1);
                    },
              child: const Icon(Icons.home_filled),
            ),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: Size(currentWidth * 0.3, 50),
              ),
              onPressed: currentPage == 1
                  ? null
                  : () async {
                      currentPage--;
                      setState(() {
                        loading = true;
                      });
                      getMovies(page: currentPage);
                    },
              child: const Icon(Icons.arrow_back),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: theme.primaryColor,
                minimumSize: Size(currentWidth * 0.3, 50),
              ),
              onPressed: () async {
                currentPage++;
                setState(() {
                  loading = true;
                });
                setState(() {});
                getMovies(page: currentPage);
              },
              child: const Icon(Icons.arrow_forward),
            )
          ],
        ),
      ),
    );
  }
}
