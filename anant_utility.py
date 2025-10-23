def convert_memory_units(input_str):
    import re

    pattern = r'^([\d.]+)\s*([kKmMgGtTpPeEbB]+)$'
    match = re.match(pattern, input_str.strip())
    if not match:
        raise ValueError("Input must be in the form <number><unit>, e.g., 1.5GB or 512kB")

    num, unit = match.groups()
    num = float(num)
    unit = unit.upper()

    binary_units = {
        "B": 1,
        "KB": 1024,
        "MB": 1024**2,
        "GB": 1024**3,
        "TB": 1024**4,
        "PB": 1024**5,
        "EB": 1024**6,
        "BIT": 1/8,
        "KBIT": 1024/8,
        "MBIT": 1024**2/8,
        "GBIT": 1024**3/8
    }

    # Normalize unit (handle things like "kB", "kb", "Kb", etc.)
    if unit.endswith("BIT"):
        base_bytes = num * binary_units[unit]
    else:
        if not unit.endswith("B"):
            unit += "B"
        base_bytes = num * binary_units[unit]

    print(f"Input: {input_str.strip()}")
    print(f"Bits:       {base_bytes * 8:.2f} bit")
    print(f"Bytes:      {base_bytes:.2f} B")
    print(f"Kilobytes:  {base_bytes / 1024:.2f} KB")
    print(f"Megabytes:  {base_bytes / 1024**2:.2f} MB")
    print(f"Gigabytes:  {base_bytes / 1024**3:.4f} GB")

