import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import 'package:sat/logic/helpers/image_picker_helper.dart';
import 'package:sat/logic/blocs/product_bloc/product_bloc.dart';
import 'package:sat/logic/blocs/product_bloc/product_event.dart';
import 'package:sat/data/models/product_model.dart';

class AddProductPage extends StatelessWidget {
  final String storeId;
  const AddProductPage({super.key,required this.storeId});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController buyPriceController = TextEditingController();
    final TextEditingController sellPriceController = TextEditingController();
    final TextEditingController quantityController = TextEditingController();
    final TextEditingController imageUrlController = TextEditingController();
    final TextEditingController categoryController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Product"),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              final name = nameController.text.trim();
              final buyPrice = double.tryParse(buyPriceController.text);
              final sellPrice = double.tryParse(sellPriceController.text);
              final quantity = int.tryParse(quantityController.text);
              final category = nameController.text.trim();
              final imageUrl = imageUrlController.text.trim();

              if (name.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Name is required!")),
                );
                return;
              }
              if (buyPrice == null || sellPrice == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Prices must be numbers!")),
                );
                return;
              }

              final product = ProductModel(
                id: const Uuid().v4(),
                name: name,
                buyPrice: buyPrice,
                sellPrice: sellPrice,
                quantity: quantity ?? 0,
                category: category,
                imageUrl: imageUrl.isEmpty
                    ? "https://static.vecteezy.com/system/resources/previews/026/562/050/non_2x/product-glyph-icon-vector.jpg"
                    : imageUrl,
              );

              context.read<ProductBloc>().add(AddProductEvent(storeId: storeId,product: product));
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Hero(
                tag: 'product_image',
                child: GestureDetector(
                  onTap: () {
                    pickImage(imageUrlController);
                  },
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(
                      imageUrlController.text.isEmpty
                          ? "https://via.placeholder.com/150"
                          : imageUrlController.text,
                    ),
                    backgroundColor: Colors.grey.shade300,
                    child: const Icon(Icons.camera_alt, size: 32, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField("Product Name", nameController),
              const SizedBox(height: 12),
              _buildTextField("Buy Price", buyPriceController,
                  keyboardType: TextInputType.number),
              const SizedBox(height: 12),
              _buildTextField("Sell Price", sellPriceController,
                  keyboardType: TextInputType.number),
              const SizedBox(height: 12),
              _buildTextField("Quantity", quantityController,
                  keyboardType: TextInputType.number),
              const SizedBox(height: 12),
              _buildTextField("Category", categoryController),
              const SizedBox(height: 12),
              _buildTextField("Image URL", imageUrlController),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: label,
        ),
      ),
    );
  }
}
