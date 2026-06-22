import pandas as pd
from pathlib import Path
from sqlalchemy import create_engine, text
import getpass

BASE_DIR = Path(__file__).resolve().parents[1]
DATA_DIR = BASE_DIR / "data"

DB_NAME = "revenue_cycle"
DB_USER = getpass.getuser()
DB_HOST = "localhost"
DB_PORT = "5432"

engine = create_engine(
    f"postgresql+psycopg2://{DB_USER}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
)

tables = {
    "divisions": "divisions.csv",
    "providers": "providers.csv",
    "encounters": "encounters.csv",
    "documentation_issues": "documentation_issues.csv",
    "workflow_status": "workflow_status.csv",
    "charges": "charges.csv",
    "payments": "payments.csv",
}

def load_table(table_name, file_name):
    file_path = DATA_DIR / file_name

    if not file_path.exists():
        raise FileNotFoundError(f"Missing file: {file_path}")

    df = pd.read_csv(file_path)

    df.to_sql(
        table_name,
        engine,
        if_exists="append",
        index=False
    )

    print(f"Loaded {len(df)} records into {table_name}")

def main():
    print("Starting ETL load to PostgreSQL...")

    with engine.begin() as conn:
        conn.execute(text("TRUNCATE TABLE payments RESTART IDENTITY CASCADE;"))
        conn.execute(text("TRUNCATE TABLE charges RESTART IDENTITY CASCADE;"))
        conn.execute(text("TRUNCATE TABLE workflow_status RESTART IDENTITY CASCADE;"))
        conn.execute(text("TRUNCATE TABLE documentation_issues RESTART IDENTITY CASCADE;"))
        conn.execute(text("TRUNCATE TABLE encounters RESTART IDENTITY CASCADE;"))
        conn.execute(text("TRUNCATE TABLE providers RESTART IDENTITY CASCADE;"))
        conn.execute(text("TRUNCATE TABLE divisions RESTART IDENTITY CASCADE;"))

    for table_name, file_name in tables.items():
        load_table(table_name, file_name)

    print("ETL load completed successfully.")

if __name__ == "__main__":
    main()