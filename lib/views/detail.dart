import 'package:flutter/material.dart';
import 'package:kuis_mobile_124240107/views/home.dart';
import 'package:kuis_mobile_124240107/models/data.dart';

class DetailPage extends StatefulWidget {
  final Product product;

  const DetailPage({super.key, required this.product});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  // Mengecek apakah produk ini sedang disukai berdasarkan Set di home.dart
  bool get isLiked => likedProductIds.contains(widget.product.id);

  void toggleLike() {
    setState(() {
      if (isLiked) {
        likedProductIds.remove(widget.product.id);
        widget.product.likeCount--;
      } else {
        likedProductIds.add(widget.product.id);
        widget.product.likeCount++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.productName),
        actions: [
          IconButton(
            tooltip: isLiked ? "Batal Suka" : "Sukai",
            icon: Icon(
              isLiked ? Icons.favorite : Icons.favorite_border,
              color: isLiked ? Colors.red : null,
            ),
            onPressed: toggleLike,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                widget.product.imageUrl,
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 220,
                  width: double.infinity,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.broken_image, size: 50),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.product.productName,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.product.type,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              widget.product.price,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 12),
            // Info Stok & Suka (Real-time tersimpan)
            Row(
              children: [
                const Icon(Icons.inventory_2_outlined, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  "Stok: ${widget.product.stock}",
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.favorite,
                  size: 16,
                  color: isLiked ? Colors.red : Colors.grey,
                ),
                const SizedBox(width: 4),
                Text(
                  "${widget.product.likeCount} Suka",
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Pilihan Ukuran
            const Text(
              "Pilihan Ukuran",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: widget.product.sizes.map((size) {
                return Chip(
                  label: Text(size),
                  backgroundColor: Colors.deepPurple.shade50,
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            const Text(
              "Deskripsi",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.product.details,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
