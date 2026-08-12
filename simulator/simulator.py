"""
Enterprise Banking Data Platform

Banking Transaction Simulator

Purpose:
Main entry point for generating realistic banking transactions.

Author:
Raju Nalla

Sprint:
6.2
"""

import random

from simulator.generators.transaction_generator import TransactionGenerator
from simulator.services.transaction_service import TransactionService
from simulator.utils.database import DatabaseManager
from simulator.utils.logger import Logger
from simulator.utils.statistics import Statistics
from simulator.utils.audit_logger import AuditLogger


class BankingSimulator:

    def __init__(self):

        self.logger = Logger.get_logger()

        self.db = DatabaseManager()

        self.transaction_generator = TransactionGenerator()

        self.transaction_service = TransactionService()

        self.statistics = Statistics()

        self.audit_logger = AuditLogger()

        self.accounts = []

    # -------------------------------------------------------
    # Connect
    # -------------------------------------------------------

    def connect(self):

        self.db.connect()

        self.logger.info(
            "Banking Simulator connected."
        )

    # -------------------------------------------------------
    # Disconnect
    # -------------------------------------------------------

    def disconnect(self):

        self.db.disconnect()

        self.logger.info(
            "Banking Simulator disconnected."
        )

    # -------------------------------------------------------
    # Load Active Accounts
    # -------------------------------------------------------

    def load_accounts(self):

        query = """
        SELECT AccountID
        FROM core.Accounts
        WHERE AccountStatus='Active'
          AND IsActive=1
        ORDER BY AccountID;
        """

        rows = self.db.execute_query(query)

        self.accounts = [row.AccountID for row in rows]

        self.logger.info(
            "Loaded %d active accounts.",
            len(self.accounts)
        )

    # -------------------------------------------------------
    # Deposit
    # -------------------------------------------------------

    def run_deposit(self):

        account_id = random.choice(self.accounts)

        transaction = self.transaction_generator.generate_deposit(
            account_id
        )

        result = self.transaction_service.deposit(

            account_id=transaction["AccountID"],

            amount=transaction["Amount"],

            transaction_mode=transaction["TransactionMode"],

            remarks=transaction["Remarks"]

        )

        result = result[0]

        status_code = result[4]

        print("\n" + "=" * 70)
        print("DEPOSIT")
        print("=" * 70)

        print(f"Account ID : {transaction['AccountID']}")
        print(f"Amount     : {transaction['Amount']}")
        print(f"Mode       : {transaction['TransactionMode']}")
        print(f"Remarks    : {transaction['Remarks']}")

        print("\nDATABASE RESULT")
        print("-" * 60)

        print(f"Transaction Number : {result[0]}")
        print(f"Account ID         : {result[1]}")
        print(f"Account Number     : {result[2]}")
        print(f"Balance            : {result[3]}")
        print(f"Status Code        : {result[4]}")
        print(f"Message            : {result[5]}")

        self.audit_logger.log_transaction(

            transaction_type="Deposit",

            account_id=transaction["AccountID"],

            amount=transaction["Amount"],

            success=(status_code == 0)

        )

        self.statistics.record_deposit(
            amount=transaction["Amount"],
            success=(status_code == 0)
        )

    # -------------------------------------------------------
    # Withdrawal
    # -------------------------------------------------------

    def run_withdraw(self):

        account_id = random.choice(self.accounts)

        transaction = self.transaction_generator.generate_withdrawal(
            account_id
        )

        result = self.transaction_service.withdraw(

            account_id=transaction["AccountID"],

            amount=transaction["Amount"],

            transaction_mode=transaction["TransactionMode"],

            remarks=transaction["Remarks"]

        )

        result = result[0]

        status_code = result[4]

        print("\n" + "=" * 70)
        print("WITHDRAW")
        print("=" * 70)

        print(f"Account ID : {transaction['AccountID']}")
        print(f"Amount     : {transaction['Amount']}")
        print(f"Mode       : {transaction['TransactionMode']}")
        print(f"Remarks    : {transaction['Remarks']}")

        print("\nDATABASE RESULT")
        print("-" * 60)

        print(f"Transaction Number : {result[0]}")
        print(f"Account ID         : {result[1]}")
        print(f"Account Number     : {result[2]}")
        print(f"Balance            : {result[3]}")
        print(f"Status Code        : {result[4]}")
        print(f"Message            : {result[5]}")

        self.audit_logger.log_transaction(

            transaction_type="Withdrawal",

            account_id=transaction["AccountID"],

            amount=transaction["Amount"],

            success=(status_code == 0)

        )

        self.statistics.record_withdrawal(
            amount=transaction["Amount"],
            success=(status_code == 0)
        )

    # -------------------------------------------------------
    # Transfer
    # -------------------------------------------------------

    def run_transfer(self):

        source, destination = random.sample(self.accounts, 2)

        transaction = self.transaction_generator.generate_transfer(

            source,

            destination

        )

        result = self.transaction_service.transfer_funds(

            from_account_id=transaction["FromAccountID"],

            to_account_id=transaction["ToAccountID"],

            amount=transaction["Amount"],

            transaction_mode=transaction["TransactionMode"],

            remarks=transaction["Remarks"]

        )

        result = result[0]

        status_code = result[6]

        print("\n" + "=" * 70)
        print("TRANSFER")
        print("=" * 70)

        print(f"Source      : {transaction['FromAccountID']}")
        print(f"Destination : {transaction['ToAccountID']}")
        print(f"Amount      : {transaction['Amount']}")
        print(f"Mode        : {transaction['TransactionMode']}")

        print("\nDATABASE RESULT")
        print("-" * 60)

        print(f"Debit Transaction  : {result[0]}")
        print(f"Credit Transaction : {result[1]}")
        print(f"Source Account     : {result[2]}")
        print(f"Destination Account: {result[3]}")
        print(f"Source Balance     : {result[4]}")
        print(f"Destination Balance: {result[5]}")
        print(f"Status Code        : {result[6]}")
        print(f"Message            : {result[7]}")

        self.audit_logger.log_transaction(

            transaction_type="Transfer",

            account_id=transaction["FromAccountID"],

            amount=transaction["Amount"],

            success=(status_code == 0)

        )

        self.statistics.record_transfer(
            amount=transaction["Amount"],
            success=(status_code == 0)
        )

    # -------------------------------------------------------
    # Run Simulator
    # -------------------------------------------------------

    def run(self):

        self.connect()

        self.load_accounts()

        print("=" * 70)
        print("Enterprise Banking Simulator")
        print("=" * 70)

        print(f"\nActive Accounts Loaded : {len(self.accounts)}")
        print(self.accounts)

        for _ in range(20):

            transaction_type = random.choice(
                [
                    "DEPOSIT",
                    "WITHDRAW",
                    "TRANSFER"
                ]
            )

            if transaction_type == "DEPOSIT":

                self.run_deposit()

            elif transaction_type == "WITHDRAW":

                self.run_withdraw()

            else:

                self.run_transfer()

        self.statistics.finish()

        self.statistics.print_summary()

        self.disconnect()


if __name__ == "__main__":

    simulator = BankingSimulator()

    simulator.run()