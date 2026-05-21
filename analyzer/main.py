from parse_args import parse_arguments
import logging
from load_data import load_data
import pandas as pd


logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s -%(message)s"
)

logger = logging.getLogger(__name__)

def main ():
    args = parse_arguments()
    for k, v in vars(args).items():
        print(f"{k} = {v}")
    
    df = load_data(args.path, args.columns, logger)
    print(df.head(5))



if __name__ == "__main__":
    main()