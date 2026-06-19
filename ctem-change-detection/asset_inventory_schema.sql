-- =====================================================
-- Asset Monitoring & Change Detection Database Schema
-- PostgreSQL
-- =====================================================

-- ==========================================
-- Assets(Common Asset Information)
-- ==========================================
CREATE TABLE assets (
    asset_id SERIAL PRIMARY KEY,
    asset_name VARCHAR(255) NOT NULL,
    asset_type VARCHAR(50) NOT NULL,
    ip_address INET,
    status VARCHAR(50) DEFAULT 'Active',
    owner VARCHAR(255),
    first_discovered TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_seen TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- ==========================================
-- Internal Assets
-- ==========================================
CREATE TABLE internal_assets (
    internal_asset_id SERIAL PRIMARY KEY,
    asset_id INTEGER UNIQUE NOT NULL,

    hostname VARCHAR(255),
    operating_system VARCHAR(255),
    department VARCHAR(100),
    location VARCHAR(255),
    private_ip INET,
    mac_address VARCHAR(50),

    CONSTRAINT fk_internal_asset
        FOREIGN KEY (asset_id)
        REFERENCES assets(asset_id)
        ON DELETE CASCADE
);

-- ==========================================
-- External Assets
-- ==========================================
CREATE TABLE external_assets (
    external_asset_id SERIAL PRIMARY KEY,
    asset_id INTEGER UNIQUE NOT NULL,

    domain_name VARCHAR(255),
    public_ip INET,
    cloud_provider VARCHAR(100),
    asn VARCHAR(50),
    registrar VARCHAR(255),
    ssl_enabled BOOLEAN DEFAULT FALSE,

    CONSTRAINT fk_external_asset
        FOREIGN KEY (asset_id)
        REFERENCES assets(asset_id)
        ON DELETE CASCADE
);

-- ==========================================
-- Scan Snapshots
-- ==========================================
CREATE TABLE scan_snapshots (
    snapshot_id SERIAL PRIMARY KEY,
    scan_type VARCHAR(50) NOT NULL,
    target VARCHAR(255) NOT NULL,
    scan_status VARCHAR(50) DEFAULT 'Completed',
    started_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP,
    total_assets INTEGER DEFAULT 0,
    total_findings INTEGER DEFAULT 0
);

-- ==========================================
-- Open Ports
-- ==========================================
CREATE TABLE open_ports (
    port_id SERIAL PRIMARY KEY,
    asset_id INTEGER NOT NULL,
    snapshot_id INTEGER,
    port_number INTEGER NOT NULL,
    protocol VARCHAR(10),
    service_name VARCHAR(100),
    service_version VARCHAR(255),
    state VARCHAR(20),
    discovered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_ports_asset
        FOREIGN KEY (asset_id)
        REFERENCES assets(asset_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_ports_snapshot
        FOREIGN KEY (snapshot_id)
        REFERENCES scan_snapshots(snapshot_id)
        ON DELETE SET NULL
);

-- ==========================================
-- DNS Records
-- ==========================================
CREATE TABLE dns_records (
    dns_id SERIAL PRIMARY KEY,
    asset_id INTEGER NOT NULL,
    snapshot_id INTEGER,
    record_type VARCHAR(20) NOT NULL,
    record_value TEXT NOT NULL,
    ttl INTEGER,
    discovered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_dns_asset
        FOREIGN KEY (asset_id)
        REFERENCES assets(asset_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_dns_snapshot
        FOREIGN KEY (snapshot_id)
        REFERENCES scan_snapshots(snapshot_id)
        ON DELETE SET NULL
);

-- ==========================================
-- Vulnerabilities
-- ==========================================
CREATE TABLE vulnerabilities (
    vulnerability_id SERIAL PRIMARY KEY,
    asset_id INTEGER NOT NULL,
    snapshot_id INTEGER,
    vuln_name VARCHAR(255) NOT NULL,
    severity VARCHAR(20),
    cvss_score NUMERIC(3,1),
    cve_id VARCHAR(50),
    description TEXT,
    remediation TEXT,
    status VARCHAR(50) DEFAULT 'Open',
    detected_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    resolved_at TIMESTAMP,

    CONSTRAINT fk_vuln_asset
        FOREIGN KEY (asset_id)
        REFERENCES assets(asset_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_vuln_snapshot
        FOREIGN KEY (snapshot_id)
        REFERENCES scan_snapshots(snapshot_id)
        ON DELETE SET NULL
);

-- ==========================================
-- Asset Changes
-- ==========================================
CREATE TABLE asset_changes (
    change_id SERIAL PRIMARY KEY,
    asset_id INTEGER NOT NULL,
    snapshot_id INTEGER,
    change_type VARCHAR(50) NOT NULL,
    field_name VARCHAR(100) NOT NULL,
    old_value TEXT,
    new_value TEXT,
    detected_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_change_asset
        FOREIGN KEY (asset_id)
        REFERENCES assets(asset_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_change_snapshot
        FOREIGN KEY (snapshot_id)
        REFERENCES scan_snapshots(snapshot_id)
        ON DELETE SET NULL
);

-- ==========================================
-- Asset Logs
-- ==========================================
CREATE TABLE asset_logs (
    log_id SERIAL PRIMARY KEY,
    asset_id INTEGER,
    snapshot_id INTEGER,
    log_level VARCHAR(20) DEFAULT 'INFO',
    event_type VARCHAR(100),
    message TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_log_asset
        FOREIGN KEY (asset_id)
        REFERENCES assets(asset_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_log_snapshot
        FOREIGN KEY (snapshot_id)
        REFERENCES scan_snapshots(snapshot_id)
        ON DELETE SET NULL
);

-- ==========================================
-- Indexes
-- ==========================================
CREATE INDEX idx_assets_name
ON assets(asset_name);

CREATE INDEX idx_assets_ip
ON assets(ip_address);

CREATE INDEX idx_ports_asset
ON open_ports(asset_id);

CREATE INDEX idx_dns_asset
ON dns_records(asset_id);

CREATE INDEX idx_vuln_asset
ON vulnerabilities(asset_id);

CREATE INDEX idx_changes_asset
ON asset_changes(asset_id);

CREATE INDEX idx_logs_asset
ON asset_logs(asset_id);

CREATE INDEX idx_snapshot_started
ON scan_snapshots(started_at);

-- ==========================================
-- Sample Query Verification
-- ==========================================
-- \dt
-- SELECT * FROM assets;
-- SELECT * FROM vulnerabilities;
