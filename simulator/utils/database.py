"""
Enterprise Banking Data Platform

Database Utility

Purpose:
Centralized SQL Server database access layer.

Author:
Raju Nalla

Sprint:
4.2
===========================================================
"""

import pyodbc

from simulator.config.config import DB_CONFIG
from simulator.utils.logger import Logger


class DatabaseManager:
    """
    Centralized Database Access Layer.
    """

    def __init__(self):

        self.connection = None
        self.cursor = None

        self.logger = Logger.get_logger()

    # -------------------------------------------------------
    # Connect
    # -------------------------------------------------------

    def connect(self):
        """
        Establish SQL Server Connection.
        """

        try:

            connection_string = (
                f"DRIVER={{{DB_CONFIG['driver']}}};"
                f"SERVER={DB_CONFIG['server']};"
                f"DATABASE={DB_CONFIG['database']};"
                f"Trusted_Connection={DB_CONFIG['trusted_connection']};"
            )

            self.connection = pyodbc.connect(connection_string)
            self.cursor = self.connection.cursor()

            self.logger.info("Database connected successfully.")

        except Exception as ex:

            self.logger.exception(
                f"Database connection failed : {ex}"
            )

            raise

    # -------------------------------------------------------
    # Disconnect
    # -------------------------------------------------------

    def disconnect(self):
        """
        Close Database Connection.
        """

        try:

            if self.cursor:
                self.cursor.close()

            if self.connection:
                self.connection.close()

            self.logger.info("Database connection closed.")

        except Exception as ex:

            self.logger.exception(
                f"Error while closing database connection : {ex}"
            )

    # -------------------------------------------------------
    # Ensure Connection
    # -------------------------------------------------------

    def _ensure_connection(self):

        if self.connection is None or self.cursor is None:
            raise Exception(
                "Database connection is not established."
            )

    # -------------------------------------------------------
    # Execute Query
    # -------------------------------------------------------

    def execute_query(self, query, params=None):
        """
        Execute SELECT Query.
        """

        self._ensure_connection()

        self.logger.info("Executing SQL Query.")

        if params:
            self.cursor.execute(query, params)
        else:
            self.cursor.execute(query)

        return self.cursor.fetchall()

    # -------------------------------------------------------
    # Execute Non Query
    # -------------------------------------------------------

    def execute_non_query(self, query, params=None):
        """
        Execute INSERT / UPDATE / DELETE.
        """

        self._ensure_connection()

        self.logger.info("Executing Non Query.")

        if params:
            self.cursor.execute(query, params)
        else:
            self.cursor.execute(query)

        self.connection.commit()

    # -------------------------------------------------------
    # Execute Stored Procedure
    # -------------------------------------------------------

    def execute_procedure(self, procedure_name, params=None):
        """
        Execute SQL Server Stored Procedure.

        Returns:
            list

            Example:

            results[0] -> First Result Set
            results[1] -> Second Result Set
            results[2] -> Third Result Set
        """

        self._ensure_connection()

        self.logger.info(
            f"Executing Stored Procedure : {procedure_name}"
        )

        try:

            if params:

                placeholders = ",".join(["?"] * len(params))

                sql = f"EXEC {procedure_name} {placeholders}"

                self.cursor.execute(sql, params)

            else:

                self.cursor.execute(
                    f"EXEC {procedure_name}"
                )

            results = []

            while True:

                try:

                    rows = self.cursor.fetchall()

                    if rows:
                        results.append(rows)                                        

                except pyodbc.ProgrammingError:
                    pass

                if not self.cursor.nextset():
                    break

            self.connection.commit()

            self.logger.info(
                "Executing Stored Procedure : %s | Params : %s",
                procedure_name,
                params
            )
            return results

        except Exception as ex:

            if self.connection:
                self.connection.rollback()

            self.logger.exception(
                f"Stored Procedure failed : {procedure_name}"
            )

            raise

    # -------------------------------------------------------
    # Commit
    # -------------------------------------------------------

    def commit(self):

        self._ensure_connection()

        self.connection.commit()

    # -------------------------------------------------------
    # Rollback
    # -------------------------------------------------------

    def rollback(self):

        self._ensure_connection()

        self.connection.rollback()

    # -------------------------------------------------------
    # Context Manager Support
    # -------------------------------------------------------

    def __enter__(self):

        self.connect()

        return self

    def __exit__(self, exc_type, exc_val, exc_tb):

        self.disconnect()