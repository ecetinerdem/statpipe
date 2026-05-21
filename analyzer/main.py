from parse_args import parse_arguments
def main ():
    args = parse_arguments()
    for k, v in vars(args).items():
        print(f"{k} = {v}")



if __name__ == "__main__":
    main()