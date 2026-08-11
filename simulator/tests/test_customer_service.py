"""
Enterprise Banking Data Platform

Customer Integration Test

Sprint:
4.4
"""

from simulator.generators.customer_generator import CustomerGenerator
from simulator.services.customer_service import CustomerService


print("=" * 60)
print("Customer Creation Integration Test")
print("=" * 60)

generator = CustomerGenerator()
service = CustomerService()

# -------------------------------------------------------
# Generate Customer
# -------------------------------------------------------

customer = generator.generate_customers(1)[0]

# -------------------------------------------------------
# Create Customer
# -------------------------------------------------------

response = service.create_customer(customer)

print(f"Customer Number : {response['CustomerNumber']}")
print(f"Customer ID     : {response['CustomerID']}")
print(f"Status Code     : {response['StatusCode']}")
print(f"Status Message  : {response['StatusMessage']}")

# -------------------------------------------------------
# Verify Customer
# -------------------------------------------------------

print("\nVerification")
print("-" * 60)

rows = service.get_customer_by_number(
    response["CustomerNumber"]
)

if rows:

    customer = rows[0]

    print("Customer Found")
    print()

    print(f"Customer ID     : {customer.CustomerID}")
    print(f"Customer Number : {customer.CustomerNumber}")
    print(f"First Name      : {customer.FirstName}")
    print(f"Last Name       : {customer.LastName}")
    print(f"Email           : {customer.Email}")
    print(f"Phone           : {customer.PhoneNumber}")
    print(f"City            : {customer.City}")
    print(f"State           : {customer.State}")
    print(f"Status          : {customer.CustomerStatus}")

else:

    print("Customer Not Found")