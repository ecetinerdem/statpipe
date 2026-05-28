package main

type ModelResult struct {
	CoefficientsStandardized []float64 `json:"coefficients_standardized"`
	CoefficientsOriginal     []float64 `json:"coefficients_original"`

	InterceptStandardized float64 `json:"intercept_standardized"`
	InterceptOriginal     float64 `json:"intercept_original"`

	Features []string `json:"features"`
	Target   string   `json:"target"`

	TrainR2 float64 `json:"train_r2"`
	TestR2  float64 `json:"test_r2"`

	TrainRMSE float64 `json:"train_rmse"`
	TestRMSE  float64 `json:"test_rmse"`

	FeatureMeans   []float64 `json:"feature_means"`
	FeatureStdDevs []float64 `json:"feature_std_devs"`

	IsNormalized bool `json:"is_normalized"`
	NumSamples   int  `json:"num_samples"`

	Version string `json:"version"`
}
