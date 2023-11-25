import 'dart:io';

import 'package:flutter/material.dart';
import 'package:order_picker/domain/entities/product.dart';

class ProductDetails extends StatelessWidget {
  const ProductDetails({super.key, this.product});

  final Product? product;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Product #${product?.id}')),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Column(
              children: [
                Text(
                  product!.name,
                  style: Theme.of(context).textTheme.headlineLarge?.merge(
                        const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  'Stock: ${product?.amount.toString() ?? "0"}',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Text(
                  'Price: \$${product!.price.toString()}',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 20),
                ImageContainer(imageUrl: product?.imageUrl),
              ],
            ),
          )),
    );
  }
}

class ImageContainer extends StatelessWidget {
  const ImageContainer({
    super.key,
    required this.imageUrl,
  });

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Colors.grey.shade700,
        ),
        borderRadius: BorderRadius.circular(21),
      ),
      child: imageUrl != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) =>
                    loadingProgress == null
                        ? child
                        : const Padding(
                            padding: EdgeInsets.all(28.0),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
              ))
          : Container(
              color: Colors.transparent,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 120),
              child: const Column(
                children: [
                  Text(
                    "No image",
                    textScaleFactor: 2,
                    style: TextStyle(
                      color: Color.fromRGBO(85, 85, 85, 0.5),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
