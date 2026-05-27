import os
import json
from config import CONFIG

def save_model_to_json(model_results, model_data, feature_columns, target_column, json_path, logger):


    try:
        json_dir = os.path.dirname(json_path)
        if json_dir and not os.path.exists(json_dir):
            os.makedirs(json_dir)
        
        standardized_coefficients = model_results.model.coef_
        standardized_intercept = model_results.model.intercept_
        
        feature_means = model_results.scaler.mean_
        feature_std_devs = model_results.scaler.scale_
        
        num_samples = len(model_data.X_train) + len(model_data.X_test)
        original_coefficients = []

        for i in range(len(standardized_coefficients)):
            coef = standardized_coefficients[i] / feature_std_devs[i]
            original_coefficients.append(float(coef))

        original_intercept = float(
            standardized_intercept
            - sum(
                standardized_coefficients[i] * feature_means[i] / feature_std_devs[i]
                for i in range(len(standardized_coefficients))
            )
        )


        json_data = {
            "coefficients_standardized": standardized_coefficients.tolist(),
            "coefficients_original": original_coefficients,

            "intercept_standardized": float(standardized_intercept),
            "intercept_original": original_intercept,

            "features": feature_columns,
            "target": target_column,

            "train_r2": float(model_results.train_r2),
            "test_r2": float(model_results.test_r2),

            "train_rmse": float(model_results.train_rmse),
            "test_rmse": float(model_results.test_rmse),

            "feature_means": feature_means.tolist(),
            "feature_std_devs": feature_std_devs.tolist(),

            "is_normalized": True,
            "num_samples": num_samples,
            "version": "1.0"
        }

        with open(json_path, "w") as f:
            json.dump(json_data, f, indent=3)
        logger.info(f"Model save to JSON format: {json_path}")
        print(f"\nSaved model coefficients (standardized): {standardized_coefficients}")
        print(f"\nSaved model intercept (standardized): {standardized_intercept}")
        print(f"Feature means: {feature_means}")
        print(f"Feature std devs: {feature_std_devs}")
    except Exception as e:
        error_msg = f"Error saved to {str(e)}"
        logger.info(error_msg)