import 'package:flutter/material.dart';
import 'package:kuis_mobile_124240107/models/data.dart';
import 'package:kuis_mobile_124240107/views/detail.dart';
import 'package:kuis_mobile_124240107/views/home.dart';

// ============================================================================
// 📌 MODEL 2: TAMPILAN GRID 2 KOLOM (SEPERTI DI LAT_ANIMAL)
// File ini dibuat sebagai cadangan/alternatif tampilan.
// Untuk menggunakannya, cukup ganti `HomePage()` menjadi `HomePage2()` di root.dart!
// ============================================================================
class HomePage2 extends StatefulWidget {
  const HomePage2({super.key});

  @override
  State<HomePage2> createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
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
    // Filter pencarian dan kategori tetap aktif
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
        // --------------------------------------------------------------------
        // 1. SEARCH BAR
        // --------------------------------------------------------------------
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

        // --------------------------------------------------------------------
        // 2. FILTER KATEGORI (ChoiceChip Horizontal Scroll)
        // --------------------------------------------------------------------
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

        // --------------------------------------------------------------------
        // 3. DAFTAR PRODUK MODEL GRID 2 KOLOM (Gaya lat_animal)
        // --------------------------------------------------------------------
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 Kolom
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.70, // Perbandingan lebar:tinggi kartu
            ),
            itemCount: filteredCatalog.length,
            itemBuilder: (context, index) {
              final item = filteredCatalog[index];
              final isLiked = likedProductIds.contains(item.id);

              return InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPage(product: item),
                    ),
                  );
                  // Refresh saat kembali dari halaman detail
                  setState(() {});
                },
                child: Card(
                  color: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // BAGIAN ATAS: GAMBAR DENGAN HERO ANIMATION
                      Expanded(
                        flex: 5,
                        child: Hero(
                          tag: item.id,
                          child: Image.network(
                            item.imageUrl,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              color: Colors.grey[300],
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.broken_image,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // BAGIAN BAWAH: INFORMASI TEKS PRODUK + TOMBOL LIKE
                      Expanded(
                        flex: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Judul / Nama Produk
                              Text(
                                item.productName,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),

                              // Tipe / Kategori
                              Text(
                                item.type,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[600],
                                ),
                                maxLines: 1,
                              ),
                              const SizedBox(height: 2),

                  Text(
                    "stok : ${item.stock}",
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                              // Baris Harga Produk & Tombol Like
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    item.price,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
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
                                    borderRadius: BorderRadius.circular(12),
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Icon(
                                        isLiked
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        size: 18,
                                        color: isLiked
                                            ? Colors.red
                                            : Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),

                              // Tag Ukuran
                              Wrap(
                                spacing: 4,
                                runSpacing: 4,
                                children: item.sizes.map((size) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 5,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      border: Border.all(
                                        color: Colors.grey.shade300,
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      size,
                                      style: TextStyle(
                                        fontSize: 9,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
