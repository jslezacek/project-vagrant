cat >> ~/.ssh/config <<EOF
Host 10.10.10.100
    User git
    IdentityFile ~/.ssh/vagrant_git
    StrictHostKeyChecking no
    IdentitiesOnly yes
EOF
