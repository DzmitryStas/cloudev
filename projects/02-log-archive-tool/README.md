# Project – Log Archive Tool

A simple script that compresses all log files
from the `logs/` folder into a timestamped `.tar.gz` archive and
moves it into the `archive/` folder.

## Usage

```bash
./archive_logs.sh
```

## What it does

- Creates a timestamp
- Compresses the `logs/` folder
- Creates the `archive/` folder if needed
- Moves the archive inside `archive/`

Tested on Ubuntu 22.04 inside Vagrant (VirtualBox)
