import os
from dataclasses import dataclass
import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from config import CONFIG


@dataclass
class ModelData:
    X_train: np.ndarray
    X_test : np.ndarray
    y_train: np.ndarray
    y_test: np.ndarray


def prepare_model_data(preprocessed_data,columns, target, logger):
    
    # Get X and y
    X = preprocessed_data[columns].values
    y = preprocessed_data[target].values

    # Split the data Train and Test
    X_train, X_test, y_train, y_test = train_test_split(
        X,
        y,
        test_size=CONFIG["test_size"],
        random_state=CONFIG["random_state"]
    ) 

    logger.info(f"Data split: {len(X_train)} training samples, {len(X_test)} test samples")
    return ModelData(
        X_train=X_train,
        X_test=X_test,
        y_train=y_train,
        y_test=y_test
    )