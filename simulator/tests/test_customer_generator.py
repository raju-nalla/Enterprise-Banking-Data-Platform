from simulator.generators.customer_generator import CustomerGenerator

generator = CustomerGenerator()

customers = generator.generate_customers(5)

for customer in customers:
    print(customer)
    print("-" * 80)