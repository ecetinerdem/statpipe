import argparse
from config import CONFIG


def parse_arguments():
    parser = argparse.ArgumentParser(description='Linear Regression analysis on given  data')

    parser.add_argument(
        "-n", "--name",
        type=str,
        default=CONFIG["name"],
        help=f'Name of the analysis',
    )

    parser.add_argument(
     "--path",
     type=str,
     default=CONFIG["default_csv"],
     help=f'Path to CSV file (default: {CONFIG["default_csv"]})'
    )

    parser.add_argument(
        "--columns",
        type=str,
        help="Which columns to add for the analysis eg. col1,col2,col3..."
    )

    parser.add_argument(
        "--target",
        type=str,
        help="Target column to predict"
    )
    parser.add_argument(
        "--model",
        type=str,
        default=CONFIG["default_model"]
    )

    parser.add_argument(
        "--clean",
        action="store_false",
        help="Is the data clean"
    )
    parser.add_argument(
        "--output",
        type=str,
        default=CONFIG["output_json"],
        help="Output json file path"
    )

    parser.add_argument(
        "--verbose",
        action="store_false",
        help="Outputs to console in verbose mode"
    )

    parser.add_argument(
        "--visualize",
        action="store_false",
        help="Visualize the output.json"
    )

    parser.add_argument(
        "--port",
        type=str,
        default=CONFIG["default_port"],
        help=f'Serves the output.json on the port. (default: {CONFIG["default_port"]})'
    )

    return parser.parse_args()