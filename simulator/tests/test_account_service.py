"""
Enterprise Banking Data Platform

Account Service Integration Test

Purpose:
Tests Account Service using SQL Server Stored Procedures.

Author:
Raju Nalla

Sprint:
5.1
"""

from simulator.generators.customer_generator import CustomerGenerator
from simulator.generators.account_generator import AccountGenerator

from simulator.services.customer_service import CustomerService
from simulator.services.account_service import AccountService


print("=" * 70)
print("Account Creation Integration Test")
print("=" * 70)

# -------------------------------------------------------
# Create Customer
# -------------------------------------------------------

customer_generator = CustomerGenerator()
customer_service = CustomerService()

customer = customer_generator.generate_customers(1)[0]

customer_response = customer_service.create_customer(customer)

customer_id = customer_response["CustomerID"]

print("\nCustomer Created Successfully")
print("-" * 70)
print(f"Customer Number : {customer_response['CustomerNumber']}")
print(f"Customer ID     : {customer_id}")

# -------------------------------------------------------
# Generate Account
# -------------------------------------------------------

account_generator = AccountGenerator()

account = account_generator.generate_account(

    customer_id=customer_id,

    branch_id=1

)

# -------------------------------------------------------
# Create Account
# -------------------------------------------------------

account_service = AccountService()

print(account)

account_response = account_service.create_account(account)

print("\nAccount Created Successfully")
print("-" * 70)
print(f"Account Number : {account_response['AccountNumber']}")
print(f"Account ID     : {account_response['AccountID']}")
print(f"Message        : {account_response['Message']}")

# -------------------------------------------------------
# Verification
# -------------------------------------------------------

rows = account_service.get_account_by_number(
    account_response["AccountNumber"]
)

print("\nVerification")
print("-" * 70)

if rows:

    account = rows[0]

    print("Account Found\n")

    print(f"Account ID        : {account.AccountID}")
    print(f"Account Number    : {account.AccountNumber}")
    print(f"Customer ID       : {account.CustomerID}")
    print(f"Branch ID         : {account.BranchID}")
    print(f"Account Type      : {account.AccountType}")
    print(f"Balance           : {account.Balance}")
    print(f"Available Balance : {account.AvailableBalance}")
    print(f"Currency          : {account.CurrencyCode}")
    print(f"Status            : {account.AccountStatus}")
    print(f"Open Date         : {account.OpenDate}")

else:

    print("Account Not Found")

print("\n" + "=" * 70)
print("Account Service Test Completed Successfully")
print("=" * 70)