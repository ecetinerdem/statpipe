from model import get_model_formula

def print_results(data, model_results):
    # Get the model formula
    intercept, coefficients = get_model_formula(model_results)
    print("\nMultiple Linear Regression Formula")
    features = [
        "age",
        "gender",
        "income",
        "social_trust",
        "discrimination_index",
        "work_stress",
        "religiosity",
        "social_activity",
        "economic_satisfaction",
        "wellbeing",
    ]

    formula = f"Life satisfaction = {intercept:.4f}"

    for coef, feature in zip(coefficients, features):
        formula += f" + {coef:.4f} × {feature}"

    print(formula)
    # R-squared explains variance in data 0-1 1 perfect
    print(f"R-squared (train): {model_results.train_r2:.4f}")
    print(f"R-squared (test): {model_results.test_r2:.4f}")

    # RMSE average predictions error lower better 0-1 0 perfect
    print(f"RMSE (train): {model_results.train_rmse:.4f}")
    print(f"RMSE (test): {model_results.test_rmse:.4f}")