# Centralized Authentication Service

A lightweight centralized authentication platform built using Linux, `PAM`, `PostgreSQL`, `SSH`, and `QEMU` virtualization.

This project recreates centralized authentication workflows where multiple client systems authenticate users against a remote authentication server over a private bridged network.

---

## Overview

The system consists of:

* **S0 (Server)**
  Hosts the centralized PostgreSQL user database and authentication scripts.

  * **Ci (Clients)**
    Client machines that authenticate users remotely through `PAM` hooks and custom shell scripts.

    All systems are emulated using `QEMU` and connected through a Linux bridge network.

    ---

## Project Structure

```bash
.
|-> install            # Launches QEMU virtual machines
|-> start              # Creates bridge + TAP networking
|-> notify.sh          # Host-side notification polling script
|-> n1.sh              # Remote-side polling script
|-> systems_setup.md   # Manual setup documentation
|-> sys_setup/         # Configuration files for server/client systems
```

---

## Architecture

```text
+-------------------+
|      Client       |
|   PAM + SSH Auth  |
+---------+---------+
          |
          | SSH
          |
+---------v---------+
|      Server       |
| PostgreSQL AuthDB |
+-------------------+
```

Clients authenticate users by remotely validating credentials against the centralized PostgreSQL-backed authentication server.

---

## Components

### `start`

Initializes networking:

* Creates Linux bridge `br0`
* Creates TAP interfaces (`tap0`, `tap1`, `tap2`)
* Enables IP forwarding
* Configures NAT using `iptables`

This allows isolated QEMU guests to communicate through a bridged virtual network.

---

### `install`

Launches QEMU virtual machines:

* `postgre` → authentication server
* `users` → client machine

Uses:

* `virtio` disks
* bridged TAP networking
* static MAC addresses

---

### `systems_setup.md`

Contains manual setup instructions for:

#### Server (`S0`)

* Static IP configuration
* PostgreSQL setup
* PAM helper scripts

#### Clients (`Ci`)

* PAM configuration
* Login/session hooks
* Authentication scripts

---

### `notify.sh` / `n1.sh`

Simple polling-based notification utilities that monitor a remote file over SSH and trigger actions using `dmenu`.

Used for lightweight orchestration and signaling between systems.

---

## Authentication Flow

1. User attempts login on client system
2. PAM invokes custom authentication script
3. Client connects to server over SSH
4. Server validates credentials using PostgreSQL
5. PAM session is accepted or denied
6. User/session handling scripts execute locally

---

## Technologies Used

* Linux
* QEMU
* TAP / Bridge Networking
* PAM
* PostgreSQL
* SSH
* Shell Scripting
* `iptables`

---
## Future scop 
* LVM based storage management
* Centralized directory service (LDAP like)
* Centralized home directory access


## Notes

* Built using minimal Debian Netinst systems
* Focused on understanding authentication internals and Linux networking
* Intended for experimentation and systems-level learning
* `sys_setup/` contains reusable machine configuration files

