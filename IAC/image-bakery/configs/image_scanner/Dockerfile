# maintainer: john Karendys <john.karendys@optctblox.com>
FROM ubuntu:22.04

RUN \
    # Dependencies  
    apt update && apt-get -y install gnupg lsb-release wget curl && \
    # Trivi
    wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | apt-key add - && \
    echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main | tee -a /etc/apt/sources.list.d/trivy.list && \
    apt-get update && apt-get install trivy && \
# Grype
    curl -sSfL https://raw.githubusercontent.com/anchore/grype/main/install.sh | sh -s -- -b /usr/local/bin && \
# Dockle
    VERSION=$(curl --silent "https://api.github.com/repos/goodwithtech/dockle/releases/latest" | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/' ) && \ 
    curl -L -o dockle.deb https://github.com/goodwithtech/dockle/releases/download/v${VERSION}/dockle_${VERSION}_Linux-64bit.deb && \ 
    dpkg -i dockle.deb && rm dockle.deb && \
# Cleanup
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/apt && \
    rm -rf /tmp/*

# Hardening
RUN chmod u-s /usr/bin/chsh /usr/bin/su /usr/bin/passwd /usr/bin/mount /usr/bin/umount /usr/bin/gpasswd /usr/bin/newgrp /usr/bin/chfn
RUN chmod g-s /usr/bin/wall /usr/sbin/pam_extrausers_chkpwd /usr/bin/expiry
RUN chmod g-s  /usr/bin/chage /usr/sbin/unix_chkpwd