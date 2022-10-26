functions:
  suid:
    - code: |
        LFILE=file_to_change
        ./chown $(id -un):$(id -gn) $LFILE
  sudo:
    - code: |
        LFILE=file_to_change
        sudo chown $(id -un):$(id -gn) $LFILE
---
