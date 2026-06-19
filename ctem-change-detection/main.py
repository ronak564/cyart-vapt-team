from database import get_previous_inventory
from detector import compare_assets
from report import generate_report

def get_current_scan():

    return [
        {
            "asset_name": "web01",
            "ip_address": "192.168.1.10"
        },
        {
            "asset_name": "vpn01",
            "ip_address": "192.168.1.40"
        }
    ]


def main():

    previous_inventory = get_previous_inventory()

    current_inventory = get_current_scan()

    changes = compare_assets(
        previous_inventory,
        current_inventory
    )

    # For now comment this out until asset_changes insertion is fixed
    # save_changes(changes)

    generate_report(
        previous_inventory,
        current_inventory,
        changes
    )


if __name__ == "__main__":
    main()
