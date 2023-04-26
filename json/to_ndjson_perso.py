#Import libraries
import json
import os


#Define folder .json
json_folder = "/home/gitpod/enwiki20201020/json"

#For each file in the folder
for each_file in os.listdir(json_folder):

    # Si le fichier se termine par .json
    if each_file.endswith(".json"):
        with open(os.path.join(json_folder, each_file), "r") as json_file:
            # Load JSON data from file
            json_data = json.load(json_file)
            ndjson_data = ""

            # Create empty list to stock the data to send to Elasticsearch
            for document in json_data:
                # Create action as index for each document
                action = {"index": {}}
                # Add action to data list
                ndjson_data += json.dumps(action) + "\n"
                # Add document to data list
                ndjson_data += json.dumps(document) + "\n"
            
            # Add \n at the end of the request
            ndjson_data += "\n"
            
            # Write data to .ndjson file
            with open(os.path.join(json_folder, f"{each_file.split('.')[0]}.ndjson"), "w") as ndjson_file:
                ndjson_file.write(ndjson_data)
