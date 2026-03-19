import pandas as pd
import random
import os

def generate_order_items():
    orders_path = "../output_data/orders.csv"
    products_path = "../output_data/products.csv"
    order_items_path = "../output_data/order_items.csv"

    orders = pd.read_csv(orders_path)
    products = pd.read_csv(products_path)

    price_map = dict(zip(products["product_id"], products["base_price"]))
    product_ids = products["product_id"].tolist()

    if os.path.exists(order_items_path):
        existing_items = pd.read_csv(order_items_path)

        processed_orders = existing_items["order_id"].unique()
        last_item_id = existing_items["order_item_id"].max()

    else:
        existing_items = pd.DataFrame()
        processed_orders = []
        last_item_id = 0

    new_orders = orders[~orders["order_id"].isin(processed_orders)]

    if new_orders.empty:
        print("No new orders to process")
        return

    new_items = []
    item_counter = last_item_id  

    for _, order in new_orders.iterrows():
        order_id = order["order_id"]

        num_products = min(random.randint(1, 5), len(product_ids))
        selected_products = random.sample(product_ids, num_products)

        for product_id in selected_products:
            item_counter += 1

            product_price = price_map[product_id] 
            quantity = random.randint(1, 3)

            new_items.append({
                "order_item_id": item_counter,
                "order_id": order_id,
                "product_id": product_id,
                "quantity": quantity,
                "price": product_price
            })

    new_items_df = pd.DataFrame(new_items)

    final_items = pd.concat([existing_items, new_items_df], ignore_index=True)

    os.makedirs(os.path.dirname(order_items_path), exist_ok=True)
    final_items.to_csv(order_items_path, index=False)

    print(f"{len(new_items_df)} new order items generated")
    print("Order items appended successfully")


def main():
    generate_order_items()


if __name__ == "__main__":
    main()