#!/bin/bash

set -e
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
