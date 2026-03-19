import pandas as pd
import random
from datetime import datetime
import os

def generate_products():
    output_path = "../output_data/products.csv"

    if os.path.exists(output_path):
        print("Products already exist — skipping generation")
        return

    categories = [
        "electronics",
        "clothing",
        "home_kitchen",
        "sports_outdoors",
        "beauty_personal_care",
        "books",
        "toys_games",
        "grocery",
        "health_wellness",
        "office_supplies"
    ]

    brands = [
        "Sony", "Samsung", "Nike", "Adidas", "Logitech",
        "Apple", "Philips", "Panasonic", "Dell", "HP"
    ]

    price_ranges = {
        "electronics": (100, 2000),
        "clothing": (20, 200),
        "home_kitchen": (30, 500),
        "sports_outdoors": (25, 400),
        "beauty_personal_care": (10, 120),
        "books": (8, 60),
        "toys_games": (15, 150),
        "grocery": (2, 50),
        "health_wellness": (15, 200),
        "office_supplies": (5, 120)
    }

    products = []

    for product_id in range(1, 801):
        category = random.choice(categories)
        brand = random.choice(brands)

        low, high = price_ranges[category]
        base_price = round(random.uniform(low, high), 2)

        product_name = f"{brand} {category.replace('_', ' ').title()} Item {product_id}"

        products.append({
            "product_id": product_id,
            "product_name": product_name,
            "category": category,
            "brand": brand,
            "base_price": base_price,
            "created_at": datetime.today().date(),
            "is_active": True
        })

    df = pd.DataFrame(products)

    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    df.to_csv(output_path, index=False)

    print("Products generated successfully (initial load only)")

def main():
    generate_products()

if __name__ == "__main__":
    main()