import random

# Define the range of random numbers (e.g., 1 to 10000)
start_range = 1
end_range = 10000

# Generate 10,000 distinct random numbers
random_numbers = random.sample(range(start_range, end_range + 1), 10000)

# Specify the output file name
output_file_name = "test_input_file_name.txt"

# Write the distinct random numbers to the output file
with open(output_file_name, "w") as output_file:
    output_file.write(str(10000) + "\n")
    for number in random_numbers:
        output_file.write(str(number) + "\n")


# Generate 10,000 distinct random numbers
random_numbers = random.sample(range(start_range, 2*end_range + 1), 10000)

# Write the distinct random numbers to the output file
with open(output_file_name, "a") as output_file:
    output_file.write(str(10000) + "\n")
    for number in random_numbers:
        output_file.write(str(number) + "\n")