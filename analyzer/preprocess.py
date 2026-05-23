import pandas as pd
from config import CONFIG

def preprocess_data(dataframe, columns, logger):
    logger.info("Preprocessing data")

    # Copy df for changes
    processed_df = dataframe.copy()

    # Coerce to numeric data. Right now only handling numeric
    for column in columns:
        processed_df[column] = pd.to_numeric(processed_df[column], errors="coerce")

    # Handle missing data
    if preprocess_data[[columns]].isna().any().any():
        logger.warning("Missing values found, dropping rows with missing values")
        processed_df = processed_df.dropna(subset=columns)


    # Handle outliers
    for column in columns:
        # Mean of the column
        mean = processed_df[column].mean()

        # Standart deviation of the column
        std = processed_df[column].std()

        # Upper and lower bounds for the outliers
        treshold = CONFIG["outlier_treshold"]
        lower_bound = mean - treshold * std
        upper_bound = mean + treshold * std


        outliers = (processed_df[column] > lower_bound) | (processed_df[column] > upper_bound)
        if outliers.any():
            logger.warning(f"Removing outliers: {outliers.sum()} outliers from {column}")
            processed_df = processed_df[~outliers]
    return processed_df