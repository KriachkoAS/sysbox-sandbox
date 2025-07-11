FROM debian:latest as systemd

#
# Systemd installation
#
RUN apt-get update &&                            \
    apt-get install -y --no-install-recommends   \
            systemd                              \
            systemd-sysv                         \
            libsystemd0                          \
            ca-certificates                      \
            dbus                                 \
            iptables                             \
            iproute2                             \
            kmod                                 \
            locales                              \
            sudo                                 \
            udev                                 \
            wget &&                              \
                                                 \
    # Prevents journald from reading kernel messages from /dev/kmsg
    echo "ReadKMsg=no" >> /etc/systemd/journald.conf &&               \
                                                                      \
    # Housekeeping
    apt-get clean -y &&                                               \
    rm -rf                                                            \
       /var/cache/debconf/*                                           \
       /var/lib/apt/lists/*                                           \
       /var/log/*                                                     \
       /tmp/*                                                         \
       /var/tmp/*                                                     \
       /usr/share/doc/*                                               \
       /usr/share/man/*                                               \
       /usr/share/local/* &&                                          \
                                                                      \
    # Create default 'admin/admin' user
    useradd --create-home --shell /bin/bash admin && echo "admin:admin" | chpasswd && adduser admin sudo

# Disable systemd services/units that are unnecessary within a container.
RUN systemctl mask systemd-udevd.service \
                   systemd-udevd-kernel.socket \
                   systemd-udevd-control.socket \
                   systemd-modules-load.service \
                   sys-kernel-debug.mount \
                   sys-kernel-tracing.mount \
                   sys-kernel-config.mount \
                   e2scrub_reap.service \
                   e2scrub_all.timer

# Make use of stopsignal (instead of sigterm) to stop systemd containers.
STOPSIGNAL SIGRTMIN+3

# Set systemd as entrypoint.
ENTRYPOINT [ "/sbin/init", "--log-level=err" ]


FROM systemd as docker-ssh

# Install Docker
RUN apt-get update && apt-get install -y curl \
    && rm -rf /var/lib/apt/lists/* \
    && curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh \
    # Add user "admin" to the Docker group
    && usermod -a -G docker admin
ADD https://raw.githubusercontent.com/docker/docker-ce/master/components/cli/contrib/completion/bash/docker /etc/bash_completion.d/docker.sh

# Install Sshd
RUN apt-get update && apt-get install --no-install-recommends -y openssh-server \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir /home/admin/.ssh \
    && chown admin:admin /home/admin/.ssh

# Configure Sshd for consistent fingerprint
RUN rm -r /etc/ssh
COPY ./ssh-keys/sandbox /etc/ssh

# Configure ssh authorized_keys
COPY --chown=admin:admin ./ssh-keys/client/id_ecdsa.pub /home/admin/.ssh/authorized_keys

EXPOSE 22

# Set systemd as entrypoint.
ENTRYPOINT [ "/sbin/init", "--log-level=err" ]


FROM docker-ssh as vscode

ARG VSCODE_COMMIT
USER admin
RUN wget https://update.code.visualstudio.com/commit:${VSCODE_COMMIT:?specify VSCODE_COMMIT}/server-linux-x64/stable \
        -P /tmp/vscode-server-install                                                                                \
    && mkdir -p ~/.vscode-server/cli/servers/Stable-${VSCODE_COMMIT}/server                                          \
    && tar -xf /tmp/vscode-server-install/stable --strip-components 1                                                \
        -C ~/.vscode-server/cli/servers/Stable-${VSCODE_COMMIT}/server                                               \
    && rm -r /tmp/vscode-server-install
USER root