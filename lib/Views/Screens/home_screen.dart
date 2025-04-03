import 'package:catbreeds/Models/cat_model.dart';
import 'package:catbreeds/Services/cat_api_service.dart';
import 'package:flutter/material.dart';

import '../widgets/cat_card.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CatApiService _apiService = CatApiService();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  List<Cat> _allCats = [];
  List<Cat> _filteredCats = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.unfocus(); // Oculta el teclado automáticamente
    });
    _apiService.fetchCats();

    _apiService.catsStream.listen((cats) {
      setState(() {
        _allCats = cats;
        _searchCats(_searchController.text); // Mantiene la búsqueda activa
      });
    });
  }

  void _searchCats(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCats = _allCats;
      } else {
        _filteredCats =
            _allCats
                .where(
                  (cat) =>
                      cat.name.toLowerCase().contains(query.toLowerCase()) ||
                      cat.origin.toLowerCase().contains(query.toLowerCase()),
                )
                .toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _apiService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _searchFocusNode.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'CatBreeds',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.deepOrange.shade300,
              child: TextField(
                focusNode: _searchFocusNode,
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search race',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon:
                      _searchController.text.isNotEmpty
                          ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _searchCats('');
                            },
                          )
                          : null,
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: _searchCats,
              ),
            ),
            Expanded(
              child:
                  _allCats.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : _filteredCats.isEmpty
                      ? Center(
                        // Aquí colocamos el diseño bonito
                        child: _buildNoCatsFound(),
                      )
                      : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _filteredCats.length,
                        itemBuilder: (context, index) {
                          final cat = _filteredCats[index];
                          return CatCard(
                            cat: cat,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailScreen(cat: cat),
                                ),
                              );
                            },
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoCatsFound() {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 2),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/Images/catempty.png', // Asegúrate de incluir una imagen en assets
            height: 120,
          ),
          const SizedBox(height: 16),
          const Text(
            "We couldn't find your cat.",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.deepOrange,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Try searching for another breed or check your spelling.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              _searchController.clear();
              _searchCats('');
              FocusScope.of(context).unfocus();
            },
            icon: const Icon(Icons.refresh, color: Colors.white),
            label: const Text('Restart search'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
