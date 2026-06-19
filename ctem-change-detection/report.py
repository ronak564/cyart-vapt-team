def generate_report(previous_inventory,
                    current_inventory,
                    changes):

    report_lines = []

    report_lines.append("=" * 60)
    report_lines.append("ASSET CHANGE DETECTION REPORT")
    report_lines.append("=" * 60)

    report_lines.append("\nNEW ASSETS")

    if changes["added"]:
        for name, ip in changes["added"]:
            report_lines.append(f"+ {name} ({ip})")
    else:
        report_lines.append("None")

    report_lines.append("\nREMOVED ASSETS")

    if changes["removed"]:
        for name, ip in changes["removed"]:
            report_lines.append(f"- {name} ({ip})")
    else:
        report_lines.append("None")

    report_lines.append("\nUNCHANGED ASSETS")

    if changes["unchanged"]:
        for name, ip in changes["unchanged"]:
            report_lines.append(f"= {name} ({ip})")
    else:
        report_lines.append("None")

    report_lines.append("\nSUMMARY")
    report_lines.append(
        f"Previous Assets : {len(previous_inventory)}"
    )
    report_lines.append(
        f"Current Assets : {len(current_inventory)}"
    )
    report_lines.append(
        f"Added Assets : {len(changes['added'])}"
    )
    report_lines.append(
        f"Removed Assets : {len(changes['removed'])}"
    )
    report_lines.append(
        f"Unchanged Assets : {len(changes['unchanged'])}"
    )

    # Print to terminal
    report_text = "\n".join(report_lines)
    print(report_text)

    # Save to text file
    with open("asset_change_report.txt", "w") as f:
        f.write(report_text)

    print("\nReport saved as: asset_change_report.txt")
