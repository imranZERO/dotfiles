#!/usr/bin/env bash
# Shared bemenu theme — source this file, do not run it directly.
# Detects KDE / GTK color scheme and sets bemenu_config accordingly.

_bemenu_detect_theme() {
    if command -v kreadconfig6 &>/dev/null; then
        local scheme
        scheme=$(kreadconfig6 --file kdeglobals --group General --key ColorScheme 2>/dev/null)
        [[ "$scheme" == *[Dd]ark* ]] && echo dark || echo light
        return
    fi
    if command -v gsettings &>/dev/null; then
        local scheme
        scheme=$(gsettings get org.gnome.desktop.interface color-scheme 2>/dev/null)
        [[ "$scheme" == *dark* ]] && echo dark || echo light
        return
    fi
    echo dark
}

if [[ "$(_bemenu_detect_theme)" == dark ]]; then
    # VS Code Dark+
    _bm_bg='#1e1e1e' _bm_fb='#3c3c3c'
    _bm_fg='#d4d4d4'
    _bm_tf='#9cdcfe' _bm_hb='#0e639c' _bm_hf='#ffffff'
    _bm_bdr='#007acc'
    _bm_scb='#3c3c3c' _bm_scf='#007acc'
else
    # VS Code Light+
    _bm_bg='#f3f3f3' _bm_fb='#ffffff'
    _bm_fg='#333333'
    _bm_tf='#0070c1' _bm_hb='#0060c0' _bm_hf='#ffffff'
    _bm_bdr='#007acc'
    _bm_scb='#e0e0e0' _bm_scf='#007acc'
fi

bemenu_config=(
    -b -i -l 20
    --fn 'Iosevka Fixed'
    --fb "$_bm_fb" --ff "$_bm_fg"
    --nb "$_bm_bg" --nf "$_bm_fg"
    --tb "$_bm_bg" --tf "$_bm_tf"
    --hb "$_bm_hb" --hf "$_bm_hf"
    --ab "$_bm_bg" --af "$_bm_fg"
    -B 2 --bdr "$_bm_bdr"
    --scrollbar autohide --scb "$_bm_scb" --scf "$_bm_scf"
    --line-height 25
)

unset -f _bemenu_detect_theme
unset _bm_bg _bm_fb _bm_fg _bm_tf _bm_hb _bm_hf _bm_bdr _bm_scb _bm_scf
