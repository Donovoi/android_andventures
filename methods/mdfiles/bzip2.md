functions:
  file-read:
    - code: |
        LFILE=file_to_read
        bzip2 -c $LFILE | bzip2 -d
  suid:
    - code: |
        LFILE=file_to_read
        ./bzip2 -c $LFILE | bzip2 -d
  sudo:
    - code: |
        LFILE=file_to_read
        sudo bzip2 -c $LFILE | bzip2 -d
---