#!/usr/bin/env bash
#  ██████╗ ██████╗ ███████╗███╗   ██╗██████╗  █████╗     ██████╗ ██╗ ██████╗███████╗
#  ██╔══██╗██╔══██╗██╔════╝████╗  ██║██╔══██╗██╔══██╗    ██╔══██╗██║██╔════╝██╔════╝
#  ██████╔╝██████╔╝█████╗  ██╔██╗ ██║██║  ██║███████║    ██████╔╝██║██║     █████╗
#  ██╔══██╗██╔══██╗██╔══╝  ██║╚██╗██║██║  ██║██╔══██║    ██╔══██╗██║██║     ██╔══╝
#  ██████╔╝██║  ██║███████╗██║ ╚████║██████╔╝██║  ██║    ██║  ██║██║╚██████╗███████╗
#  ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═══╝╚═════╝ ╚═╝  ╚═╝    ╚═╝  ╚═╝╚═╝ ╚═════╝╚══════╝
#  Author  :  z0mbi3
#  Url     :  https://github.com/gh0stzk/dotfiles
#  About   :  This file will configure and launch the rice.
#

# Terminate existing processes if necessary.
. "${HOME}"/.config/bspwm/src/Process.bash

# Current Rice
read -r RICE < "$HOME"/.config/bspwm/.rice

# Vars config for Brenda Rice
# Bspwm border		# Fade true|false	# Shadows true|false	# Corner radius		# Shadow color
BORDER_WIDTH="0"	P_FADE="true"		P_SHADOWS="true"		P_CORNER_R="0"		SHADOW_C="#000000"

# (Everforest) colorscheme
bg="#0f0e19"  fg="#787c99"

black="#363b54"   red="#f7768e"   green="#7aa2f7"   yellow="#FFFFFF"
blackb="#464c6d"  redb="#f7768e"  greenb="#7aa2f7"  yellowb="#FFFFFF"

blue="#7aa2f7"   magenta="#bb9af7"   cyan="#7aa2f7"   white="#787c99"
blueb="#7aa2f7"  magentab="#bb9af7"  cyanb="#7aa2f7"  whiteb="#acb0d0"

# Gtk theme vars
gtk_theme="TokyoNight-zk"	gtk_icons="WhiteSur-dark"	gtk_cursor="Qogirr-Dark"	geany_theme="z0mbi3-OneDark"


# Set bspwm configuration
set_bspwm_config() {
	bspc config border_width ${BORDER_WIDTH}
	bspc config top_padding 42 #48
	bspc config bottom_padding 0border
	bspc config left_padding 0
	bspc config right_padding 0
	bspc config normal_border_color "${white}"
	bspc config active_border_color "${white}"
	bspc config focused_border_color "${blue}"
	bspc config presel_feedback_color "${yellow}"
}

# Terminal colors
set_term_config() {
	cat >"$HOME"/.config/alacritty/rice-colors.toml <<EOF
# Default colors
[colors.primary]
background = "${bg}"
foreground = "${fg}"

# Cursor colors
[colors.cursor]
cursor = "${fg}"
text = "${bg}"

# Normal colors
[colors.normal]
black   = "${black}"
red     = "${red}"
green   = "${green}"
yellow  = "${yellow}"
blue    = "${blue}"
magenta = "${magenta}"
cyan    = "${cyan}"
white   = "${white}"

# Bright colors
[colors.bright]
black   = "${blackb}"
red     = "${redb}"
green   = "${greenb}"
yellow  = "${yellowb}"
blue    = "${blueb}"
magenta = "${magentab}"
cyan    = "${cyanb}"
white   = "${whiteb}"
EOF

  # Set kitty colorscheme
  cat >"$HOME"/.config/kitty/current-theme.conf <<EOF
# The basic colors
foreground              ${fg}
background              ${bg}
selection_foreground    ${bg}
selection_background    ${cyan}

# Cursor colors
cursor                  ${fg}
cursor_text_color       ${bg}

# URL underline color when hovering with mouse
url_color               ${blue}

# Kitty window border colors
active_border_color     ${magenta}
inactive_border_color   ${black}
bell_border_color       ${yellow}

# Tab bar colors
active_tab_foreground   ${bg}
active_tab_background   ${magenta}
inactive_tab_foreground ${fg}
inactive_tab_background ${black}
tab_bar_background      ${bg}

# The 16 terminal colors

# black
color0 ${black}
color8 ${blackb}

# red
color1 ${red}
color9 ${redb}

# green
color2  ${green}
color10 ${greenb}

# yellow
color3  ${yellow}
color11 ${yellowb}

# blue
color4  ${blue}
color12 ${blueb}

# magenta
color5  ${magenta}
color13 ${magentab}

# cyan
color6  ${cyan}
color14 ${cyanb}

# white
color7  ${white}
color15 ${whiteb}
EOF

pidof -q kitty && killall -USR1 kitty
}

# Set compositor configuration
set_picom_config() {
	sed -i "$HOME"/.config/bspwm/picom.conf \
		-e "s/normal = .*/normal =  { fade = ${P_FADE}; shadow = ${P_SHADOWS}; }/g" \
		-e "s/dock = .*/dock =  { fade = ${P_FADE}; }/g" \
		-e "s/shadow-color = .*/shadow-color = \"${SHADOW_C}\"/g" \
		-e "s/corner-radius = .*/corner-radius = ${P_CORNER_R}/g" \
		-e "s/\".*:class_g = 'Alacritty'\"/\"100:class_g = 'Alacritty'\"/g" \
		-e "s/\".*:class_g = 'kitty'\"/\"100:class_g = 'kitty'\"/g" \
		-e "s/\".*:class_g = 'FloaTerm'\"/\"100:class_g = 'FloaTerm'\"/g"
}

# Set dunst config
set_dunst_config() {
	sed -i "$HOME"/.config/bspwm/dunstrc \
		-e "s/transparency = .*/transparency = 0/g" \
		-e "s/icon_theme = .*/icon_theme = \"${gtk_icons}, Adwaita\"/g" \
		-e "s/frame_color = .*/frame_color = \"${bg}\"/g" \
		-e "s/separator_color = .*/separator_color = \"${fg}\"/g" \
		-e "s/font = .*/font = JetBrainsMono NF Medium 9/g" \
		-e "s/foreground='.*'/foreground='${blue}'/g"

	sed -i '/urgency_low/Q' "$HOME"/.config/bspwm/dunstrc
	cat >>"$HOME"/.config/bspwm/dunstrc <<-_EOF_
		[urgency_low]
		timeout = 3
		background = "${bg}"
		foreground = "${green}"

		[urgency_normal]
		timeout = 5
		background = "${bg}"
		foreground = "${fg}"

		[urgency_critical]
		timeout = 0
		background = "${bg}"
		foreground = "${red}"
	_EOF_
}

# Set eww colors
set_eww_colors() {
	cat >"$HOME"/.config/bspwm/eww/colors.scss <<EOF
\$bg: ${bg};
\$bg-alt: #272e33;
\$fg: ${fg};
\$black: ${black};
\$red: ${red};
\$green: ${green};
\$yellow: ${yellow};
\$blue: ${blue};
\$magenta: ${magenta};
\$cyan: ${cyan};
\$archicon: #0f94d2;
EOF
}

set_launchers() {
	# Jgmenu
	sed -i "$HOME"/.config/bspwm/jgmenurc \
		-e "s/color_menu_bg = .*/color_menu_bg = ${bg}/" \
		-e "s/color_norm_fg = .*/color_norm_fg = ${fg}/" \
		-e "s/color_sel_bg = .*/color_sel_bg = ${black}/" \
		-e "s/color_sel_fg = .*/color_sel_fg = ${fg}/" \
		-e "s/color_sep_fg = .*/color_sep_fg = ${green}/"

	# Rofi launchers
	cat >"$HOME"/.config/bspwm/src/rofi-themes/shared.rasi <<EOF
// Rofi colors for Brenda

* {
    font: "JetBrainsMono NF Bold 9";
    background: ${bg};
    bg-alt: #272e33;
    background-alt: ${bg}E0;
    foreground: ${fg};
    selected: ${blue};
    active: ${green};
    urgent: ${red};

    img-background: url("~/.config/bspwm/rices/${RICE}/rofi.webp", width);
}
EOF
}

set_appearance() {
	# Set the gtk theme corresponding to rice
	if pidof -q xsettingsd; then
		sed -i "$HOME"/.config/bspwm/xsettingsd \
			-e "s|Net/ThemeName .*|Net/ThemeName \"$gtk_theme\"|" \
			-e "s|Net/IconThemeName .*|Net/IconThemeName \"$gtk_icons\"|" \
			-e "s|Gtk/CursorThemeName .*|Gtk/CursorThemeName \"$gtk_cursor\"|"
	else
		sed -i "$HOME"/.config/gtk-3.0/settings.ini \
			-e "s/gtk-theme-name=.*/gtk-theme-name=$gtk_theme/" \
			-e "s/gtk-icon-theme-name=.*/gtk-icon-theme-name=$gtk_icons/" \
			-e "s/gtk-cursor-theme-name=.*/gtk-cursor-theme-name=$gtk_cursor/"

		sed -i "$HOME"/.gtkrc-2.0 \
			-e "s/gtk-theme-name=.*/gtk-theme-name=\"$gtk_theme\"/" \
			-e "s/gtk-icon-theme-name=.*/gtk-icon-theme-name=\"$gtk_icons\"/" \
			-e "s/gtk-cursor-theme-name=.*/gtk-cursor-theme-name=\"$gtk_cursor\"/"
	fi

	sed -i -e "s/Inherits=.*/Inherits=$gtk_cursor/" "$HOME"/.icons/default/index.theme

	# Reload daemon and apply gtk theme
	pidof -q xsettingsd && killall -HUP xsettingsd
	xsetroot -cursor_name left_ptr
}

# Apply Geany Theme
set_geany(){
	sed -i ${HOME}/.config/geany/geany.conf \
	-e "s/color_scheme=.*/color_scheme=$geany_theme.conf/g"
}

# Launch theme
launch_theme() {

  # Set random wallpaper for actual rice
	feh -z --no-fehbg --bg-fill "${HOME}"/.config/bspwm/rices/"${RICE}"/walls

	# Launch dunst notification daemon
	dunst -config "${HOME}"/.config/bspwm/dunstrc &

	# Launch polybar
	sleep 0.1
	for mon in $(polybar --list-monitors | cut -d":" -f1); do
		MONITOR=$mon polybar -q saiphe -c "${HOME}"/.config/bspwm/rices/"${RICE}"/config.ini &
	done
}

### Apply Configurations

set_bspwm_config
set_term_config
set_picom_config
set_dunst_config
set_eww_colors
set_launchers
set_appearance
set_geany
launch_theme
