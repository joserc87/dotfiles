"""
Layout definitions
"""
from libqtile import layout
from .settings import COLS

_layout_common_settings = dict(
    border_focus=COLS['purple_4']
)

_max_layout_settings = {
    **_layout_common_settings,
    "border_focus": None
}

# Layouts
layouts = [
    layout.MonadTall(name='GapsBig', **_layout_common_settings, margin=192),
    layout.MonadTall(name='GapsSmall', **_layout_common_settings, margin=48),
    # layout.Floating(**_layout_common_settings),
    # layout.VerticalTile(name='VerticalTile'),
    layout.Max(name='Full', **_layout_common_settings),
    # layout.Zoomy(**_layout_common_settings),
    # layout.Slice(**_layout_common_settings),
]
