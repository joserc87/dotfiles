"""
Layout definitions
"""
from libqtile import layout
from .settings import COLS
from libqtile.config import Match

_layout_common_settings = dict(
    border_focus=COLS['purple_4'],
    border_normal=COLS['dark_1'],
    border_width=0,
    single_border_width=0,
)

_max_layout_settings = {
    **_layout_common_settings,
    "border_focus": None
}

_main_satelite = {
    **_layout_common_settings,
    "ratio": 0.7,
}


# Layouts
floating_layout = layout.Floating(float_rules=[
    Match(wm_class='float'),
    Match(wm_class='floating'),
    Match(wm_class="zoom"),
])
layouts = [
    layout.MonadTall(name='MainSatelite', **_main_satelite, margin=48),
    layout.MonadTall(name='GapsBig', **_layout_common_settings, margin=192),
    layout.MonadTall(name='GapsSmall', **_layout_common_settings, margin=48),
    layout.MonadTall(name='NoGaps', **_layout_common_settings, margin=1),
    # layout.Floating(**_layout_common_settings),
    # layout.VerticalTile(name='VerticalTile'),
    layout.Max(name='Full', **_layout_common_settings),
    # layout.Zoomy(**_layout_common_settings),
    # layout.Slice(**_layout_common_settings),
]
