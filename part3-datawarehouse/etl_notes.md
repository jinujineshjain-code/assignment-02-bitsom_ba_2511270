## ETL Decisions

### Decision 1 — Standardising Inconsistent Date Formats
Problem: The `date` column in `retail_transactions.csv` contained three different formats across rows — `YYYY-MM-DD` (e.g., `2023-02-05`), `DD-MM-YYYY` (e.g., `28-04-2023`), and `DD/MM/YYYY` (e.g., `29/08/2023`). Mixing these formats makes it impossible to sort, filter, or group data by time correctly. A query like "show all sales in August 2023" would fail or return wrong results if the dates are stored inconsistently.
Resolution: During the ETL transformation step, all date values were parsed and converted to the ISO standard format `YYYY-MM-DD` before being loaded into the `dim_date` dimension table. Each date was also decomposed into separate columns — `day`, `month`, `month_name`, `quarter`, and `year` — to support time-based analytical queries without repeated string parsing at query time.

---

### Decision 2 — Fixing Inconsistent Category Casing
Problem: The `category` column contained the same categories spelled differently due to inconsistent casing. For example, `Electronics` appeared as both `Electronics` and `electronics`, and `Groceries` appeared as both `Groceries` and `Grocery`. This means a simple `GROUP BY category` query would treat these as four separate categories instead of two, producing incorrect aggregations and misleading reports.
Resolution: During the transformation step, all category values were normalised to Title Case and a standard vocabulary was enforced — `electronics` and `Electronics` were both mapped to `Electronics`, and `Grocery` was mapped to `Groceries`. This cleaned value was stored in the `dim_product` table so all downstream queries work on consistent data.

---

### Decision 3 — Handling NULL Store City Values
Problem: Several rows in `retail_transactions.csv` had a missing (NULL) value in the `store_city` column, even though the `store_name` was present (e.g., `Chennai Anna` with no city). This would cause issues in city-level reporting — stores without a city would either be excluded from reports or grouped under a NULL bucket, making geographic analysis unreliable.
Resolution: Since the store name uniquely identifies the store location, a lookup mapping was applied during the transformation step — `Chennai Anna` → `Chennai`, `Delhi South` → `Delhi`, `Mumbai Central` → `Mumbai`, `Pune FC Road` → `Pune`. Missing city values were filled in before loading into the `dim_store` table. This ensured every store record has a valid, non-NULL city value for accurate geographic reporting.
