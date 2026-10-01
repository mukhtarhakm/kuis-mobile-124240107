import 'package:flutter/material.dart';
import 'package:kuis_mobile_124240107/models/data.dart';
import 'package:kuis_mobile_124240107/views/detail.dart';

// Penampung ID produk yang sedang disukai (disimpan di memori selama aplikasi berjalan)
final Set<int> likedProductIds = {};

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchQuery = "";
  String selectedCategory = "Semua";
  final List<String> categories = [
    "Semua",
    "T-Shirt",
    "Jacket",
    "Pants",
    "Bag",
    "Accessories",
  ];

  @override
  Widget build(BuildContext context) {
    final filteredCatalog = catalog.where((product) {
      final matchesSearch = product.productName
          .toLowerCase()
          .contains(searchQuery.toLowerCase());
      final matchesCategory =
          selectedCategory == "Semua" || product.type == selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
            decoration: InputDecoration(
              hintText: "Cari produk...",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Row(
            children: categories.map((category) {
              final isSelected = selectedCategory == category;
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ChoiceChip(
                  label: Text(category),
                  selected: isSelected,
                  selectedColor: Colors.deepPurple.shade100,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        selectedCategory = category;
                      });
                    }
                  },
                ),
              );
            }).toList(),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredCatalog.length,
            itemBuilder: (context, index) {
              final item = filteredCatalog[index];
              final isLiked = likedProductIds.contains(item.id);

              return ListTile(
                onTap: () async {
                  // Tunggu sampai user kembali dari halaman detail, lalu refresh Home
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPage(product: item),
                    ),
                  );
                  setState(() {});
                },
                title: Text(item.productName),
                subtitle: Text("${item.price} • Stok: ${item.stock}"),
                leading: Hero(
                  tag: item.id,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      item.imageUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.image, size: 50),
                    ),
                  ),
                ),
                trailing: IconButton(
                  tooltip: isLiked ? "Batal Suka" : "Sukai",
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      if (isLiked) {
                        likedProductIds.remove(item.id);
                        item.likeCount--;
                      } else {
                        likedProductIds.add(item.id);
                        item.likeCount++;
                      }
                    });
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
