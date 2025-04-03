import 'package:flutter/material.dart';

import '../../Models/cat_model.dart';
import '../widgets/rating_indicator.dart';

class DetailScreen extends StatelessWidget {
  final Cat cat;

  const DetailScreen({super.key, required this.cat});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          cat.name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: media.height * .4,
            child:
                cat.imageUrl != null
                    ? Hero(
                      tag: 'cat_${cat.id}',
                      child: Image.network(
                        cat.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.broken_image,
                              size: 60,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                    )
                    : Container(
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.pets,
                        size: 60,
                        color: Colors.grey,
                      ),
                    ),
          ),
          Expanded(
            child: Scrollbar(
              thumbVisibility: true,
              radius: Radius.circular(50),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        cat.description,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 24),
                      _buildInfoRow('Country of origin', cat.origin),
                      _buildInfoRow('Temperament', cat.temperament),
                      _buildInfoRow('Lifespan', cat.lifeSpan),
                      _buildInfoRow('Weight (kg)', cat.weight.metric),

                      const Divider(height: 32),

                      const Text(
                        'Characteristics',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      _buildRatingRow('Adaptability', cat.adaptability),
                      _buildRatingRow('Affectionateness', cat.affectionLevel),
                      _buildRatingRow('Kid-friendly', cat.childFriendly),
                      _buildRatingRow('Dog-friendly', cat.dogFriendly),
                      _buildRatingRow('Energy level', cat.energyLevel),
                      _buildRatingRow('Grooming requirements', cat.grooming),
                      _buildRatingRow('Health issues', cat.healthIssues),
                      _buildRatingRow('Intelligence', cat.intelligence),
                      _buildRatingRow('Shedding rate', cat.sheddingLevel),
                      _buildRatingRow('Social needs', cat.socialNeeds),
                      _buildRatingRow(
                        'Stranger-friendly',
                        cat.strangerFriendly,
                      ),
                      _buildRatingRow('Vocalization', cat.vocalisation),

                      const SizedBox(height: 24),

                      if (cat.wikipediaUrl.isNotEmpty)
                        _buildLinkRow(
                          'Wikipedia',
                          cat.wikipediaUrl,
                          Icons.public,
                        ),

                      if (cat.cfaUrl.isNotEmpty)
                        _buildLinkRow('CFA', cat.cfaUrl, Icons.pets),

                      if (cat.vetstreetUrl.isNotEmpty)
                        _buildLinkRow(
                          'VetStreet',
                          cat.vetstreetUrl,
                          Icons.local_hospital,
                        ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ) /* Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            backgroundColor: Colors.deepOrange,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                cat.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background:
                  cat.imageUrl != null
                      ? Hero(
                        tag: 'cat_${cat.id}',
                        child: Image.network(
                          cat.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              child: const Icon(
                                Icons.broken_image,
                                size: 60,
                                color: Colors.grey,
                              ),
                            );
                          },
                        ),
                      )
                      : Container(
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.pets,
                          size: 60,
                          color: Colors.grey,
                        ),
                      ),
            ),
          ),
          SliverToBoxAdapter(
            child: 
          ),
        ],
      ),
    ) */;
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.black87)),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingRow(String label, int rating) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 160,
            child: Text(label, style: const TextStyle(color: Colors.black87)),
          ),
          RatingIndicator(rating: rating),
        ],
      ),
    );
  }

  Widget _buildLinkRow(String label, String url, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.deepOrange),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              url,
              style: const TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
