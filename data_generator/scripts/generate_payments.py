import pandas as pd
import random
import os

def generate_payments():
    orders_path = "../output_data/orders.csv"
    order_items_path = "../output_data/order_items.csv"
    payments_path = "../output_data/payments.csv"

    orders = pd.read_csv(orders_path)
    order_items = pd.read_csv(order_items_path)

    payment_methods = [
        "credit_card",
        "paypal",
        "apple_pay",
        "google_pay",
        "bank_transfer"
    ]

    payment_statuses = [
        "success",
        "failed",
        "refunded"
    ]

    order_items["line_total"] = order_items["price"] * order_items["quantity"]
    order_totals = order_items.groupby("order_id")["line_total"].sum().to_dict()

    if os.path.exists(payments_path):
        existing_payments = pd.read_csv(payments_path)
        processed_orders = existing_payments["order_id"].unique()
        last_payment_id = existing_payments["payment_id"].max()
    else:
        existing_payments = pd.DataFrame()
        processed_orders = []
        last_payment_id = 0

    new_orders = orders[~orders["order_id"].isin(processed_orders)]

    if new_orders.empty:
        print("No new payments to generate")
        return

    payments = []
    payment_counter = last_payment_id

    for _, order in new_orders.iterrows():
        order_id = order["order_id"]

        payment_counter += 1

        order_total = order_totals.get(order_id, 0)

        payments.append({
            "payment_id": payment_counter,
            "order_id": order_id,
            "payment_method": random.choice(payment_methods),
            "amount": order_total,
            "payment_status": random.choice(payment_statuses),
            "payment_timestamp": order["order_date"]
        })

    new_payments_df = pd.DataFrame(payments)

    final_payments = pd.concat([existing_payments, new_payments_df], ignore_index=True)

    os.makedirs(os.path.dirname(payments_path), exist_ok=True)
    final_payments.to_csv(payments_path, index=False)

    print(f"{len(new_payments_df)} payments generated")
    print("Payments appended successfully")


def main():
    generate_payments()


if __name__ == "__main__":
    main()