"""
Enterprise Banking Data Platform

Transaction Service Test

Purpose:
Tests Transaction Service using SQL Server Stored Procedures.

Author:
Raju Nalla

Sprint:
6.3
"""

from datetime import date

from simulator.services.transaction_service import TransactionService


service = TransactionService()

# -------------------------------------------------------
# Test Data
# -------------------------------------------------------

SOURCE_ACCOUNT_ID = 2
DESTINATION_ACCOUNT_ID = 3

# -------------------------------------------------------
# Deposit
# -------------------------------------------------------

print("=" * 80)
print("DEPOSIT")
print("=" * 80)

deposit = service.deposit(
    account_id=SOURCE_ACCOUNT_ID,
    amount=5000,
    transaction_mode="UPI",
    remarks="Salary Credit"
)

for row in deposit:
    print(row)

# -------------------------------------------------------
# Withdraw
# -------------------------------------------------------

print("\n" + "=" * 80)
print("WITHDRAW")
print("=" * 80)

withdraw = service.withdraw(
    account_id=SOURCE_ACCOUNT_ID,
    amount=1000,
    transaction_mode="ATM",
    remarks="ATM Withdrawal"
)

for row in withdraw:
    print(row)

# -------------------------------------------------------
# Transfer Funds
# -------------------------------------------------------

print("\n" + "=" * 80)
print("TRANSFER")
print("=" * 80)

transfer = service.transfer_funds(
    from_account_id=SOURCE_ACCOUNT_ID,
    to_account_id=DESTINATION_ACCOUNT_ID,
    amount=2500,
    transaction_mode="IMPS",
    remarks="Fund Transfer"
)

for row in transfer:
    print(row)

# -------------------------------------------------------
# Account Statement
# -------------------------------------------------------

print("\n" + "=" * 80)
print("ACCOUNT STATEMENT")
print("=" * 80)

statement = service.get_account_statement(
    account_id=SOURCE_ACCOUNT_ID,
    from_date=date(2026, 1, 1),
    to_date=date.today()
)

print("\nSUMMARY")
print("-" * 80)

for row in statement["Summary"]:
    print(row)

print("\nTRANSACTIONS")
print("-" * 80)

for row in statement["Transactions"]:
    print(row)