# StatPipe

A data analysis pipeline that orchestrates Python ML training, a Go backend, and a React frontend — all launched from a single Zig CLI.

## What it does

You run one command. Zig parses your flags, trains a linear regression model on your CSV data using Python, serves the results via a Go REST API, and launches a React frontend to visualize everything in the browser.

```
task cli-zig --name lifesat --path ../data/lifesat.csv ...
      │
      ├── 1. Parse CLI flags (Zig)
      ├── 2. Train ML model, output result.json (Python)
      ├── 3. Serve result.json as REST API (Go)
      └── 4. Launch visualization frontend (Vite + React)
```

## Stack

| Layer | Technology | Purpose |
|---|---|---|
| `cli-zig` | Zig 0.16.0 | CLI flag parsing and process orchestration |
| `analyzer` | Python 3.12.3+, pandas, numpy, scikit-learn | Data preprocessing and linear regression training |
| `backend` | Go 1.23.x, chi, zap | Read model results from JSON and serve via REST API |
| `frontend` | Vite, React, TypeScript, Tailwind, Recharts | Fetch and visualize model results in the browser |

## Prerequisites

- [Zig 0.16.0](https://ziglang.org/download/)
- [pyenv](https://github.com/pyenv/pyenv) with Python 3.12.3 or above
- [Go 1.23.x](https://go.dev/dl/)
- [Node.js](https://nodejs.org/) with npm
- [Task](https://taskfile.dev/) (task runner)

## Getting started

```bash
git clone https://github.com/ecetinerdem/statpipe
cd statpipe
```

### Python setup

Using pyenv is strongly recommended to avoid environment issues. The project is tested with Python 3.12.3 — any version above that should work fine.

```bash
pyenv install 3.12.3
pyenv local 3.12.3
cd analyzer
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

### Go setup

```bash
cd backend
go mod download
```

### Frontend setup

```bash
cd frontend
npm install
```

## Usage

The entire pipeline is orchestrated by the Zig CLI. Run everything with a single task command from the project root:

```bash
task cli-zig
```

This runs with the default configuration defined in `Taskfile.yml`:

```bash
zig build run -- \
  --name lifesat \
  --path ../data/lifesat.csv \
  --columns age,gender,income,social_trust,discrimination_index,work_stress,religiosity,social_activity,economic_satisfaction,wellbeing \
  --target lifesat
```

Once running, open your browser at `http://localhost:5173` to see the results.

## CLI flags

| Flag | Required | Default | Description |
|---|---|---|---|
| `--name` | yes | — | Project name |
| `--path` | yes | — | Path to CSV file |
| `--columns` | yes | — | Feature columns, comma separated |
| `--target` | yes | — | Target column to predict |
| `--model` | no | `linear_regression` | Model to use |
| `--output` | no | `result.json` | Path to output file |
| `--port` | no | `8080` | Backend port |
| `--clean` | no | false | Skip data preprocessing |
| `--verbose` | no | false | Enable verbose logging |
| `--visualize` | no | false | Launch frontend after analysis |

## Running parts individually

Each part can also be run independently via Task:

```bash
# Python analysis only
task analyzer

# Go backend only
task backend

# Frontend only
task frontend
```

## Project structure

```
statpipe/
  cli-zig/        # Zig CLI — flag parsing and orchestration
  analyzer/       # Python — data loading, preprocessing, model training
  backend/        # Go — REST API serving model results
  frontend/       # React — visualization dashboard
  data/           # CSV datasets
  result/         # Model output JSON
  Taskfile.yml
```

## How the Zig orchestrator works

The `cli-zig` component is not just a wrapper — it owns the full process lifecycle. It spawns Python, waits for it to finish, then spawns Go and the Vite dev server as concurrent child processes. When you hit Ctrl+C, all three processes are stopped cleanly since they are children of the Zig process.

The flag parser (`flags.zig`) reads directly from `std.process.Args` and validates required flags before anything runs, printing a help message and exiting early if something is missing.
