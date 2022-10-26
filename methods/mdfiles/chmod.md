functions:
  suid:
    - code: |
        LFILE=file_to_change
        ./chmod 6777 $LFILE
  sudo:
    - code: |
        LFILE=file_to_change
        sudo chmod 6777 $LFILE
---
