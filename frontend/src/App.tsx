import { useAnalysis } from './hooks/useAnalysis'
import { CoefficientsChart } from './components/CoefficientsChart'
import { ModelMetrics } from './components/ModelMetrics'
import { FormulaDisplay } from './components/FormulaDisplay'

function App() {
  const { data, loading, error } = useAnalysis()

  if (loading) return (
    <div className="min-h-screen flex items-center justify-center text-gray-500">
      Loading analysis...
    </div>
  )

  if (error) return (
    <div className="min-h-screen flex items-center justify-center text-red-500">
      Error: {error}
    </div>
  )

  if (!data) return null

  return (
    <div className="min-h-screen bg-gray-50 p-8">
      <div className="max-w-4xl mx-auto flex flex-col gap-6">
        <div>
          <h1 className="text-2xl font-bold text-gray-800">StatPipe Results</h1>
          <p className="text-gray-500 text-sm mt-1">
            Target: <span className="font-medium">{data.target}</span> · 
            Samples: <span className="font-medium">{data.num_samples}</span> · 
            Model: Multiple Linear Regression
          </p>
        </div>

        <ModelMetrics data={data} />
        <CoefficientsChart data={data} />
        <FormulaDisplay data={data} />
      </div>
    </div>
  )
}

export default App