import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:order_picker/domain/entities/new_product.dart';
import 'package:order_picker/presentation/providers/auth_provider.dart';
import 'package:order_picker/presentation/screens/create_product_service.dart';
import 'package:order_picker/presentation/widgets/button.dart';
import 'package:order_picker/presentation/widgets/image_filed.dart';

import 'package:order_picker/presentation/widgets/rounded_text_field.dart';

class NewProductDemo extends ConsumerStatefulWidget {
  const NewProductDemo({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _NewProductDemoState();
  }
}

class _NewProductDemoState extends ConsumerState<NewProductDemo> {
  NewProduct newProduct = NewProduct();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.center,
        child: Column(children: [
          ImageField(
            onChange: (File? image) {
              newProduct.image = image;
            },
          ),
          const SizedBox(height: 10),
          RoundedTextField(
            hintText: 'Enter valid product name',
            labelText: 'name',
            onChanged: (value) {
              newProduct.name = value;
            },
          ),
          const SizedBox(height: 10),
          RoundedTextField(
            hintText: 'Enter product price',
            labelText: 'price',
            keyboardType: TextInputType.number,
            onChanged: (value) {
              if (value.isNotEmpty) {
                newProduct.price = double.parse(value);
              } else {
                newProduct.price = 0;
              }
            },
          ),
          const SizedBox(height: 10),
          RoundedTextField(
            hintText: 'Enter de product quantity',
            labelText: 'amount',
            keyboardType: TextInputType.number,
            onChanged: (value) {
              if (value.isNotEmpty) {
                newProduct.amount = int.parse(value);
              } else {
                newProduct.amount = 0;
              }
            },
          ),
          const SizedBox(height: 10),
          Button(
            child: const Text('Create Product'),
            onPressed: () async {
              if (!validNewProduct()) {
                return;
              }
              await createProduct(newProduct, ref.read(authProvider).loggedUser)
                  .whenComplete(
                () => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Succes'),
                    content: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Product created!",
                        ),
                      ],
                    ),
                    actions: <Widget>[
                      Button(
                        onPressed: () => Navigator.pop(context, 'OK'),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ]),
      ),
    );
  }

  bool validNewProduct() {
    return newProduct.name != null &&
        newProduct.name!.isNotEmpty &&
        newProduct.price != null &&
        newProduct.amount != null &&
        newProduct.image != null;
  }
}
