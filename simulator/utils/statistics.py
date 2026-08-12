"""
Enterprise Banking Data Platform

Statistics Utility

Purpose:
Collects and reports simulator execution statistics.

Author:
Raju Nalla

Sprint:
6.2
"""

from datetime import datetime


class Statistics:
    """
    Collects banking simulator statistics.
    """

    def __init__(self):

        self.reset()

    # -------------------------------------------------------
    # Reset Statistics
    # -------------------------------------------------------

    def reset(self):

        self.start_time = datetime.now()
        self.end_time = None

        self.total_transactions = 0

        self.deposit_count = 0
        self.withdraw_count = 0
        self.transfer_count = 0

        self.success_count = 0
        self.failure_count = 0

        self.total_deposit_amount = 0.0
        self.total_withdraw_amount = 0.0
        self.total_transfer_amount = 0.0

    # -------------------------------------------------------
    # Record Deposit
    # -------------------------------------------------------

    def record_deposit(self, amount, success=True):

        self.total_transactions += 1
        self.deposit_count += 1

        if success:
            self.success_count += 1
            self.total_deposit_amount += amount
        else:
            self.failure_count += 1

    # -------------------------------------------------------
    # Record Withdrawal
    # -------------------------------------------------------

    def record_withdrawal(self, amount, success=True):

        self.total_transactions += 1
        self.withdraw_count += 1

        if success:
            self.success_count += 1
            self.total_withdraw_amount += amount
        else:
            self.failure_count += 1

    # -------------------------------------------------------
    # Record Transfer
    # -------------------------------------------------------

    def record_transfer(self, amount, success=True):

        self.total_transactions += 1
        self.transfer_count += 1

        if success:
            self.success_count += 1
            self.total_transfer_amount += amount
        else:
            self.failure_count += 1

    # -------------------------------------------------------
    # Finish
    # -------------------------------------------------------

    def finish(self):

        self.end_time = datetime.now()

    # -------------------------------------------------------
    # Duration
    # -------------------------------------------------------

    @property
    def execution_time(self):

        if self.end_time is None:
            return datetime.now() - self.start_time

        return self.end_time - self.start_time

    # -------------------------------------------------------
    # Record Transaction
    # -------------------------------------------------------

    def record(
        self,
        transaction_type,
        amount,
        success=True
    ):

        self.total_transactions += 1

        transaction_type = transaction_type.upper()

        if transaction_type == "DEPOSIT":

            self.deposit_count += 1

            if success:
                self.total_deposit_amount += amount

        elif transaction_type == "WITHDRAW":

            self.withdraw_count += 1

            if success:
                self.total_withdraw_amount += amount

        elif transaction_type == "TRANSFER":

            self.transfer_count += 1

            if success:
                self.total_transfer_amount += amount

        if success:
            self.success_count += 1
        else:
            self.failure_count += 1

    # -------------------------------------------------------
    # Print Summary
    # -------------------------------------------------------

    def print_summary(self):

        print()
        print("=" * 70)
        print("SIMULATION SUMMARY")
        print("=" * 70)

        print(f"Total Transactions : {self.total_transactions}")
        print(f"Deposits           : {self.deposit_count}")
        print(f"Withdrawals        : {self.withdraw_count}")
        print(f"Transfers          : {self.transfer_count}")

        print()

        print(f"Successful         : {self.success_count}")
        print(f"Failed             : {self.failure_count}")

        print()

        print(f"Total Deposits     : {self.total_deposit_amount:,.2f}")
        print(f"Total Withdrawals  : {self.total_withdraw_amount:,.2f}")
        print(f"Total Transfers    : {self.total_transfer_amount:,.2f}")

        print()

        print(f"Execution Time     : {self.execution_time}")

        print("=" * 70)