functions:
  file-read:
    - code: |
        LFILE=file_to_read
        as @$LFILE
  suid:
    - code: |
        LFILE=file_to_read
        ./as @$LFILE
  sudo:
    - code: |
        LFILE=file_to_read
        sudo as @$LFILE
---