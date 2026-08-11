from simulator.utils.database import DatabaseManager

db = DatabaseManager()

db.connect()

rows = db.execute_query(
    "SELECT TOP 5 CustomerID, FirstName FROM core.Customers"
)

for row in rows:

    print(row)

db.disconnect()