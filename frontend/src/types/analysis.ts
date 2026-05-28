export interface AnalysisData {
    coefficients_standardized: number[]
    coefficients_original: number[]
    intercept_standardized: number
    intercept_original: number
    features: string[]
    target: string
    train_r2: number
    test_r2: number
    train_rmse: number
    test_rmse: number
    feature_means: number[]
    feature_std_devs: number[]
    is_normalized: boolean
    num_samples: number
    version: string
}

export interface ApiResponse {
    data: AnalysisData
}