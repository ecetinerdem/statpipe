import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, ReferenceLine, ResponsiveContainer } from 'recharts'
import type { AnalysisData } from '../types/analysis'

export function CoefficientsChart({ data }: { data: AnalysisData }) {
  const chartData = data.features.map((feature, i) => ({
    feature,
    coefficient: parseFloat(data.coefficients_original[i].toFixed(4)),
  }))

  return (
    <div className="bg-white rounded-xl p-6 shadow-sm">
      <h2 className="text-lg font-semibold mb-4 text-gray-700">Feature Coefficients</h2>
      <ResponsiveContainer width="100%" height={300}>
        <BarChart data={chartData} margin={{ top: 10, right: 20, left: 0, bottom: 60 }}>
          <CartesianGrid strokeDasharray="3 3" />
          <XAxis dataKey="feature" angle={-45} textAnchor="end" interval={0} tick={{ fontSize: 12 }} />
          <YAxis />
          <Tooltip />
          <ReferenceLine y={0} stroke="#666" />
          <Bar dataKey="coefficient" fill="#6366f1" radius={[4, 4, 0, 0]} />
        </BarChart>
      </ResponsiveContainer>
    </div>
  )
}