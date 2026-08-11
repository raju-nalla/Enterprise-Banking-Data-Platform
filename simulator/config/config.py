"""
===========================================================
Enterprise Banking Data Platform
Configuration File

Purpose:
    Centralized configuration for the Banking Simulator.

Author:
    Raju Nalla

Version:
    Sprint 4.1
===========================================================
"""

from pathlib import Path

# ===========================================================
# PROJECT PATHS
# ===========================================================

PROJECT_ROOT = Path(__file__).resolve().parents[2]

OUTPUT_FOLDER = PROJECT_ROOT / "simulator" / "output"
LOG_FOLDER = PROJECT_ROOT / "simulator" / "logs"

CUSTOMER_OUTPUT = OUTPUT_FOLDER / "customers"
ACCOUNT_OUTPUT = OUTPUT_FOLDER / "accounts"
LOAN_OUTPUT = OUTPUT_FOLDER / "loans"
TRANSACTION_OUTPUT = OUTPUT_FOLDER / "transactions"
EMPLOYEE_OUTPUT = OUTPUT_FOLDER / "employees"

# ===========================================================
# DATABASE CONFIGURATION
# ===========================================================

"""
Configuration settings for the Banking Data Simulator.
"""

DB_CONFIG = {
    "driver": "ODBC Driver 17 for SQL Server",
    "server": "localhost",
    "database": "EnterpriseBankingDB",
    "trusted_connection": "yes"
}

SIMULATOR_CONFIG = {
    "batch_size": 100,
    "transaction_batch_size": 1000,
    "sleep_interval": 5,
    "log_level": "INFO"
}

# ===========================================================
# BATCH PROCESSING
# ===========================================================

BATCH_CONFIG = {
    "batch_size": 100,
    "simulation_interval_seconds": 2,
    "random_seed": 100,
}

# ===========================================================
# LOGGING CONFIGURATION
# ===========================================================

LOGGING_CONFIG = {
    "log_level": "INFO",
    "log_file": LOG_FOLDER / "banking_simulator.log",
}

# ===========================================================
# FILE EXPORT CONFIGURATION
# (Used later for CSV / JSON / XML generation)
# ===========================================================

EXPORT_CONFIG = {
    "export_csv": True,
    "export_json": False,
    "export_xml": False,
}

# ===========================================================
# BANKING BUSINESS RULES
# ===========================================================

BANKING_RULES = {

    # Initial Deposit Range
    "minimum_initial_deposit": 1000,
    "maximum_initial_deposit": 500000,

    # Loan Amount Range
    "minimum_loan_amount": 50000,
    "maximum_loan_amount": 2500000,

    # Daily Transaction Limits
    "minimum_transaction_amount": 100,
    "maximum_transaction_amount": 100000,

    # Probability Settings
    "loan_approval_rate": 0.75,
    "customer_active_rate": 0.95,
}

# ===========================================================
# APPLICATION INFO
# ===========================================================

APPLICATION_NAME = "Enterprise Banking Simulator"

VERSION = "1.0"

AUTHOR = "Raju Nalla"