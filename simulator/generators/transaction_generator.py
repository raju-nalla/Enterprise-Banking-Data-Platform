"""
Enterprise Banking Data Platform

Transaction Generator

Purpose:
Generates realistic banking transactions for simulator.

Author:
Raju Nalla

Sprint:
6.1
"""

import random


class TransactionGenerator:
    """
    Generates Deposit, Withdrawal and Transfer transactions.
    """

    DEPOSIT_MODES = [
        "UPI",
        "Cash",
        "Cheque",
        "NEFT",
        "RTGS",
        "Internet Banking",
        "Mobile Banking"
    ]

    WITHDRAWAL_MODES = [
        "ATM",
        "UPI",
        "Cheque",
        "Branch",
        "POS"
    ]

    TRANSFER_MODES = [
        "UPI",
        "IMPS",
        "NEFT",
        "RTGS",
        "Internet Banking"
    ]

    DEPOSIT_REMARKS = [
        "Salary Credit",
        "Cash Deposit",
        "Cheque Deposit",
        "Interest Credit",
        "Refund",
        "Bonus Credit"
    ]

    WITHDRAWAL_REMARKS = [
        "ATM Withdrawal",
        "Cash Withdrawal",
        "Shopping",
        "Fuel",
        "Online Purchase",
        "Bill Payment"
    ]

    TRANSFER_REMARKS = [
        "Fund Transfer",
        "Rent Payment",
        "Family Transfer",
        "Vendor Payment",
        "Loan Payment"
    ]

    # -------------------------------------------------------
    # Deposit
    # -------------------------------------------------------

    def generate_deposit(self, account_id):

        return {

            "TransactionType": "Deposit",

            "AccountID": account_id,

            "Amount": round(
                random.uniform(500, 100000),
                2
            ),

            "TransactionMode": random.choice(
                self.DEPOSIT_MODES
            ),

            "Remarks": random.choice(
                self.DEPOSIT_REMARKS
            )

        }

    # -------------------------------------------------------
    # Withdrawal
    # -------------------------------------------------------

    def generate_withdrawal(self, account_id):

        return {

            "TransactionType": "Withdrawal",

            "AccountID": account_id,

            "Amount": round(
                random.uniform(100, 50000),
                2
            ),

            "TransactionMode": random.choice(
                self.WITHDRAWAL_MODES
            ),

            "Remarks": random.choice(
                self.WITHDRAWAL_REMARKS
            )

        }

    # -------------------------------------------------------
    # Transfer
    # -------------------------------------------------------

    def generate_transfer(
        self,
        from_account_id,
        to_account_id
    ):

        if from_account_id == to_account_id:

            raise ValueError(
                "Source and Destination accounts cannot be the same."
            )

        return {

            "TransactionType": "Transfer",

            "FromAccountID": from_account_id,

            "ToAccountID": to_account_id,

            "Amount": round(
                random.uniform(500, 75000),
                2
            ),

            "TransactionMode": random.choice(
                self.TRANSFER_MODES
            ),

            "Remarks": random.choice(
                self.TRANSFER_REMARKS
            )

        }