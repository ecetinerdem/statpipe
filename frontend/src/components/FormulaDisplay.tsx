import type { AnalysisData } from '../types/analysis'

export function FormulaDisplay({ data }: { data: AnalysisData }) {
  const terms = data.features.map((feature, i) => {
    const coef = data.coefficients_original[i]
    const sign = coef >= 0 ? '+' : '-'
    return `${sign} ${Math.abs(coef).toFixed(4)} × ${feature}`
  })

  return (
    <div className="bg-white rounded-xl p-6 shadow-sm">
      <h2 className="text-lg font-semibold mb-3 text-gray-700">Model Formula</h2>
      <p className="text-sm text-gray-600 font-mono leading-relaxed">
        {data.target} = {data.intercept_original.toFixed(4)} {terms.join(' ')}
      </p>
    </div>
  )
}