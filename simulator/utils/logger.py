"""
======================================================
Enterprise Banking Data Platform

Centralized Logger

Sprint : 4.2
======================================================
"""

import logging
import os

LOG_FOLDER = "simulator/logs"

os.makedirs(LOG_FOLDER, exist_ok=True)

LOG_FILE = os.path.join(LOG_FOLDER, "simulator.log")


class Logger:

    @staticmethod
    def get_logger():

        logger = logging.getLogger("BankingSimulator")

        if not logger.handlers:

            logger.setLevel(logging.INFO)

            formatter = logging.Formatter(
                "%(asctime)s | %(levelname)s | %(message)s"
            )

            file_handler = logging.FileHandler(LOG_FILE)

            file_handler.setFormatter(formatter)

            logger.addHandler(file_handler)

        return logger