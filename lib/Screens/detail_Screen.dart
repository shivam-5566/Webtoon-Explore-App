import 'package:flutter/material.dart';
import 'package:webtoon_explorer_app/Screens/favorite_Screen.dart';
import 'package:webtoon_explorer_app/Screens/home_Screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailScreen extends StatefulWidget {
  String webimage;
  String description;
  DetailScreen({required this.webimage, required this.description, super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  List<String> favoriteItems = [];
  int _rating = 0;

  @override
  void initState() {
    super.initState();
    loadFavorites();
    loadRating();
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      favoriteItems = prefs.getStringList('favorites') ?? [];
    });
  }

  Future<void> saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorites', favoriteItems);
  }

  // Save the rating to SharedPreferences
  Future<void> saveRating(int rating) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('rating_${widget.webimage}', rating);
  }

  // Load the rating from SharedPreferences
  Future<void> loadRating() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _rating = prefs.getInt('rating_${widget.webimage}') ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeScreen()));
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        )),
                    IconButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FavoriteScreen(
                                        favoritePhoto: favoriteItems,
                                      )));
                        },
                        icon: const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: 200,
                width: MediaQuery.of(context).size.width,
                child: Image.asset(widget.webimage),
              ),
              const SizedBox(
                height: 18,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    const Text(
                      "Rating: ",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    Row(
                        children: List.generate(5, (index) {
                      return IconButton(
                          onPressed: () {
                            setState(() {
                              _rating = index + 1;
                            });
                            saveRating(_rating);
                          },
                          icon: Icon(
                            index < _rating ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                          ));
                    })),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Description",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          favoriteItems.add(widget.webimage);
                          saveFavorites();
                          // print(favoriteItems);
                        },
                        style: const ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.indigo)),
                        child: const Text(
                          "Add to favorite",
                          style: TextStyle(color: Colors.white),
                        ))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  widget.description,
                  style: const TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
