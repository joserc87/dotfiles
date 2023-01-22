"""
Layout definitions
"""
from libqtile import layout
from .settings import COLS
from libqtile.config import Match

_layout_common_settings = dict(
    border_focus=COLS["purple_1"],
    border_normal=COLS["dark_1"],
    border_width=1,
    single_border_width=0,
)

_max_layout_settings = {
    **_layout_common_settings,
    "ratio": 0.5,
    "border_width": 0,
    "border_focus": None,
}

_main_satelite = {
    **_layout_common_settings,
    "ratio": 0.7,
}
# 4K
# GAP = 48
GAP = 32

# Layouts
floating_layout = layout.Floating(
    border_width=0,
    float_rules=[
        Match(wm_class="float"),
        Match(wm_class="floating"),
        Match(wm_class="zoom"),
        Match(wm_class="dragon-drop"),
    ]
)
layouts = [
    layout.MonadTall(name="MainSatelite", **_main_satelite, margin=GAP),
    layout.MonadTall(name="GapsBig", **_layout_common_settings, margin=GAP * 4),
    layout.MonadTall(name="GapsSmall", **_layout_common_settings, margin=GAP),
    layout.MonadTall(name="NoGaps", **_layout_common_settings, margin=1),
    # layout.Floating(**_layout_common_settings),
    # layout.VerticalTile(name='VerticalTile'),
    layout.Max(name="Full", **_max_layout_settings),
    # layout.Zoomy(**_layout_common_settings),
    # layout.Slice(**_layout_common_settings),
]
