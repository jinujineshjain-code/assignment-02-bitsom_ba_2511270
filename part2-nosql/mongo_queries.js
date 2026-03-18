// ============================================================
// Part 2.2 - MongoDB Operations
// Collection name: products
// ============================================================

// OP1: insertMany() — Insert all 3 documents from sample_documents.json
db.products.insertMany([
  {
    _id: "PROD_E001",
    category: "Electronics",
    name: "Sony WH-1000XM5 Headphones",
    brand: "Sony",
    price: 29999,
    stock: 45,
    specifications: {
      battery_life_hours: 30,
      connectivity: ["Bluetooth 5.2", "3.5mm jack"],
      noise_cancellation: true,
      voltage: "5V DC",
      warranty_years: 1
    },
    ratings: { average: 4.7, total_reviews: 2340 },
    tags: ["wireless", "noise-cancelling", "premium"]
  },
  {
    _id: "PROD_C001",
    category: "Clothing",
    name: "Men's Slim Fit Formal Shirt",
    brand: "Arrow",
    price: 1499,
    stock: 120,
    specifications: {
      fabric: "100% Cotton",
      sizes_available: ["S", "M", "L", "XL", "XXL"],
      colors: ["White", "Light Blue", "Grey"],
      fit_type: "Slim Fit",
      care_instructions: ["Machine wash cold", "Do not bleach", "Tumble dry low"]
    },
    ratings: { average: 4.3, total_reviews: 876 },
    tags: ["formal", "cotton", "office-wear"]
  },
  {
    _id: "PROD_G001",
    category: "Groceries",
    name: "Organic Rolled Oats",
    brand: "True Elements",
    price: 349,
    stock: 200,
    specifications: {
      weight_grams: 1000,
      expiry_date: "2025-12-31",
      nutritional_info: {
        calories_per_100g: 389,
        protein_g: 17,
        carbohydrates_g: 66,
        fat_g: 7,
        fiber_g: 11
      },
      allergens: ["Gluten"],
      organic_certified: true,
      storage: "Store in a cool, dry place"
    },
    ratings: { average: 4.5, total_reviews: 1123 },
    tags: ["organic", "breakfast", "healthy"]
  }
]);

// OP2: find() — Retrieve all Electronics products with price > 20000
db.products.find(
  { category: "Electronics", price: { $gt: 20000 } }
);

// OP3: find() — Retrieve all Groceries expiring before 2025-01-01
db.products.find(
  {
    category: "Groceries",
    "specifications.expiry_date": { $lt: "2025-01-01" }
  }
);

// OP4: updateOne() — Add a "discount_percent" field to a specific product
db.products.updateOne(
  { _id: "PROD_E001" },
  { $set: { discount_percent: 10 } }
);

// OP5: createIndex() — Create an index on the category field
// Reason: The category field is used in almost every query to filter products
// (e.g., find all Electronics, find all Groceries). Without an index, MongoDB
// performs a full collection scan on every such query. As the product catalog
// grows to thousands of documents, an index on category makes these lookups
// significantly faster by allowing MongoDB to jump directly to matching documents.
db.products.createIndex({ category: 1 });
