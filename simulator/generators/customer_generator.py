"""
==========================================================
Enterprise Banking Data Platform
Customer Data Generator

Sprint:
    4.2.1

Author:
    Raju Nalla

Description:
    Generates realistic customer records
    without any database dependency.

==========================================================
"""

import random
import string
from datetime import datetime
from faker import Faker

fake = Faker("en_IN")


class CustomerGenerator:

    def __init__(self):
        pass

    def generate_pan(self):
        letters = ''.join(random.choices(string.ascii_uppercase, k=5))
        digits = ''.join(random.choices(string.digits, k=4))
        last = random.choice(string.ascii_uppercase)

        return f"{letters}{digits}{last}"

    def generate_aadhaar(self):
        return ''.join(random.choices(string.digits, k=12))

    def generate_phone(self):
        first_digit = random.choice(['9', '8', '7', '6'])
        remaining = ''.join(random.choices(string.digits, k=9))

        return first_digit + remaining

    def generate_customer(self):

        gender = random.choice(["Male", "Female"])

        if gender == "Male":
            first_name = fake.first_name_male()
        else:
            first_name = fake.first_name_female()

        last_name = fake.last_name()

        dob = fake.date_of_birth(
            minimum_age=18,
            maximum_age=70
        )

        return {

            "FirstName": first_name,

            "LastName": last_name,

            "Gender": gender,

            "DateOfBirth": dob,

            "Email":
                f"{first_name.lower()}.{last_name.lower()}@gmail.com",

            "PhoneNumber": self.generate_phone(),

            "PANNumber": self.generate_pan(),

            "AadhaarNumber": self.generate_aadhaar(),

            "Occupation":
                random.choice([
                    "Engineer",
                    "Doctor",
                    "Teacher",
                    "Software Engineer",
                    "Business",
                    "Government Employee",
                    "Student"
                ]),

            "AnnualIncome":
                random.randint(300000, 3000000),

            "Address":
                fake.address(),

            "City":
                fake.city(),

            "State":
                fake.state(),

            "Pincode":
                fake.postcode(),

            "CustomerType":
                random.choice([
                    "Retail",
                    "Premium",
                    "Corporate"
                ]),

            "KYCStatus":
                random.choice([
                    "Verified",
                    "Pending",
                    "Rejected"
                ]),

            "CreatedDate":
                datetime.now(),

            "ModifiedDate":
                datetime.now(),

            "IsActive":
                1
        }

    def generate_customers(self, count):

        customers = []

        for _ in range(count):
            customers.append(self.generate_customer())

        return customers