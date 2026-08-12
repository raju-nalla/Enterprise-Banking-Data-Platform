from datetime import datetime
from pathlib import Path


class AuditLogger:

    def __init__(self):

        Path("simulator/logs").mkdir(
            parents=True,
            exist_ok=True
        )

        self.log_file = (
            Path("simulator/logs")
            / "audit.log"
        )

    def log_transaction(
        self,
        transaction_type,
        account_id,
        amount,
        success
    ):

        status = "SUCCESS" if success else "FAILED"

        with open(
            self.log_file,
            "a",
            encoding="utf-8"
        ) as file:

            file.write(
                f"{datetime.now()} | "
                f"{transaction_type} | "
                f"Account={account_id} | "
                f"Amount={amount} | "
                f"{status}\n"
            )