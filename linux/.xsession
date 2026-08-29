#!/bin/sh
# Workaround for a lightdm 1.33.1 + qtile 0.37.0 incompatibility.
#
# /etc/lightdm/Xsession (the session-wrapper) ends with an unquoted, unevaluated
# `exec $@`. The session's Exec line is handed to it as a single string, so it is
# only word-split -- shell quoting is never re-parsed. qtile 0.37.0 changed
# /usr/share/xsessions/qtile.desktop to:
#
#   Exec=/bin/sh -c "systemctl --user import-environment ...; exec systemctl --user start --wait qtile.service"
#
# After word-splitting, /bin/sh receives `-c '"systemctl'` and dies with
#   --user: -c: line 1: unexpected EOF while looking for matching `"'
# which is why the session flashes and drops straight back to the greeter.
#
# /etc/lightdm/Xsession sources this file (if executable) *before* it runs the
# broken command, so we can start the session correctly ourselves and never
# return. Remove this file once lightdm ships `eval exec "$@"` (or qtile drops
# the quotes from its desktop entry).

# Only take over the qtile session; anything else falls through to lightdm.
case "${DESKTOP_SESSION:-qtile}" in
qtile)
    # Hand the display-manager-provided variables to the systemd user manager so
    # qtile.service and xdg-desktop-portal see a valid X display (a bare
    # `import-environment` is deprecated, so list them explicitly; unset
    # variables are skipped).
    systemctl --user import-environment \
        DISPLAY WAYLAND_DISPLAY XAUTHORITY \
        XDG_SEAT XDG_VTNR XDG_SESSION_ID XDG_SESSION_TYPE XDG_SESSION_CLASS \
        XDG_SESSION_DESKTOP XDG_CURRENT_DESKTOP DESKTOP_SESSION

    # Preferred path: run qtile as a systemd user service so that
    # graphical-session.target is activated (portals, screen sharing, ...).
    if systemctl --user start --wait qtile.service; then
        exit 0
    fi

    # Fallback: if the unit is missing or refuses to start, run qtile directly
    # (this is what qtile <= 0.36 did).
    echo "qtile.service failed, starting qtile directly" >&2
    exec qtile start
    ;;
esac
