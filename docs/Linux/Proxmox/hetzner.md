How to setup

Good article - https://medium.com/maxkimambo/proxmox-image-installation-on-hetzner-servers-f5ebbe287f48

Good overall video - https://www.youtube.com/watch?v=pgV8B-u9Kps


proxmox.rootisgod.com

Rescue mode
installimage
Install 'Other'
Choose Proxmox Bullseye

Change HOSTNAME to an FQDN if you have one

    PART swap swap 32G
    PART /boot ext3 512M
    PART / ext4 64G
    PART /var/data ext4 all

Then check the disk space

    root@proxmox ~ # df -h
    Filesystem      Size  Used Avail Use% Mounted on
    udev             32G     0   32G   0% /dev
    tmpfs           6.3G  848K  6.3G   1% /run
    /dev/md2         63G  3.1G   57G   6% /
    tmpfs            32G   46M   32G   1% /dev/shm
    tmpfs           5.0M     0  5.0M   0% /run/lock
    /dev/md1        485M  176M  284M  39% /boot
    /dev/md3        374G   28K  355G   1% /var/data
    /dev/fuse       128M   16K  128M   1% /etc/pve
    tmpfs           6.3G     0  6.3G   0% /run/user/0

Find the md3 partition which has our space

Unmount it

    umount /dev/md3

Create a PV Group

    pvcr
    vgcreate vg0 /dev/md3
    lvcreate -n vms -l 100%FREE vg0
    mkfs.ext4 /dev/vg0/vms

Change fstab entry from

    UUID=eeabffed-5ecf-4037-a008-8c2d17c9dbed /var/data ext4 defaults 0 0

to

    /dev/vg0/vms /var/data ext4 defaults 0 0

We can now go into proxmox, Datacentre, Storage, add Directory, choose our VG0.

This still allows Thin Provisioning when you creata a VM, just be sure to choose QEMU Image Formate (QCOW2) as the disk type.

Then, create a Linux Bridge
https://bobcares.com/blog/setup-nat-on-proxmox/


    auto vmbr99
    #private sub network
    iface vmbr99 inet static
        address  10.10.10.1
        netmask  255.255.255.0
        bridge-ports none
        bridge-stp off
        bridge-fd 0

        post-up   echo 1 > /proc/sys/net/ipv4/ip_f
        post-up   iptables -t nat -A POSTROUTING -s '10.10.10.0/24' -o enp0s31f6 -j MASQUERADE
        post-down iptables -t nat -D POSTROUTING -s '10.10.10.0/24' -o enp0s31f6 -j MASQUERADE 
        
        post-up   iptables -t raw -I PREROUTING -i fwbr+ -j CT --zone 1  
        post-down iptables -t raw -D PREROUTING -i fwbr+ -j CT --zone 1

Then do this for port forwarding. This forwards port 8188 to 80 to virtual machine at address 10.10.1.10, assuming your public IP is 213.214.215.216

    iptables -t nat -A PREROUTING -p tcp --dport 8188 -j DNAT --to-destination 10.10.1.10:80
    iptables -t nat -A POSTROUTING -p tcp --sport 80 -s 10.10.1.10 -j SNAT --to-source 101.102.103.104:8188



Then install Nginx Reverse Proxy. First we need Docker

https://docs.docker.com/engine/install/debian/

Then install Nginx Proxy Manager using docker compose

https://nginxproxymanager.com/guide/

    mkdir /root/nginxproxymanager
    cd /root/nginxproxymanager
    nano docker-compose.yml

Create this file

    version: '3'
    services:
    app:
    image: 'jc21/nginx-proxy-manager:latest'
    restart: unless-stopped
    ports:
    - '80:80'
      - '81:81'
      - '443:443'
      volumes:
      - ./data:/data
      - ./letsencrypt:/etc/letsencrypt

Then run it

    docker-compose up -d


Add a Proxy Host with https and your public IP and port 8006.

We can now access it directly! Get an ACME cert

Add Websocket support for VNC support.


# Add a NAT Network

Thanks to [this](https://computingforgeeks.com/how-to-create-and-configure-bridge-networking-for-kvm-in-linux/?utm_source=pocket_saves)



------------


root@proxmox ~ # pvcreate /dev/md3
WARNING: ext4 signature detected on /dev/md3 at offset 1080. Wipe it? [y/n]: y
Wiping ext4 signature on /dev/md3.
Physical volume "/dev/md3" successfully created.
root@proxmox ~ # vgcreate vg0 /dev/md3
Volume group "vg0" successfully created
root@proxmox ~ # lvcreate -n vms -l 100%FREE vg0
Logical volume "vms" created.
root@proxmox ~ # mkfs.ext4 /dev/vg0/vms
mke2fs 1.46.5 (30-Dec-2021)
Discarding device blocks: done                            
Creating filesystem with 99695616 4k blocks and 24928256 inodes
Filesystem UUID: 67389954-1f1c-45a9-bc7c-de5b72549041
Superblock backups stored on blocks:
32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208,
4096000, 7962624, 11239424, 20480000, 23887872, 71663616, 78675968

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (262144 blocks): done
Writing superblocks and filesystem accounting information: done     
