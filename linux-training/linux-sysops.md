# Linux Training - Sysops 

## DevSecOps Training Journal

> **Environment:** Ubuntu 26.04 LTS (Resolute Raccoon) running on Multipass VM (`devsecops`)

---

## 1. Process Signals & Killing Processes

Linux uses **signals** to communicate with running processes.

| Signal | Command | Meaning |
|--------|---------|---------|
| SIGTERM | `kill $PID` | Politely ask the process to stop (default) |
| SIGKILL | `kill -9 $PID` | Force-kill immediately  no cleanup |

**Best practice:** Always try SIGTERM first, wait a few seconds, then escalate to SIGKILL if needed.

```bash
kill $PID       # Send SIGTERM  graceful shutdown
kill -9 $PID    # Send SIGKILL  force kill
```
nohup ./long-script.sh &

---

## 3. Package Management (APT)
Ubuntu uses `apt` as its package manager. The workflow is always:

update  install/upgrade  autoremove
```

### Essential Commands
```bash
sudo apt update                    # Refresh package index (ALWAYS do this first)
sudo apt upgrade -y                # Upgrade all installed packages
sudo apt install <package_name>    # Install a package
sudo apt remove <package_name>     # Remove a package (keep config files)
sudo apt purge <package_name>      # Remove package + config files
sudo apt autoremove                # Clean up unused dependencies
apt list --upgradable              # Show packages with available upgrades
```

### Package Managers by Distro

| Distro | Package Manager | Install Command |
|--------|----------------|-----------------|
| Ubuntu/Debian | `apt` / `apt-get` | `sudo apt install <pkg>` |
| Ubuntu (Snaps) | `snap` | `sudo snap install <pkg>` |
### Viewing Install History

cat /var/log/apt/history.log     # See past apt install/upgrade actions
```

### Today's Upgrade

Ran `sudo apt update` and `sudo apt upgrade -y`  upgraded **38 packages** and installed **7 new dependencies**, including:

- `linux-image-7.0.0-15-generic` (kernel update)
- `vim`, `curl`, `rsync`, `jq`, and more

>  **Note:** After a kernel upgrade, a system reboot is required to load the new kernel.

---

## 4. Disk Usage & Filesystems

### Key Commands

```bash
df -h              # Show disk space usage (human-readable)
du -sh             # Show size of current directory
du -sh /var/log    # Show size of a specific directory
lsblk              # List block devices (disks and partitions)
```

### Disk Layout (this machine)

```
NAME    SIZE  MOUNTPOINT
sda       5G  (disk)
sda1  3.9G  /            root filesystem (68% used)
sda13   1G  /boot
sda15 106M  /boot/efi
```

> **Tip:** `df -h` shows filesystem-level usage. `du -sh` digs into folder-level usage. Use both together to track down what's eating disk space.

---

## 5. Networking Basics

### Key Commands

```bash
ip addr                  # Show network interfaces and IP addresses
ping google.com          # Test connectivity (runs until Ctrl+C)
ping google.com -c5      # Ping exactly 5 times
ping localhost           # Test loopback interface
```

> **Note:** `ifconfig` is deprecated on modern Ubuntu. Use `ip addr` instead. Install `net-tools` if you need it: `sudo apt install net-tools`

### Network Interfaces (this machine)

```
lo      127.0.0.1       Loopback (internal)
eth0    172.29.37.2     Main network interface (DHCP)
```

---

## 6. Installing nginx (Web Server)

```bash
sudo apt install nginx
```

After installation, nginx starts automatically. The default web root is:

```
/var/www/html/index.nginx-debian.html
```

**Test it's working:**

```bash
ping localhost            # Confirms network stack is up
curl http://localhost     # Fetch the nginx default page
```

---

## Key Takeaways

- Always `sudo apt update` before installing or upgrading anything
- Use `kill` (SIGTERM) before `kill -9` (SIGKILL)  give processes a chance to clean up
- `&` sends a process to the background; `fg`, `bg`, and `jobs` manage it
- `df -h` for disk space, `lsblk` for disk layout, `ip addr` for network info
- After a kernel upgrade  **reboot the system**

---

*Next session: systemd, services, firewalls (ufw), and more networking.*sda14   4M  (BIOS boot)
- `openssh-server` / `openssh-client`
```bash
| RHEL/CentOS | `yum` / `dnf` | `sudo yum install <pkg>` |


```


> Use `nohup` when you need a process to survive after you disconnect from the terminal.
```

```bash

**`nohup`  keep a process running after logout:**
```
Ctrl+Z              # Suspend (pause) a foreground process

fg %1               # Bring job #1 to the foreground
bg %1               # Resume a stopped job in the background
sleep 9999 &        # Start a process in the background (& = background)
jobs                # List all background jobs
---
```bash

Running processes in the background lets you multitask in the same terminal session.


## 2. Background Jobs & Job Control

