#!/usr/bin/env bash
# grep . /sys/bus/usb/devices/*/power/wakeup
echo enabled > /sys/bus/usb/devices/1-5/power/wakeup
echo enabled > /sys/bus/usb/devices/1-7/power/wakeup
echo enabled > /sys/bus/usb/devices/2-4/power/wakeup
echo enabled > /sys/bus/usb/devices/usb1/power/wakeup
echo enabled > /sys/bus/usb/devices/usb2/power/wakeup
