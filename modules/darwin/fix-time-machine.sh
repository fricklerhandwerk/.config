#!/usr/bin/env bash

# inspired by http://tonylawrence.com/posts/unix/fixing-corrupted-time-machine-backups/

set -e
shopt -s failglob

if [[ $(whoami) != 'root' ]]
then
  echo "must be root"
  exit 1
fi

if [[ "$#" -lt 1 ]]
then
  echo "usage: fix-time-machine <Time Machine mount point>"
  exit 2
fi

mount="$1"
sparsebundles=( "$mount"/*.sparsebundle )
if [[ ${#sparsebundles[@]} -ne 1 ]]
then
  echo "volume must have exactly one sparsebundle, found" ${#sparsebundles[@]}
  ls "$mount" | rg '*.sparsebundle'
  exit 3
fi
file="${sparsebundles[0]}"
plist="$file"/com.apple.TimeMachine.MachineID.plist

echo "Disabling Time Machine"
tmutil disable

echo "Changing file and folder flags"
chflags -R nouchg "$file"

echo "Attaching sparse bundle"
disk=`hdiutil attach -nomount -readwrite -noverify -noautofsck "$file" | rg Apple_HFS | cut -d ' ' -f 1`

echo "Repairing volume"
fsck_hfs -fry "$disk"

echo "Fixing Properties"
sed -i \
  -e '/RecoveryBackupDeclinedDate/{N;d;}' \
  -e '/VerificationState/{n;s/2/0/;}'     \
  "$plist.backup"

echo "Unmounting volumes"
hdiutil detach "$disk"
umount "$mount"

echo "Enabling Time Machine"
tmutil enable
