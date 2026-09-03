import pandas as pd
from pathlib import Path
from rapidfuzz import fuzz
import mysql.connector
from sqlalchemy import create_engine


# Loading data and just looking
data_folder = Path("..")/"Data"

csv_files = list(data_folder.glob("*.csv"))
print(f"There are {len(csv_files)} data files")

df_dict = {}
for i in csv_files:
    df_dict[i.stem] = pd.read_csv(i)
    df = pd.read_csv(i)
    print(f"\n--{i.name}--")
    print(f"\n{df.shape}")
    print(f"\n{df.columns.tolist()}")
    print(f"\n{df.describe()}")
    print(f"\n{df.info()}")

## See notes for a bit more on basics of the dataset, columns etc.
## The intention is to clean/ transform the data here and load it
## into sql for analysis.

# Data Cleaning

print(df_dict.keys())
# Duplicates
for name, df in df_dict.items():
    duplicate_values = df.duplicated().sum()
    #duplicate_values = duplicate_values[duplicate_values>0]#.sort_values(ascending = False)

    #duplicate_summary[name] = duplicated_values
    print(f"-- {name} --")
    print(duplicate_values)

## There are only duplicates in the olist_geolocation_dataset
## Were not using the table so were not going to bother cleaning that


## Data types
for name, df in df.items():
    df.info()

##Mostly datetime columns to fix, 
##The rest are fine

date_columns = {
    "olist_orders_dataset": [
        "order_purchase_timestamp",
        "order_approved_at",
        "order_delivered_carrier_date",
        "order_delivered_customer_date",
        "order_estimated_delivery_date"
    ],
    "olist_order_reviews_dataset": [
        "review_creation_date",
        "review_answer_timestamp"
    ],
    "olist_order_items_dataset":[
        "shipping_limit_date"
    ]
}

for table, columns in date_columns.items():
    for col in columns:
        df_dict[table][col] = pd.to_datetime(df_dict[table][col], errors = "coerce")



# Nulls

## Check for Nulls
for name, df in df_dict.items():
    nulls = df.isna().sum()

    nulls = nulls[nulls>0].sort_values(ascending=False)
    print(f"\n-- {name} --")
    print(nulls)

## Impute nulls
df = "olist_order_reviews_dataset"

review_columns = {
    "review_comment_title": "No title",
    "review_comment_message": "No message"
}

new_dict = df_dict.copy()

for column, impute in review_columns.items():
    df_dict[df][column] = df_dict[df][column].fillna(impute)

    print(f"{new_dict[df][column].isna().sum()}\n")
    print(column)
    print(f"\n{df_dict[df][column].value_counts}\n")

## Describe helped us look at the numerical columns to be sure
## There are no outliers to flag.



### Logical errors like wrong spelling
## For the scope of this analysis We mainly look at 
# payment type and order status

df_dict["olist_order_payments_dataset"]["payment_type"].value_counts()
df_dict["olist_orders_dataset"]["order_status"].value_counts()

# both are fine.



### Loading into mysql

table_names_short = ["customers","geolocation","orders", "order_items","payments","reviews","products","sellers","category_name"]

## Create connection
conn = mysql.connector.connect(
    host="localhost",
    user="root",
    password="Gre567*90#"
)


## Create a database
cursor = conn.cursor()

cursor.execute("CREATE DATABASE IF NOT EXISTS olist")

cursor.close()
conn.close()




engine = create_engine(
    "mysql+mysqlconnector://root:Gre567*90#@localhost/olist"
)


counter = 0
for table_name, df in df_dict.items():
    df.to_sql(
        table_names_short[counter],
        engine,
        if_exists="replace",
        index=False,
        chunksize=5000
        )
    counter += 1
    
## Test connection
query = """
SELECT *
FROM olist_orders_dataset
LIMIT 10;
"""

result = pd.read_sql(query, engine)

print(result)

#print(fuzz.ratio("hello", "hallo"))





#f_list = []
#for i in csv_files:
    #current_csv = i.name.strip(".csv")
    #current.read_csv(i)
    #df_list.append(i.name.strip(".csv"))
#print(df_list)
    #print(i.name)# = pd.read_csv(i)
    #print(i.name)
    #print(pd.read_csv(i).info())
#str(df_list[0]) = pd.read_csv()"""