functions:
  file-read:
    - code: |
        LFILE=file_to_read
        bridge -b "$LFILE"
  suid:
    - code: |
        LFILE=file_to_read
        ./bridge -b "$LFILE"
  sudo:
    - code: |
        LFILE=file_to_read
        sudo bridge -b "$LFILE"
---