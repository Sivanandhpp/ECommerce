// Core imports (absolute)
import 'package:cartify/app/core/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Local widget imports (relative)
import '../../product_sheet/product_sheet.dart';

/// The main widget that includes the title and the horizontal list.
class HotDealsSection extends StatelessWidget {
  const HotDealsSection({super.key});

  @override
  Widget build(BuildContext context) {
    // A list of mock data to populate the cards.
    final List<Map<String, dynamic>> mockProducts = [
      {
        'id': 'onion_01',
        'imageUrl': AppImages.product1,
        'name': 'Onion (Savala)',
        'weight': '1 kg',
        'offerPercentage': 20,
        'originalPrice': 35.0,
        'discountedPrice': 32.0,
      },
      {
        'id': 'lays_01',
        'imageUrl': AppImages.product2,
        'name': "Lay's Hot & Sweet Chilli Potato Chips",
        'weight': '52 g',
        'offerPercentage': 10,
        'originalPrice': 20.0,
        'discountedPrice': 18.0,
        'rating': 4.2,
        'reviewCount': 128,
      },
      {
        'id': 'tomato_01',
        'imageUrl': AppImages.product3,
        'name': 'Tomato (Local)',
        'weight': '500 g',
        'offerPercentage': 15,
        'originalPrice': 25.0,
        'discountedPrice': 21.25,
        'rating': 4.0,
        'reviewCount': 56,
      },
    ];

    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            // Section header
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Hot deals',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      LogService.info('See All button pressed in Hot Deals');
                    },
                    child: const Row(
                      children: [
                        Text('See All', style: TextStyle(color: Colors.orange)),
                        Icon(
                          Icons.chevron_right,
                          color: Colors.orange,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Horizontal List
            SizedBox(
              height: 300,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: mockProducts.length,
                padding: const EdgeInsets.only(left: 16.0),
                itemBuilder: (BuildContext context, int index) {
                  final Map<String, dynamic> product = mockProducts[index];
                  return ProductCard(product: product);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Individual product card widget
class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product});

  final Map<String, dynamic> product;

  @override
  Widget build(BuildContext context) {
    final CartService cartService = Get.find<CartService>();
    final String productId = product['id'] as String;

    return GestureDetector(
      onTap: () {
        LogService.info('Product card tapped: ${product['name']}');
        showProductSheet();
      },
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with Add Button
            Stack(
              children: [
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                    image: DecorationImage(
                      image: AssetImage(product['imageUrl'] as String),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Obx(() {
                    final int quantity = cartService.getQuantity(productId);
                    return quantity == 0
                        ? _buildAddButton(cartService, productId)
                        : _buildQuantitySelector(
                            cartService,
                            productId,
                            quantity,
                          );
                  }),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Product Details
            const Text(
              '13 MINS',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              product['name'] as String,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 4),
            if (product['rating'] != null)
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.green, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '${product['rating']} (${product['reviewCount']})',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            const SizedBox(height: 8),

            // Pricing
            Row(
              children: [
                Text(
                  '${product['offerPercentage']}% OFF',
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                Text(
                  '₹${(product['originalPrice'] as double).toStringAsFixed(0)}',
                  style: const TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '₹${(product['discountedPrice'] as double).toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton(CartService cartService, String productId) {
    return GestureDetector(
      onTap: () async {
        LogService.info('Add button tapped for product: $productId');

        // Convert the mock product data to a Product object
        final Product productObject = Product(
          id: product['id'] as String,
          name: product['name'] as String,
          description: 'Fresh ${product['name']}', // Mock description
          price: product['originalPrice'] as double,
          discountPrice: product['discountedPrice'] as double,
          imageUrl: product['imageUrl'] as String,
          category: 'Groceries', // Mock category
          brand: 'Local', // Mock brand
          rating: (product['rating'] as double?) ?? 0.0,
          reviewCount: (product['reviewCount'] as int?) ?? 0,
          stockQuantity: 100, // Mock stock
          isInStock: true,
          isOnSale: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        // Add to cart using the cart service
        await cartService.addToCart(productObject, quantity: 1);
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: AppColors.grey,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildQuantitySelector(
    CartService cartService,
    String productId,
    int quantity,
  ) {
    return Container(
      height: 30,
      decoration: BoxDecoration(
        color: AppColors.grey,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 30),
            icon: const Icon(Icons.remove, color: Colors.white, size: 16),
            onPressed: () async {
              LogService.info('Decrement quantity for product: $productId');
              await cartService.decrementQuantity(productId);
            },
          ),
          Container(
            constraints: const BoxConstraints(minWidth: 20),
            child: Text(
              '$quantity',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 30),
            icon: const Icon(Icons.add, color: Colors.white, size: 16),
            onPressed: () async {
              LogService.info('Increment quantity for product: $productId');
              await cartService.incrementQuantity(productId);
            },
          ),
        ],
      ),
    );
  }
}
