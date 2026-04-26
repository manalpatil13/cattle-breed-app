import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../services/breed_info_service.dart';

class ResultScreen extends StatefulWidget {
  final String breedName;
  final Map<String, String>? breedInfo;

  const ResultScreen({
    super.key,
    required this.breedName,
    this.breedInfo,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  Map<String, String>? data;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    if (widget.breedInfo != null) {
      setState(() {
        data = widget.breedInfo;
        loading = false;
      });
    } else {
      final locale =
          Provider.of<LanguageProvider>(context, listen: false).locale;
      final result =
          await BreedInfoService().getBreedInfo(widget.breedName, locale);
      setState(() {
        data = result;
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        title: const Text("Breed Information"),
        centerTitle: true,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [

                  /// BREED NAME CARD
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.green.shade700,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "Detected Breed",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.breedName,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 26,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// FEEDING / DIET
                  _infoCard(
                    title: "Feeding / Diet",
                    content: data?['feeding'] ?? '',
                    icon: Icons.grass,
                    color: Colors.green.shade600,
                  ),

                  /// BREEDING TIPS
                  _infoCard(
                    title: "Breeding Tips",
                    content: data?['breeding'] ?? '',
                    icon: Icons.favorite,
                    color: Colors.pink.shade400,
                  ),

                  /// CARE & HEALTH
                  _infoCard(
                    title: "Care & Health",
                    content: data?['care'] ?? '',
                    icon: Icons.health_and_safety,
                    color: Colors.blue.shade500,
                  ),

                  /// MILK YIELD
                  _infoCard(
                    title: "Milk Yield",
                    content: data?['milk'] ?? '',
                    icon: Icons.water_drop,
                    color: Colors.cyan.shade600,
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            ),
    );
  }

  Widget _infoCard({
    required String title,
    required String content,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// CARD HEADER
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: color, size: 22),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),

          /// CARD CONTENT
          Padding(
            padding: const EdgeInsets.all(16),
            child: content.isEmpty
                ? Text(
                    "Information not available.",
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontStyle: FontStyle.italic,
                    ),
                  )
                : Text(
                    content,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.6,
                      color: Colors.black87,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}