from dataclasses import dataclass
from sklearn.preprocessing import StandardScaler
from sklearn.linear_model import LinearRegression
from sklearn.metrics import r2_score, mean_squared_error
import numpy as np




@dataclass
class ModelResults:
    model: LinearRegression
    scaler: StandardScaler
    train_predictions: np.ndarray
    test_predictions: np.ndarray
    train_r2: float
    test_r2: float
    train_rmse: float
    test_rmse: float

def train_model(data_model):

    scaler = StandardScaler()

    X_scaled = scaler.fit_transform(data_model.X_train)

    model = LinearRegression()
    model.fit(X_scaled, data_model.y_train)

    return model, scaler


def evaluate_model(data_model, model, scaler, logger):
    # Evaluate training data
    X_train_scaled = scaler.transform(data_model.X_train)
    train_predictions = model.predict(X_train_scaled)
    train_r2 = r2_score(data_model.y_train, train_predictions)
    train_rmse = np.sqrt(mean_squared_error(data_model.y_train, train_predictions))


    # Evaluate test data
    X_test_scaled = scaler.transform(data_model.X_test)
    test_predictions = model.predict(X_test_scaled)
    test_r2 = r2_score(data_model.y_test, test_predictions)
    test_rmse = np.sqrt(mean_squared_error(data_model.y_test, test_predictions))


    logger.info(f"Model evaluated. R-squared (train): {train_r2:.4f}, R-squared (test): {test_r2:.4f}")

    return ModelResults(
        model=model,
        scaler=scaler,
        train_predictions=train_predictions,
        test_predictions=test_predictions,
        train_r2=train_r2,
        test_r2=test_r2,
        train_rmse=train_rmse,
        test_rmse=test_rmse
    )


def get_model_formula(model_results):
    model = model_results.model
    scaler = model_results.scaler

    coefficients = []

    for i in range(len(model.coef_)):
        coef = model.coef_[i] / scaler.scale_[i]
        coefficients.append(coef)

    intercept = model.intercept_ - sum(
        model.coef_[i] * scaler.mean_[i] / scaler.scale_[i]
        for i in range(len(model.coef_))
    )

    return intercept, coefficients