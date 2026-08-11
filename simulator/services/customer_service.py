"""
Enterprise Banking Data Platform

Customer Service

Purpose:
Handles Customer Management using SQL Server Stored Procedures.

Author:
Raju Nalla

Sprint:
4.4
"""

from datetime import datetime

from simulator.utils.database import DatabaseManager


class CustomerService:

    def __init__(self):

        self.db = DatabaseManager()

    # -------------------------------------------------------
    # Generate Customer Number
    # -------------------------------------------------------

    def generate_customer_number(self):

        return "CUST" + datetime.now().strftime("%Y%m%d%H%M%S")

    # -------------------------------------------------------
    # Create Customer
    # -------------------------------------------------------

    def create_customer(self, customer):

        customer_number = self.generate_customer_number()

        parameters = (

            customer_number,
            customer["FirstName"],
            customer["LastName"],
            customer["DateOfBirth"],
            customer["Gender"][0],
            customer["Email"],
            customer["PhoneNumber"],
            customer["Address"],
            None,
            customer["City"],
            customer["State"],
            "India",
            customer["Pincode"]

        )

        self.db.connect()

        try:

            results = self.db.execute_procedure(
                "dbo.usp_CreateCustomer",
                parameters
            )

            if not results or not results[0]:
                raise Exception("Stored procedure returned no data.")

            response = results[0][0]

            return {

                "CustomerNumber": customer_number,
                "CustomerID": response.CustomerID,
                "StatusCode": response.StatusCode,
                "StatusMessage": response.StatusMessage

            }

        finally:

            self.db.disconnect()

        customer_number = self.generate_customer_number()

        parameters = (

            customer_number,
            customer["FirstName"],
            customer["LastName"],
            customer["DateOfBirth"],
            customer["Gender"][0],
            customer["Email"],
            customer["PhoneNumber"],
            customer["Address"],
            None,
            customer["City"],
            customer["State"],
            "India",
            customer["Pincode"]

        )

        self.db.connect()

        try:

            results = self.db.execute_procedure(
                "dbo.usp_GetCustomerByID",
                (customer_id,)
            )

            return results[0] if results else []


        finally:

            self.db.disconnect()

    # -------------------------------------------------------
    # Get Customer By Customer Number
    # -------------------------------------------------------

    def get_customer_by_number(self, customer_number):

        self.db.connect()

        try:

            results = self.db.execute_procedure(
                "dbo.usp_GetCustomerByCustomerNumber",
                (customer_number,)
            )

            return results[0] if results else []

        finally:

            self.db.disconnect()

        self.db.connect()

        try:

            rows = self.db.execute_procedure(
                "dbo.usp_GetCustomerByCustomerNumber",
                (customer_number,)
            )

            return rows

        finally:

            self.db.disconnect()

    # -------------------------------------------------------
    # Get Customer By ID
    # -------------------------------------------------------

    def get_customer_by_id(self, customer_id):

        self.db.connect()

        try:

            results = self.db.execute_procedure(
                "dbo.usp_GetCustomerByID",
                (customer_id,)
            )

            return results[0] if results else []

        finally:

            self.db.disconnect()

        self.db.connect()

        try:

            results = self.db.execute_procedure(
                "dbo.usp_CreateCustomer",
                parameters
            )

            if not results or not results[0]:
                raise Exception("Stored procedure returned no data.")

            response = results[0][0]

            return rows

        finally:

            self.db.disconnect()