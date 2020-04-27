"""
Basically copied from https://github.com/sminez/qtile-config/blob/master/config.py
"""
import os

from libqtile import bar, widget
from libqtile.config import Screen, hook
from libqtile.widget import base

from .settings import COLS, FONT_PARAMS, WITH_SYS_TRAY, SCRIPT_DIR

def _separator():
    # return widget.Sep(linewidth=2, foreground=COLS["dark_3"])
    return widget.Sep(linewidth=2, foreground=COLS["deus_1"])


def widget_with_label(widget_class, label, color=None, *args, **kwargs):
    font_params = {**FONT_PARAMS}
    if color:
        font_params['foreground'] = color

    return [
        widget.TextBox(label,**font_params) if label else None,
        widget_class(
            *args, 
            **font_params,
            **kwargs
        ),
        _separator() if label else None,
    ]
# Purple: 1DB954. Use it somewhere!
# Screens
# ----------------------------------------------------------------------------
def make_screen(systray=False):
    """Defined as a function so that I can duplicate this on other monitors"""
    bat0_path = '/sys/class/power_supply/BATT0'
    running_on_batteries = os.path.exists(bat0_path)
    blocks = [
        # Marker for the start of the groups to give a nice bg: ◢■■■■■■■◤
        widget.TextBox(
            font="Arial", foreground=COLS["dark_4"],
            # font="Arial", foreground=COLS["deus_3"],
            text="◢", fontsize=50, padding=-1
        ),
        widget.GroupBox(
            other_current_screen_border=COLS["orange_0"],
            # this_current_screen_border=COLS["blue_0"],
            this_current_screen_border=COLS["purple_4"],
            other_screen_border=COLS["orange_0"],
            # this_screen_border=COLS["blue_0"],
            this_screen_border=COLS["purple_4"],
            # highlight_color=COLS["blue_0"],
            highlight_color=COLS["purple_4"],
            urgent_border=COLS["red_1"],
            background=COLS["dark_4"],
            # background=COLS["deus_3"],
            highlight_method="line",
            inactive=COLS["dark_3"],
            active=COLS["light_2"],
            disable_drag=True,
            borderwidth=2,
            **FONT_PARAMS,
        ),
        # Marker for the end of the groups to give a nice bg: ◢■■■■■■■◤
        widget.TextBox(
            font="Arial", foreground=COLS["dark_4"],
            # font="Arial", foreground=COLS["deus_3"],
            text="◤ ", fontsize=50, padding=-5
        ),
        # Show the title for the focused window
        widget.WindowName(**FONT_PARAMS),
        # Allow for quick command execution
        widget.Prompt(
            cursor_color=COLS["light_3"],
            # ignore_dups_history=True,
            bell_style="visual",
            prompt="λ : ",
            **FONT_PARAMS
        ),
        _separator(),
        *widget_with_label(widget.Mpris2, "", "#1DB954",
            name='spotify',
            objname="org.mpris.MediaPlayer2.spotify",
            display_metadata=['xesam:title', 'xesam:artist'],
            scroll_chars=None,
            stop_pause_text='',
        ),
        # Resource usage graphs
        widget.CPUGraph(
            border_color=COLS["yellow_1"],
            graph_color=COLS["yellow_1"],
            border_width=1,
            line_width=1,
            type="line",
            width=50,
            **FONT_PARAMS
        ),
        widget.MemoryGraph(
            border_color=COLS["blue_2"],
            graph_color=COLS["blue_2"],
            border_width=1,
            line_width=1,
            type="line",
            width=50,
            **FONT_PARAMS
        ),
        widget.NetGraph(
            border_color=COLS["green_1"],
            graph_color=COLS["green_1"],
            border_width=1,
            line_width=1,
            type="line",
            width=50,
            **FONT_PARAMS
        ),
        # IP information
        # ShellScript(
        #     fname="ipadr.sh",
        #     update_interval=10,
        #     markup=True,
        #     padding=1,
        #     **FONT_PARAMS
        # ),
        # Available apt upgrades
        widget.CheckUpdates(
            display_format="  {updates}",
            colour_have_updates="#d79921",
            colour_no_updates="#b8bb26",
            update_interval=600,
            markup=True,
            padding=1,
            **FONT_PARAMS
        ),

        # Current battery level
        ShellScript(
            fname="battery.sh",
            update_interval=60,
            markup=True,
            padding=1,
            **FONT_PARAMS
        ) if running_on_batteries else None,

        # Wifi strength
        ShellScript(
            fname="wifi-signal.sh",
            update_interval=60,
            markup=True,
            padding=1,
            **FONT_PARAMS
        ) if running_on_batteries else None,

        # Volume % : scroll mouse wheel to change volume
        *widget_with_label(widget.Volume, "",  "#70fdff"),

        # Keyboard layout
        *widget_with_label(widget.KeyboardLayout, "", "#AAAAFF",
                configured_keyboards=['us', 'es']),

        # Current time
        *widget_with_label(widget.Clock, "",
                format="%d/%m %a %I:%M"),
        # Visual indicator of the current layout for this workspace.
        widget.CurrentLayoutIcon(
            custom_icon_paths=[os.path.expanduser("~/.config/qtile/icons")],
            **FONT_PARAMS
        ),
    ]
    # Remove disabled widgets
    blocks = [b for b in blocks if b is not None]

    if systray:
        # Add in the systray and additional separator
        blocks.insert(-1, widget.Systray())
        blocks.insert(-1, _separator())

    # return Screen(top=bar.Bar(blocks, 25, background=COLS["deus_1"]))
    return Screen(bottom=bar.Bar(blocks, 20, background=COLS["dark_2"]))

class ShellScript(base.ThreadedPollText):
    '''
    A generic text widget that polls using a poll function to get its text
    and accepts mouse interaction through the bar.
    When clicked, the script will be able to pull out the following env vars:
        WIDGET_BUTTON - (see below)
        WIDGET_X_LOC  - X location in pixels
        WIDGET_Y_LOC  - Y location in pixels
    Mouse interactions come through as ints mapped as follows
        1: LEFT
        2: RIGHT
        3: MIDDLE
        4: SCROLL_UP
        5: SCROLL_DOWN
    '''
    orientations = base.ORIENTATION_HORIZONTAL
    defaults = [
        ('fname', None, 'Filename in script directory'),
        ('script_dir', SCRIPT_DIR, 'Directory containing the script'),
    ]

    def __init__(self, **config):
        base.ThreadedPollText.__init__(self, **config)
        self.add_defaults(ShellScript.defaults)
        self.fname = self.script_dir + config['fname']

    def poll(self):
        '''When polled just run the script without click info'''
        return self._run_script()

    def _run_script(self, btn=None, x=None, y=None):
        '''Run the script, optionally passing click info in the environment'''
        if btn is not None:
            btn_env = os.environ.copy()
            btn_env['WIDGET_BUTTON'] = str(btn)
            btn_env['WIDGET_X_LOC'] = str(x)
            btn_env['WIDGET_Y_LOC'] = str(y)
            result = subprocess.run(
                self.fname, stdout=subprocess.PIPE, env=btn_env)
        else:
            result = subprocess.run(self.fname, stdout=subprocess.PIPE)

        return result.stdout.decode()

    def button_press(self, x, y, button):
        '''
        Pass the information off to the script but ignore the script output
        '''
        return self._run_script(btn=button, x=x, y=y)

# XXX : When I run qtile inside of mate, I don"t actually want a qtile systray
#       as mate handles that. (Plus, if it _is_ enabled then the mate and
#       qtile trays both crap out...)
screens = [make_screen(systray=WITH_SYS_TRAY)]
