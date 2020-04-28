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
    layout.MonadTall(name='Tall', **_layout_common_settings),
    # layout.VerticalTile(name='VerticalTile'),
    layout.Max(name='Full', **_layout_common_settings),
]
