from sqlalchemy import create_engine, text

DATABASE_URL = (
    "postgresql+psycopg2://postgres:postgres@localhost/asset_monitoring"
)

engine = create_engine(DATABASE_URL)


def get_previous_inventory():

    with engine.connect() as conn:

        result = conn.execute(
            text("""
                SELECT
                    asset_id,
                    asset_name,
                    CAST(ip_address AS TEXT) AS ip_address
                FROM assets
            """)
        )

        return [
            {
                "asset_id": row.asset_id,
                "asset_name": row.asset_name,
                "ip_address": row.ip_address
            }
            for row in result
        ]


def save_changes(changes):

    with engine.begin() as conn:

        # Added Assets
        for name, ip in changes["added"]:

            conn.execute(
                text("""
                    INSERT INTO asset_changes
                    (
                        asset_id,
                        snapshot_id,
                        change_type,
                        field_name,
                        old_value,
                        new_value
                    )
                    VALUES
                    (
                        NULL,
                        NULL,
                        'ADDED',
                        'ASSET',
                        NULL,
                        :value
                    )
                """),
                {
                    "value": f"{name} ({ip})"
                }
            )

        # Removed Assets
        for name, ip in changes["removed"]:

            conn.execute(
                text("""
                    INSERT INTO asset_changes
                    (
                        asset_id,
                        snapshot_id,
                        change_type,
                        field_name,
                        old_value,
                        new_value
                    )
                    VALUES
                    (
                        NULL,
                        NULL,
                        'REMOVED',
                        'ASSET',
                        :value,
                        NULL
                    )
                """),
                {
                    "value": f"{name} ({ip})"
                }
            )
