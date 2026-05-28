package main

import (
	"encoding/json"
	"net/http"
	"os"
)

func (app *application) handleModelResult(w http.ResponseWriter, r *http.Request) {
	var modelResult ModelResult

	err := readModelResultFromJsonPath(&modelResult, app.args.jsonOutputPath)
	if err != nil {
		app.internalServerError(w, r, err)
	}

	app.writeJsonResponse(w, http.StatusOK, &modelResult)

}

func readModelResultFromJsonPath(modelResult *ModelResult, jsonPath string) error {
	data, err := os.ReadFile(jsonPath)
	if err != nil {
		return err
	}

	err = json.Unmarshal(data, modelResult)
	if err != nil {
		return err
	}
	return nil
}
