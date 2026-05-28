package main

import "flag"

type Args struct {
	name           string
	csvInputPath   string
	columns        string
	target         string
	model          string
	clean          bool
	jsonOutputPath string
	verbose        bool
	visualize      bool
	port           string
}

func (app *application) parseArgs() *Args {
	var name string
	var csvInputPath string
	var columns string
	var target string
	var model string
	var clean bool
	var jsonOutputPath string
	var verbose bool
	var visualize bool
	var port string

	flag.StringVar(&name, "name", "lifesat", "Name of the analysis")
	flag.StringVar(&csvInputPath, "path", "../data/lifesat.csv", "Path to csv")
	flag.StringVar(&columns, "columns", "age,gender,income,social_trust,discrimination_index,work_stress,religiosity,social_activity,economic_satisfaction,wellbeing", "Feature columns")
	flag.StringVar(&target, "target", "lifesat", "target column")
	flag.StringVar(&model, "model", "linear_regression", "ML model to use defaults to Multiple Linear Regression")
	flag.BoolVar(&clean, "clean", false, "Is data clean? Default false")
	flag.StringVar(&jsonOutputPath, "output", "../result/result.json", "Results of data analysis and model evaluation")
	flag.BoolVar(&verbose, "verbose", false, "Verbose output")
	flag.BoolVar(&visualize, "visualize", false, "Visualize output")
	flag.StringVar(&port, "port", "8080", "Port to run backend")
	var args = Args{
		name:           name,
		csvInputPath:   csvInputPath,
		columns:        columns,
		target:         target,
		model:          model,
		clean:          clean,
		jsonOutputPath: jsonOutputPath,
		verbose:        verbose,
		visualize:      visualize,
		port:           port,
	}
	return &args
}
