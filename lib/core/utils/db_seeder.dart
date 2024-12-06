import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pharma_et/app/data/models/category_model.dart';
import 'package:pharma_et/app/data/models/error_model.dart';
import 'package:pharma_et/app/data/models/product_item_model.dart';
import 'package:pharma_et/app/data/models/sub_Category_model.dart';

class DBSeeder {
  final db = FirebaseFirestore.instance;

  Future<void> seedCategories() async {
    final categories = [
      CategoryModel(
        categoryId: "1",
        name: "Vitamins",
        description: "Essential vitamins for a healthy life.",
        imageUrl: {
          "url":
              "https://domf5oio6qrcr.cloudfront.net/medialibrary/11483/a4591d01-1c90-4211-a11d-ff6815bebac0.jpg",
          "publicId": "vitamins_123"
        },
        createdAt: DateTime.now(),
      ),
      CategoryModel(
        categoryId: "2",
        name: "Mother & Baby Care",
        description: "Products for mothers and babies.",
        imageUrl: {
          "url":
              "https://cdn.ready-market.com.tw/45718261/Templates/pic/category_image-mom%20and%20baby.jpg?v=bfd7e68d",
          "publicId": "mother_baby_456"
        },
        createdAt: DateTime.now(),
      ),
      CategoryModel(
        categoryId: "3",
        name: "Protein Shakes",
        description: "High-quality protein shakes for fitness enthusiasts.",
        imageUrl: {
          "url":
              "https://nypost.com/wp-content/uploads/sites/2/2023/01/powder2.jpg?quality=75&strip=all",
          "publicId": "protein_shake_789"
        },
        createdAt: DateTime.now(),
      ),
    ];

    try {
      for (var category in categories) {
        await db.collection("categories").doc(category.categoryId).set(
              category.toJson(),
            );
      }
    } catch (e) {
      ErrorModel(body: e.toString()).showError();
    }
  }

  Future<void> seedSubCategories() async {
    final subCategories = [
      SubCategoryModel(
        subCategoryId: "1-1",
        name: "Multivitamins",
        description: "All-in-one vitamin solutions.",
        categoryId: "1",
        imageUrl: {
          "url":
              "https://st3.depositphotos.com/1229718/18477/i/450/depositphotos_184771614-stock-photo-vitamins-supplements.jpg",
          "publicId": "multivitamins_001"
        },
        createdAt: DateTime.now(),
      ),
      SubCategoryModel(
        subCategoryId: "2-1",
        name: "Baby Formula",
        description: "Premium baby formula for nutrition.",
        categoryId: "2",
        imageUrl: {
          "url":
              "https://a57.foxnews.com/static.foxnews.com/foxnews.com/content/uploads/2024/04/1200/675/toddler-milk-split.jpg?ve=1&tl=1",
          "publicId": "baby_formula_002"
        },
        createdAt: DateTime.now(),
      ),
      SubCategoryModel(
        subCategoryId: "3-1",
        name: "Whey Protein",
        description: "High-quality whey protein for muscle gain.",
        categoryId: "3",
        imageUrl: {
          "url":
              "https://images-cdn.ubuy.co.id/65c580214511df38094d3742-optimum-nutrition-gold-standard-100.jpg",
          "publicId": "whey_protein_003"
        },
        createdAt: DateTime.now(),
      ),
    ];

    try {
      for (var subCategory in subCategories) {
        await db
            .collection("subCategories")
            .doc(subCategory.subCategoryId)
            .set(subCategory.toJson());
      }
    } catch (e) {
      ErrorModel(body: e.toString()).showError();
    }
  }

  Future<void> seedProducts() async {
    final products = [
      ProductItemModel(
        productId: "1-1-1",
        name: "Centrum Multivitamin",
        description: "Daily multivitamin for general health.",
        price: "20.99",
        subCategoryId: "1-1",
        imageUrl: {
          "url":
              "https://i5.walmartimages.com/asr/fb89de79-4bb2-42a6-a349-7c69943593f0.f8d054f66112378bb9053b4893096ce5.jpeg",
          "publicId": "centrum_101"
        },
        createdAt: DateTime.now(),
      ),
      ProductItemModel(
        productId: "2-1-1",
        name: "Similac Advance",
        description: "Infant formula for sensitive tummies.",
        price: "25.49",
        subCategoryId: "2-1",
        imageUrl: {
          "url":
              "https://i5.walmartimages.com/seo/Similac-Advance-Concentrated-Liquid-Baby-Formula-with-Iron-DHA-Lutein-13-fl-oz-Can_6987f016-2719-4952-9188-777eea749b50.eba3cc4f386d5af2e621bc800e10f9cf.jpeg",
          "publicId": "similac_102"
        },
        createdAt: DateTime.now(),
      ),
      ProductItemModel(
        productId: "3-1-1",
        name: "Optimum Nutrition Gold Standard Whey",
        description: "Best-selling whey protein for fitness enthusiasts.",
        price: "35.99",
        subCategoryId: "3-1",
        imageUrl: {
          "url":
              "https://fitnesstack.com/wp-content/uploads/2024/03/Optimum-Nutrition-Gold-Standard-100-Isolate-1.36-Kg.jpg",
          "publicId": "optimum_whey_103"
        },
        createdAt: DateTime.now(),
      ),
    ];

    try {
      for (var product in products) {
        await db
            .collection("products")
            .doc(product.productId)
            .set(product.toJson());
      }
    } catch (e) {
      ErrorModel(body: e.toString()).showError();
    }
  }

  Future<void> seedAll() async {
    try {
      await seedCategories();
      await seedSubCategories();
      await seedProducts();
    } catch (e) {
      ErrorModel(body: e.toString()).showError();
    }
  }
}
