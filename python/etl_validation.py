import pandas as pd
from sqlalchemy import create_engine, text
import getpass

DB_NAME = "revenue_cycle"
DB_USER = getpass.getuser()
DB_HOST = "localhost"
DB_PORT = "5432"

engine = create_engine(
    f"postgresql+psycopg2://{DB_USER}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
)

tables = [
    "divisions",
    "providers",
    "encounters",
    "documentation_issues",
    "workflow_status",
    "charges",
    "payments"
]

print("\nDATA QUALITY VALIDATION REPORT")
print("=" * 50)

for table in tables:
    query = f"SELECT COUNT(*) as row_count FROM {table}"

    with engine.connect() as conn:
        result = pd.read_sql(query, conn)

    print(f"{table:<25} {result.iloc[0]['row_count']:>10,}")

print("\nValidation Complete")