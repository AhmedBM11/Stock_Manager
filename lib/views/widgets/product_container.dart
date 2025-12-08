import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../logic/blocs/product_bloc/product_bloc.dart';
import '../../logic/blocs/product_bloc/product_event.dart';
import '../../data/models/bill_item_model.dart';
import '../../data/models/product_model.dart';
import '../../logic/change_notifiers/basket_notifier.dart';

class ProductCard extends StatefulWidget {
  final ProductModel product;
  final int accessibility;
  final String storeId;

  const ProductCard({
    super.key,
    required this.product,
    required this.accessibility,
    required this.storeId,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _isFlipped = false;
  bool _isEditing = false;

  late TextEditingController nameCtrl;
  late TextEditingController buyCtrl;
  late TextEditingController sellCtrl;
  late TextEditingController qtyCtrl;
  late TextEditingController categoryCtrl;
  late TextEditingController imageUrlCtrl;


  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.product.name);
    buyCtrl = TextEditingController(text: widget.product.buyPrice.toString());
    sellCtrl = TextEditingController(text: widget.product.sellPrice.toString());
    qtyCtrl = TextEditingController(text: widget.product.quantity.toString());
    categoryCtrl = TextEditingController(text: widget.product.category.toString());
    imageUrlCtrl = TextEditingController(text: widget.product.imageUrl.toString());
  }

  void _toggleFlip() {
    setState(() {
      _isFlipped = !_isFlipped;
      if (!_isFlipped) _isEditing = false;
    });
  }

  void _toggleEdit() {
    setState(() => _isEditing = !_isEditing);
  }

  void _saveEdit() {
    final updated = {
      'name': nameCtrl.text,
      'buyPrice': double.tryParse(buyCtrl.text) ?? widget.product.buyPrice,
      'sellPrice': double.tryParse(sellCtrl.text) ?? widget.product.sellPrice,
      'quantity': int.tryParse(qtyCtrl.text) ?? widget.product.quantity,
      'category': categoryCtrl.text,
      'imageUrl':imageUrlCtrl.text,

    };
    context.read<ProductBloc>().add(
      UpdateProductEvent(
        storeId: widget.storeId,
        productId: widget.product.id,
        data: updated,
      ),
    );
    _toggleEdit();
  }

  void _deleteProduct() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: const Text("Are you sure you want to delete this product?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<ProductBloc>().add(
                DeleteProductEvent(
                  storeId: widget.storeId,
                  productId: widget.product.id,
                ),
              );
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canWrite = widget.accessibility > 1;

    return GestureDetector(
      onTap: _toggleFlip,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        transitionBuilder: (child, animation) {
          final rotate = Tween(begin: pi, end: 0.0).animate(animation);
          return AnimatedBuilder(
            animation: rotate,
            builder: (context, childWidget) {
              final isUnder = (ValueKey(_isFlipped) != childWidget?.key);

              return Transform(
                transform: Matrix4.rotationY(rotate.value)
                  ..rotateY(isUnder ? pi : 0.0),
                alignment: Alignment.center,
                child: childWidget,
              );
            },
            child: child,
          );
        },//tilt
        child: _isFlipped ? _buildBack(canWrite) : _buildFront(canWrite),
        layoutBuilder: (currentChild, previousChildren) => Stack(
          children: [if (currentChild != null) currentChild, ...previousChildren],
        ),
      ),
    );
  }

  Widget _buildFront(bool canWrite) {
    final basket = context.watch<BasketProvider>();

    //final basket = Provider.of<BasketProvider>(context);
    return Card(
      key: const ValueKey(false),
      elevation: 5,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          Text(widget.product.name, style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 10),
          CircleAvatar(
            radius: 45,
            backgroundColor: Colors.grey.shade200,
            backgroundImage: (widget.product.imageUrl != null &&
                widget.product.imageUrl!.isNotEmpty)
                ? NetworkImage(widget.product.imageUrl!)
                : NetworkImage("https://img.freepik.com/vecteurs-libre/panier-realiste_1284-6011.jpg"),
          ),
          const SizedBox(height: 10),
          if (canWrite)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    if (basket.getQuantity(widget.product.id)==0) {}
                    else {
                      context.read<BasketProvider>().removeProduct(widget.product.id);
                    }
                  },
                ),
                Consumer<BasketProvider>(
                  builder: (context, basket, child) {
                    return Text(
                      "${basket.getQuantity(widget.product.id)}",
                      style: const TextStyle(fontSize: 20),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    if (widget.product.quantity! <= basket.getQuantity(widget.product.id)) {}
                    else {
                      context.read<BasketProvider>().addProduct(
                        BillItemModel(
                          productId: widget.product.id,
                          name: widget.product.name,
                          quantity: 1,
                          price: widget.product.sellPrice??0,
                          imageUrl: widget.product.imageUrl??"https://cdn-icons-png.flaticon.com/512/962/962863.png",
                        ),
                      );
                    }
                  }
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildBack(bool canWrite) {
    return Card(
      key: const ValueKey(true),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (canWrite)
                  IconButton(
                    icon: Icon(_isEditing ? Icons.save : Icons.edit, color: Colors.blue),
                    onPressed: _isEditing ? _saveEdit : _toggleEdit,
                  ),
                if (canWrite)
                  IconButton(
                    icon: Icon(_isEditing ? Icons.cancel : Icons.delete, color: Colors.red),
                    onPressed: _isEditing ? _toggleEdit : _deleteProduct,
                  ),
              ],
            ),
            _isEditing
                ? Column(
              children: [
                TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Name")),
                TextField(controller: buyCtrl, decoration: const InputDecoration(labelText: "Buy Price")),
                TextField(controller: sellCtrl, decoration: const InputDecoration(labelText: "Sell Price")),
                TextField(controller: qtyCtrl, decoration: const InputDecoration(labelText: "Quantity")),
                TextField(controller: categoryCtrl, decoration: const InputDecoration(labelText: "Category")),
                TextField(controller: imageUrlCtrl, decoration: const InputDecoration(labelText: "imageUrl")),
              ],
            )
                : Row( spacing: 20,
                  children: [SizedBox(),CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: (widget.product.imageUrl != null &&
                        widget.product.imageUrl!.isNotEmpty)
                        ? NetworkImage(widget.product.imageUrl!)
                        : NetworkImage("https://img.freepik.com/vecteurs-libre/panier-realiste_1284-6011.jpg"),
                    ),SizedBox(),Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text("Name: ${widget.product.name}",style: TextStyle(fontWeight: FontWeight.bold),),
                      Text("Buy Price: ${widget.product.buyPrice}",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red),),
                      Text("Sell Price: ${widget.product.sellPrice}",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.green)),
                      Text("Quantity: ${widget.product.quantity}",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blueGrey)),
                      Text("Category: ${widget.product.category}",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.amber)),
                      SizedBox(height: 4,)
                    ],
                  ),
                ]
              ),
          ],
        ),
      ),
    );
  }
}
