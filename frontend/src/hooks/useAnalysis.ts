import { useState, useEffect } from 'react'
import type { AnalysisData } from '../types/analysis'

export function useAnalysis() {
    const [data, setData] = useState<AnalysisData | null>(null)
    const [loading, setLoading] = useState(true)
    const [error, setError] = useState<string | null>(null)

    useEffect(() => {
        fetch('http://localhost:8080')
            .then(res => res.json())
            .then(json => {
                setData(json.data)
                setLoading(false)
            })
            .catch(err => {
                setError(err.message)
                setLoading(false)
            })
    }, [])

    return { data, loading, error }
}