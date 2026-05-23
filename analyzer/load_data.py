import os
import sys
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.linear_model import LinearRegression
from sklearn.metrics import r2_score, mean_squared_error
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler


def load_data(filepath, columns , logger):
    # Check if file exist
    if not os.path.isfile(filepath):
        logger.error(f"File does not exist: {filepath}")
        sys.exit(1)

   

    # Read the file to pd
    try:
        logger.info(f"Loading the file from {filepath}")
        df = pd.read_csv(filepath)

        for column in columns:
            if column not in df.columns:
                logger.error(f"Required column {column} not found in dataframe")
                sys.exit(1)
        return df
    except Exception as e:
        logger.error(f"Error loading data:{str(e)}")