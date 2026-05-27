import sys
import logging
import pandas as pd


from parse_args import parse_arguments
from load_data import load_data
from preprocess import preprocess_data
from prepare_model_data import prepare_model_data
from model import train_model, evaluate_model, get_model_formula
from print_results import print_results
from model_to_json import save_model_to_json



logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s -%(message)s"
)

logger = logging.getLogger(__name__)

def main ():
    args = parse_arguments()

    # Get feature columns and target column
    feature_columns = args.columns.split(",")
    target_column = args.target
    output_json = args.output
    
    
    # Load the data
    df = load_data(args.path, feature_columns + [target_column], logger)
    
    
    # If dataframe not clean preprocess it
    if not args.clean:
        df = preprocess_data(df, feature_columns + [target_column], logger)

    # Prepare data for training
    model_data = prepare_model_data(df, feature_columns, target_column, logger)

    # Train the model
    model, scaler = train_model(model_data)

    # Evaluate results of the model
    model_results = evaluate_model(model_data, model, scaler, logger)
    
    # Print results to terminal
    print_results(model_data, model_results)

    # Write to json output
    save_model_to_json(model_results, model_data, feature_columns, target_column, output_json, logger)
    return 0
if __name__ == "__main__":
    sys.exit(main())