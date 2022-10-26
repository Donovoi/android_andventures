functions:
  file-read:
    - code: |
        LFILE=file_to_read
        atobm $LFILE 2>&1 | awk -F "'" '{printf "%s", $2}'
  sudo:
    - code: |
        LFILE=file_to_read
        sudo atobm $LFILE 2>&1 | awk -F "'" '{printf "%s", $2}'
  suid:
    - code: |
        LFILE=file_to_read
        ./atobm $LFILE 2>&1 | awk -F "'" '{printf "%s", $2}'
---
