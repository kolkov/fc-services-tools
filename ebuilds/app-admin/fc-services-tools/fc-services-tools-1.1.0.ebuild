# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Tools for managing pattern-based services in Gentoo OpenRC"
HOMEPAGE="https://github.com/yourusername/fc-services-tools"
SRC_URI=""

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="
    sys-apps/openrc
    sys-fs/inotify-tools
    app-shells/bash
"

S="${WORKDIR}"

src_install() {
    # Install main scripts
    dobin "${FILESDIR}"/fc-restart-deps
    dobin "${FILESDIR}"/fc-bin-monitor
    dobin "${FILESDIR}"/fc-status

    # Install init script
    newinitd "${FILESDIR}"/fc-services.initd fc-bin-monitor
    
    # Install configuration file
    newconfd "${FILESDIR}"/fc-services.confd fc-services
    
    # Install profile script
    insinto /etc/profile.d
    newins "${FILESDIR}"/fc-services.profile fc-services.sh
}

pkg_postinst() {
    elog "fc-services-tools v1.1.0 successfully installed!"
    elog ""
    elog "Configuration file: /etc/conf.d/fc-services"
    elog "You can customize:"
    elog "  - WATCH_DIR: Directory to monitor for binary changes"
    elog "  - SERVICE_PATTERN: Service name pattern (regex)"
    elog ""
    elog "Main commands:"
    elog "  fc-status    - View status of services with colors"
    elog "  fc-restart-deps <service> - Restart service and dependencies"
    elog ""
    elog "To start monitoring service:"
    elog "  rc-update add fc-bin-monitor default"
    elog "  rc-service fc-bin-monitor start"
}