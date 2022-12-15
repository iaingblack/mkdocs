If you have an EXT4 disk mounted that you need to resize, do this.

Create a disk like this;

```
sudo fdisk /dev/sdb (make partition)
mkfs -t ext4 /dev/sdb1 (make ext4)
mkdir /u01
mount /dev/sdb1 /u01
```

Then, if you increase the space, this will expand it on the OS

| Operation                                            | Command               |
|------------------------------------------------------|-----------------------|
| Unmount the disk                                     | umount /u01           |
| Check it is removed on filesystem                    | df -h                 |
| Amend partition                                      | fdisk /dev/sdb        |
| Delete that partition                                | d                     |
| Recreate the partition with new limits               | n, p, 1, defaults, w  |
| Check Disk not mounted, unmount if so                | df -h, umount /u01    |
| Check with e2fsck (required before resize2fs resize) | e2fsck -f /dev/sdb1   |
| Resize                                               | resize2fs /dev/sdb1   |
| Remount or reboot                                    | mount /dev/sdb1 /u01  |
