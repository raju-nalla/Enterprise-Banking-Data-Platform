"""
Enterprise Banking Data Platform

Account Service

Purpose:
Handles Account Management using SQL Server Stored Procedures.

Author:
Raju Nalla

Sprint:
5.1
"""

from simulator.utils.database import DatabaseManager


class AccountService:

    def __init__(self):

        self.db = DatabaseManager()

    # -------------------------------------------------------
    # Create Account
    # -------------------------------------------------------

    def create_account(self, account):

        parameters = (

            account["CustomerID"],
            account["BranchID"],
            account["AccountType"],
            account["OpeningBalance"],
            account["CurrencyCode"]

        )

        self.db.connect()

        try:

            results = self.db.execute_procedure(
                "dbo.usp_CreateAccount",
                parameters
            )

            if not results or not results[0]:
                raise Exception("Stored procedure returned no data.")

            response = results[0][0]

            return {

                "AccountID": response.AccountID,
                "AccountNumber": response.AccountNumber,
                "Message": response.StatusMessage

            }

        finally:

            self.db.disconnect()

    # -------------------------------------------------------
    # Update Account Status
    # -------------------------------------------------------

    def update_account_status(
        self,
        account_number,
        account_status
    ):

        self.db.connect()

        try:

            results = self.db.execute_procedure(
                "dbo.usp_UpdateAccountStatus",
                (
                    account_number,
                    account_status
                )
            )

            return results[0] if results else []

        finally:

            self.db.disconnect()

    # -------------------------------------------------------
    # Get Account By Number
    # -------------------------------------------------------

    def get_account_by_number(self, account_number):

        self.db.connect()

        try:

            results = self.db.execute_procedure(
                "dbo.usp_GetAccountByAccountNumber",
                (
                    account_number,
                )
            )

            return results[0] if results else []

        finally:

            self.db.disconnect()

    # -------------------------------------------------------
    # Get Account By ID
    # -------------------------------------------------------

    def get_account_by_id(self, account_id):

        self.db.connect()

        try:

            results = self.db.execute_procedure(
                "dbo.usp_GetAccountByID",
                (
                    account_id,
                )
            )

            return results[0] if results else []

        finally:

            self.db.disconnect()

    # -------------------------------------------------------
    # Get All Accounts
    # -------------------------------------------------------

    def get_all_accounts(self):

        self.db.connect()

        try:

            results = self.db.execute_procedure(
                "dbo.usp_GetAllAccounts"
            )

            return results[0] if results else []

        finally:

            self.db.disconnect()

    # -------------------------------------------------------
    # Close Account
    # -------------------------------------------------------

    def close_account(self, account_number):

        self.db.connect()

        try:

            results = self.db.execute_procedure(
                "dbo.usp_CloseAccount",
                (
                    account_number,
                )
            )

            return results[0] if results else []

        finally:

            self.db.disconnect()