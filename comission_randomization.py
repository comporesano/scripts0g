import json
import random
import numpy as np

file_path = '/home/ritual/.nillionapp/validator.json'

with open(file_path, 'r') as file:
    data = json.load(file)

data['amount'] = str(np.random.randint(7000, 10001))

data['commission-rate'] = str(round(random.uniform(0.05, 0.1), 2))

with open(file_path, 'w') as file:
    json.dump(data, file, indent=4)
