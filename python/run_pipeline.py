import subprocess
import sys
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parents[1]

scripts = [
    "python/generate_synthetic_data.py",
    "python/etl_load_to_postgres.py",
    "python/etl_validation.py"
]

print("\nStarting Healthcare Revenue Cycle ETL Pipeline")
print("=" * 60)

for script in scripts:
    script_path = BASE_DIR / script

    print(f"\nRunning: {script}")

    result = subprocess.run(
        [sys.executable, str(script_path)],
        cwd=BASE_DIR
    )

    if result.returncode != 0:
        print(f"\nPipeline failed at: {script}")
        sys.exit(result.returncode)

print("\nPipeline completed successfully.")