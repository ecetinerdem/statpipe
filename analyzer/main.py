import logging
import pandas as pd

from parse_args import parse_arguments
from load_data import load_data
from preprocess import preprocess_data
from prepare_model_data import prepare_model_data



logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s -%(message)s"
)

logger = logging.getLogger(__name__)

def main ():
    args = parse_arguments()

     # Turn columns string into an array underlying type changes from str to arr
    columns = args.columns.split(",")
    columns.append(args.target)


    # Remove for loop later
    for k, v in vars(args).items():
        print(f"{k} = {v}")
    
    df = load_data(args.path, columns, logger)
    # Remove print later
    # print(df.head(5))
    
    # If dataframe not clean preprocess it
    if not args.clean:
        processed_df = preprocess_data(df, columns, logger)
    else:
        processed_df = df

    # print(processed_df.head(5))

    modelData = prepare_model_data(processed_df, args.columns.split(","), args.target, logger)
    print(modelData.y_test)



if __name__ == "__main__":
    main()