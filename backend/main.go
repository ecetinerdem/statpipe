package main

import (
	"log"

	"go.uber.org/zap"
)

func main() {

	app := &application{
		logger: zap.Must(zap.NewProduction()).Sugar(),
	}
	args := app.parseArgs()

	app.args = args

	mux := app.mount()

	log.Fatal(app.run(mux))
}
