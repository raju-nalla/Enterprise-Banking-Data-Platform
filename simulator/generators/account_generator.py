"""
Enterprise Banking Data Platform

Account Generator

Purpose:
Generates realistic bank account data for simulator.

Author:
Raju Nalla

Sprint:
5.1
"""

import random


class AccountGenerator:

    def __init__(self):

        self.account_types = [
            "SB",      # Savings
            "CA"       # Current
        ]

        self.currencies = [
            "INR"
        ]

    # -------------------------------------------------------
    # Generate Single Account
    # -------------------------------------------------------

    def generate_account(
        self,
        customer_id,
        branch_id
    ):

        account = {

            "CustomerID": customer_id,

            "BranchID": branch_id,

            "AccountType": random.choice(
                self.account_types
            ),

            "OpeningBalance": round(
                random.uniform(1000, 500000),
                2
            ),

            "CurrencyCode": random.choice(
                self.currencies
            )

        }

        return account

    # -------------------------------------------------------
    # Generate Multiple Accounts
    # -------------------------------------------------------

    def generate_accounts(
        self,
        customer_ids,
        branch_ids,
        accounts_per_customer=(1, 2)
    ):

        accounts = []

        for customer_id in customer_ids:

            number_of_accounts = random.randint(
                accounts_per_customer[0],
                accounts_per_customer[1]
            )

            for _ in range(number_of_accounts):

                account = self.generate_account(

                    customer_id=customer_id,

                    branch_id=random.choice(branch_ids)

                )

                accounts.append(account)

        return accounts