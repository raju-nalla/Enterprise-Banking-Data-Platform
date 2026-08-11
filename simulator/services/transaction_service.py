"""
Enterprise Banking Data Platform

Transaction Service

Purpose:
Handles Banking Transactions using SQL Server Stored Procedures.

Author:
Raju Nalla

Sprint:
6.2
"""

from simulator.utils.database import DatabaseManager


class TransactionService:

    def __init__(self):

        self.db = DatabaseManager()

    # -------------------------------------------------------
    # Deposit
    # -------------------------------------------------------

    def deposit(
        self,
        account_id,
        amount,
        transaction_mode,
        processed_by_employee_id=None,
        remarks=None
    ):

        self.db.connect()

        try:

            results = self.db.execute_procedure(
                "dbo.usp_Deposit",
                (
                    account_id,
                    amount,
                    transaction_mode,
                    processed_by_employee_id,
                    remarks
                )
            )

            return results[0] if results else []

        finally:

            self.db.disconnect()

    # -------------------------------------------------------
    # Withdraw
    # -------------------------------------------------------

    def withdraw(
        self,
        account_id,
        amount,
        transaction_mode,
        remarks=None
    ):

        self.db.connect()

        try:

            results = self.db.execute_procedure(
                "dbo.usp_Withdraw",
                (
                    account_id,
                    amount,
                    transaction_mode,
                    None,          # ProcessedByEmployeeID
                    remarks
                )
            )

            return results[0] if results else []

        finally:

            self.db.disconnect()

    # -------------------------------------------------------
    # Transfer Funds
    # -------------------------------------------------------

    def transfer_funds(
        self,
        from_account_id,
        to_account_id,
        amount,
        transaction_mode,
        remarks=None
    ):

        self.db.connect()

        try:

            results = self.db.execute_procedure(
                "dbo.usp_TransferFunds",
                (
                    from_account_id,
                    to_account_id,
                    amount,
                    transaction_mode,
                    None,          # ProcessedByEmployeeID
                    remarks
                )
            )

            return results[0] if results else []

        finally:

            self.db.disconnect()

    # -------------------------------------------------------
    # Get Account Statement
    # -------------------------------------------------------

    def get_account_statement(
        self,
        account_id,
        from_date,
        to_date
    ):

        self.db.connect()

        try:

            results = self.db.execute_procedure(
                "dbo.usp_GetAccountStatement",
                (
                    account_id,
                    from_date,
                    to_date
                )
            )

            return {

                "Summary": results[0] if len(results) > 0 else [],
                "Transactions": results[1] if len(results) > 1 else []

            }

        finally:

            self.db.disconnect()