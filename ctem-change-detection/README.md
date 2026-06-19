# Asset Change Detection System

## Overview

The Asset Change Detection System is a Python-based solution that compares the existing asset inventory stored in a PostgreSQL database with a newly scanned inventory. The system identifies newly added assets, removed assets, and unchanged assets, then generates a summary report.

This project demonstrates asset inventory monitoring and change detection, which are important components of Continuous Threat Exposure Management (CTEM) and asset management programs.

---

## Features

* Compare previous and current asset inventories
* Detect newly added assets
* Detect removed assets
* Identify unchanged assets
* Generate a summary report
* Connect to PostgreSQL asset inventory database
* Unit test support using Pytest

---

## Project Structure

```text
ctem-change-detection/
│
├── database.py
├── detector.py
├── report.py
├── main.py
│
├── tests/
│   └── test_detector.py
│
├── requirements.txt
├── README.md
└── screenshots/
```

---

## Database Schema

Database Name:

```text
asset_monitoring
```

Tables Used:

### assets

Stores the existing asset inventory.

| Column           | Description          |
| ---------------- | -------------------- |
| asset_id         | Unique Asset ID      |
| asset_name       | Asset Name           |
| asset_type       | Asset Type           |
| ip_address       | Asset IP Address     |
| status           | Current Status       |
| owner            | Asset Owner          |
| first_discovered | First Discovery Time |
| last_seen        | Last Seen Time       |

### asset_changes

Stores detected asset changes.

| Column      | Description         |
| ----------- | ------------------- |
| change_id   | Change Record ID    |
| asset_id    | Related Asset ID    |
| snapshot_id | Snapshot Reference  |
| change_type | ADDED / REMOVED     |
| field_name  | Changed Field       |
| old_value   | Previous Value      |
| new_value   | New Value           |
| detected_at | Detection Timestamp |

---

## Installation

Install dependencies:

```bash
pip install -r requirements.txt
```

Required packages:

```text
sqlalchemy
psycopg2-binary
pytest
```

---

## Database Configuration

Update the PostgreSQL connection string in `database.py`.

Example:

```python
DATABASE_URL = "postgresql+psycopg2:///asset_monitoring"
```

or

```python
DATABASE_URL = "postgresql+psycopg2://postgres:PASSWORD@localhost/asset_monitoring"
```

---

## Execution

Run the application:

```bash
python3 main.py
```

---

## Sample Inventory Data

### Previous Inventory (Database)

| Asset Name | IP Address   |
| ---------- | ------------ |
| web01      | 192.168.1.10 |
| db01       | 192.168.1.20 |
| app01      | 192.168.1.30 |

### Current Scan

| Asset Name | IP Address   |
| ---------- | ------------ |
| web01      | 192.168.1.10 |
| app01      | 192.168.1.30 |
| vpn01      | 192.168.1.40 |

---

## Expected Output

```text
============================================================
ASSET CHANGE DETECTION REPORT
============================================================

NEW ASSETS
+ vpn01 (192.168.1.40)

REMOVED ASSETS
- db01 (192.168.1.20)

UNCHANGED ASSETS
= web01 (192.168.1.10)
= app01 (192.168.1.30)

SUMMARY

Previous Assets : 3
Current Assets  : 3
Added Assets    : 1
Removed Assets  : 1
Unchanged Assets: 2
```

---

## Running Tests

Execute unit tests:

```bash
pytest tests/
```

Expected Result:

```text
====================
1 passed
====================
```

---

## Screenshots

Include the following screenshots in the submission:

### 1. Database Assets

```sql
SELECT * FROM assets;
```

### 2. Program Execution

```bash
python3 main.py
```

### 3. Test Results

```bash
pytest tests/
```

---

## Future Enhancements

* Nmap-based live asset discovery
* Asset change history tracking
* Asset modification detection
* HTML/PDF report generation
* Dashboard integration
* Scheduled scans

---

## Author

Asset Change Detection System

Python + PostgreSQL Implementation for Asset Inventory Monitoring and Change Detection.
