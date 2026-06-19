def compare_assets(previous_inventory,
                   current_inventory):

    old_assets = {
        (
            asset["asset_name"],
            asset["ip_address"]
        )
        for asset in previous_inventory
    }

    new_assets = {
        (
            asset["asset_name"],
            asset["ip_address"]
        )
        for asset in current_inventory
    }

    return {
        "added": sorted(list(
            new_assets - old_assets
        )),

        "removed": sorted(list(
            old_assets - new_assets
        )),

        "unchanged": sorted(list(
            old_assets & new_assets
        ))
    }
