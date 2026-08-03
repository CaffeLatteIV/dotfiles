#!/usr/bin/env python3
import psutil


def get_bars(percent):
    total_slots = 10
    filled = int(total_slots * percent / 100)

    icon_fill = "█"
    icon_empty = "░"

    color = "#9ece6a"
    if percent > 70:
        color = "#e0af68"
    if percent > 90:
        color = "#f7768e"

    # Pango Markup
    return f"<span color='{color}'>{icon_fill * filled}{icon_empty * (total_slots - filled)}</span>"


def main():
    icon_map = {
        "/": "",       # Disk icon for Root
        "/home": "",   # House icon for Home
        "/mnt/data": "",  # Database/Server icon for Data
        "/boot": ""    # Linux icon for Boot
    }

    # Loop through real physical disks
    for part in psutil.disk_partitions(all=False):
        # Skip snap/loop devices usually not needed
        if "loop" in part.device:
            continue

        try:
            usage = psutil.disk_usage(part.mountpoint)

# Use .get() to find the icon, default to a floppy disk if not found
            disk_icon = icon_map.get(part.mountpoint, "💾")

            # Calculate GB
            used_gb = usage.used // (1024**3)
            total_gb = usage.total // (1024**3)

            # Format: Path | Bar | Text details
            # \u00A0 is a non-breaking space to keep alignment neat
            line = (
                f"{disk_icon}  <b>{part.mountpoint:<10}</b>   "
                f"{get_bars(usage.percent)}   "
                f"<span size='small'>{used_gb}/{total_gb} GB</span>"
            )
            print(line)
        except PermissionError:
            continue


if __name__ == "__main__":
    main()
