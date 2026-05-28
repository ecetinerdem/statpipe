import type { AnalysisData } from '../types/analysis'

function MetricCard({ label, value }: { label: string; value: string }) {
  return (
    <div className="bg-white rounded-xl p-6 shadow-sm flex flex-col gap-1">
      <span className="text-sm text-gray-500">{label}</span>
      <span className="text-2xl font-bold text-indigo-600">{value}</span>
    </div>
  )
}

export function ModelMetrics({ data }: { data: AnalysisData }) {
  return (
    <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
      <MetricCard label="Train R²" value={data.train_r2.toFixed(4)} />
      <MetricCard label="Test R²" value={data.test_r2.toFixed(4)} />
      <MetricCard label="Train RMSE" value={data.train_rmse.toFixed(4)} />
      <MetricCard label="Test RMSE" value={data.test_rmse.toFixed(4)} />
    </div>
  )
}