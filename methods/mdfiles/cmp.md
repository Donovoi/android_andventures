functions:
  file-read:
    - code: |
        LFILE=file_to_read
        cmp $LFILE /dev/zero -b -l
  suid:
    - code: |
        LFILE=file_to_read
        ./cmp $LFILE /dev/zero -b -l
  sudo:
    - code: |
        LFILE=file_to_read
        sudo cmp $LFILE /dev/zero -b -l
---