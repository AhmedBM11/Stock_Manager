import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sat/views/widgets/product_container.dart';
import 'package:sat/views/pages/page_four/add_product_page.dart';
import 'package:sat/logic/blocs/product_bloc/product_bloc.dart';
import 'package:sat/logic/blocs/product_bloc/product_event.dart';
import 'package:sat/logic/blocs/product_bloc/product_state.dart';

class ProductsPage extends StatefulWidget {
  final int accessibility;
  final String storeId;

  const ProductsPage({
    super.key,
    required this.accessibility,
    required this.storeId,
  });

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  late TextEditingController _searchController;
  String _selectedCategory = "Categories";

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    context.read<ProductBloc>().add(LoadProducts(storeId: widget.storeId));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductLoaded) {
            final products = state.products;
            final categories = state.categories;

            if (products.isEmpty || widget.accessibility == 0) {
              return const Center(
                child: Text(
                  "No products available",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              );
            }

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: "Search products...",
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onChanged: (value) {
                              context.read<ProductBloc>().add(
                              LoadProducts(
                                storeId: widget.storeId,
                                query: value,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 10),

                      PopupMenuButton<String>(
                        onSelected: (category) {
                          setState(() {
                            _selectedCategory = category;
                          });
                          context.read<ProductBloc>().add(
                              LoadProducts(
                                storeId: widget.storeId,
                                query: _searchController.text,
                                category: category,
                              ),
                          );
                        },
                        itemBuilder: (context) => ["All_Products", ...categories]
                            .map((category) => PopupMenuItem(
                          value: category,
                          child: Text(category),
                        ))
                            .toList(),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            _selectedCategory,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Products List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return ProductCard(
                        product: products[index],
                        accessibility: widget.accessibility,
                        storeId: widget.storeId,
                      );
                    },
                  ),
                ),
              ],
            );
          } else if (state is ProductError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(fontSize: 18, color: Colors.red),
              ),
            );
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: widget.accessibility > 1
          ? FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return AddProductPage(storeId: widget.storeId);
              },
            ),
          );
        },
        child: const Icon(Icons.add),
      )
          : null,
    );
  }
}

