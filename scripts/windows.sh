#!/bin/sh

# run `sudo efibootmgr` to see the boot order

sudo efi -bootnext 0000
reboot
