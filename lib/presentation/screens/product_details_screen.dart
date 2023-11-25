import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:order_picker/domain/entities/create_product_dto.dart';
import 'package:order_picker/domain/entities/product.dart';
import 'package:order_picker/domain/entities/user.dart';
import 'package:order_picker/infrastructure/constants/url_string.dart';
import 'package:order_picker/presentation/providers/auth_provider.dart';
import 'package:order_picker/presentation/widgets/button.dart';
import 'package:order_picker/presentation/widgets/rounded_text_field.dart';
import 'package:http/http.dart' as http;

class ProductDetails extends ConsumerWidget {
  const ProductDetails({super.key, this.product});

  final Product? product;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              const SizedBox(height: 20),
              if (ref.read(authProvider).loggedUser?.role == Role.admin ||
                  ref.read(authProvider).loggedUser?.role == Role.employee)
                Button(
                  onPressed: () {
                    chooseAmount(
                        context, product!, ref.read(authProvider).loggedUser);
                  },
                  child: const Text('Add stock'),
                ),
            ],
          ),
        ),
      ),
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

chooseAmount(BuildContext context, Product product, User? loggedUser) {
  TextEditingController amountProduct = TextEditingController();
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Choose amount"),
      content: Wrap(
        alignment: WrapAlignment.center,
        children: [
          const Text("How many items of"),
          Text(
            ' ${product.name}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const Text("do you want to add?"),
        ],
      ),
      actions: [
        RoundedTextField(
          controller: amountProduct,
          keyboardType: TextInputType.number,
          labelText: 'amount',
          hintText: "Enter amount of product.",
        ),
        const SizedBox(height: 10),
        Button(
          onPressed: () {
            String amountText = amountProduct.text;
            int amount = int.tryParse(amountText) ?? 0;
            if (amount <= 0) {
              const snackBar = SnackBar(
                  duration: Duration(seconds: 2),
                  content: Text(
                    'Amount incorrect, must be greater than 0',
                    style: TextStyle(fontSize: 25),
                  ));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            } else {
              print(amount);
              updateAmount(product, amount, loggedUser);
              amountProduct.clear();
              Navigator.pop(context);
            }
          },
          child: const Text(
            "OK",
          ),
        ),
      ],
    ),
  );
}

updateAmount(Product product, int amount, User? loggedUser) async {
  CreateProductDTO updatedProduct = CreateProductDTO(
      name: product.name,
      imageUrl: product.imageUrl,
      price: product.price,
      amount: product.amount + amount);

  final uri = Uri.parse('$url/products/${product.id}');
  final response = await http.put(
    uri,
    body: jsonEncode(updatedProduct),
    headers: {
      'Content-Type': 'application/json',
      "Authorization": "Bearer ${loggedUser?.jwt}",
    },
  );
  if (response.statusCode == 200) {
    print("Updated");
  } else {
    print('Failed to update product, status code: ${response.statusCode}');
  }
}
