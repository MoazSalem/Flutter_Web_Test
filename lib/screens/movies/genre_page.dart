import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:netflix_web/bloc/nex_bloc.dart';
import 'package:netflix_web/widgets/list_widget.dart';
import 'package:netflix_web/widgets/drawer.dart';
import 'package:netflix_web/data/categories.dart';

late double currentWidth;
late ThemeData theme;
late NexBloc B;

// This is the main page
class MoviesGenrePage extends StatefulWidget {
  final String? page;
  final String? genre;

  const MoviesGenrePage({Key? key, required this.genre, required this.page}) : super(key: key);

  @override
  State<MoviesGenrePage> createState() => _MoviesGenrePageState();
}

class _MoviesGenrePageState extends State<MoviesGenrePage> {
  final ScrollController scrollController = ScrollController();
  final TextEditingController searchC = TextEditingController();
  bool loading = false;
  bool search = false;
  int currentPage = 1;
  int loadedPage = 0;

  @override
  void initState() {
    super.initState();
    B = NexBloc.get(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    currentWidth = MediaQuery.of(context).size.width;
    theme = Theme.of(context);
  }

  changePage() {
    loadedPage != currentPage
        ? {
            loadedPage = int.parse(widget.page!),
            B.genreList = [],
            B.getMoviesGenre(page: currentPage, genre: moviesCategories[widget.genre!]!),
          }
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NexBloc, NexState>(
      listener: (context, state) {},
      builder: (context, state) {
        currentPage = int.parse(widget.page!);
        changePage();
        return Scaffold(
          drawer: drawerWidget(theme: theme, context: context),
          backgroundColor: theme.canvasColor,
          appBar: AppBar(
            centerTitle: true,
            toolbarHeight: 70,
            title: Text(
              widget.genre!,
              style:
                  TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: theme.primaryColor),
            ),
            backgroundColor: theme.canvasColor,
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                    onPressed: () {
                      setState(() {
                        search = !search;
                      });
                    },
                    icon: Icon(
                      Icons.search,
                      color: search ? theme.primaryColor : Colors.white,
                    )),
              )
            ],
          ),
          body: B.genreList.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView(
                  physics: const BouncingScrollPhysics(),
                  cacheExtent: 3500,
                  children: [
                    search
                        ? Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: currentWidth * 0.031),
                              child: TextFormField(
                                  controller: searchC,
                                  onChanged: (query) {
                                    B.searchMovies(query: query);
                                  },
                                  autofocus: true,
                                  maxLines: 1,
                                  decoration: InputDecoration(
                                    contentPadding:
                                        const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey.shade300),
                                        borderRadius: BorderRadius.circular(0)),
                                    hintText: "Search",
                                    filled: true,
                                    fillColor: Theme.of(context).cardColor,
                                    border:
                                        OutlineInputBorder(borderRadius: BorderRadius.circular(0)),
                                  )),
                            ),
                          )
                        : Container(),
                    listWidget(
                        currentWidth: currentWidth,
                        list: B.genreList,
                        isMovie: true,
                        scrollController: scrollController,
                        page: search ? 0 : currentPage),
                    search
                        ? Container()
                        : Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 15.0),
                                child: Center(
                                    child: Text(
                                  "Page $currentPage",
                                )),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8.0, top: 8.0, bottom: 16.0),
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
                                          : () {
                                              currentPage = 1;
                                              context.go("/movies/categories/${widget.genre}/${1}");
                                            },
                                      child: const Icon(Icons.home_filled),
                                    ),
                                    OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        minimumSize: Size(currentWidth * 0.3, 50),
                                      ),
                                      onPressed: currentPage == 1
                                          ? null
                                          : () {
                                              currentPage--;
                                              context.go(
                                                  "/movies/categories/${widget.genre}/$currentPage");
                                            },
                                      child: const Icon(Icons.arrow_back),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: theme.primaryColor,
                                        minimumSize: Size(currentWidth * 0.3, 50),
                                      ),
                                      onPressed: () {
                                        currentPage++;
                                        context
                                            .go("/movies/categories/${widget.genre}/$currentPage");
                                      },
                                      child: const Icon(Icons.arrow_forward),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
        );
      },
    );
  }
}
