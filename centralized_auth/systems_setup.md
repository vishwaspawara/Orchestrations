This is documentation of setting up Centralized Authentication using Remote Database Server.

Two Types of devices will be used in this system - 
- Server (will hold user Database)
- Client 

For this project both devices are Debian-Net-inst. 

#### Server System (S0) Setup 

Edit following files - 
1. `/etc/network/interfaces` add static IP
2. install `postgresql` and configure user
3. add custom scripts required in `login` and `su` of client to home of `postgres` user
- `pam_check`
- `pam_login`



#### Client System (Ci) Setup 

Edit following files - 
1. `/etc/network/interfaces` add static IP
2. `/etc/pam.d/login` edit login script
3. `/etc/pam.d/su` edit su script
4. add custom scripts required in `login` and `su` to `/usr/local/bin/` dir
- `create_user.sh`
- `custom_auth.sh`
- `session_handle.sh`

Every `Ci` will ssh into `S0` and validate user credential for authentication.

#### Connecting `S0` and `Ci` with Bridge

`Ci` and `S0` are emulated using `QEMU` connection is `bridge` 


## Setup 

#### Setup Requirements

This project separates **authentication** from the local machine by validating credentials against a remote PostgreSQL-backed authentication server.

User data remains local to the client system.

> Centralized Authentication, not Centralized Storage.


### Required Components

#### Virtual Machines

* `users` — client system
* `postgre` — authentication database server

Both systems are Debian Netinst based QEMU images.


### Required Scripts

```bash
start
install
session_handler.sh
create_user.sh
custom_auth.sh
```

All required configuration files and scripts are available inside:

```bash
sys_setup/
```

#### Initialization

After placing all files in a single directory:

```bash
./start
./install
```

#### Network Layout

| Component                | Address      |
| ------------------------ | ------------ |
| Bridge (`br0`)           | `172.20.0.1` |
| PostgreSQL Server (`S0`) | `172.20.0.4` |
| Client (`Ci`)            | `172.20.0.5` |

Access the authentication server:

```bash
ssh postgres@172.20.0.4
```

#### PAM Integration

The authentication flow is integrated into Linux PAM.

Files Modified

##### `/etc/pam.d/login`

Used during initial login.

Custom authentication hooks are added near the beginning of the file.


##### `/etc/pam.d/su`

Used when switching users with `su`.

Custom authentication hooks are inserted within the authentication section.


#### Custom PAM Scripts

The following scripts must exist on the client system:

```bash
/usr/local/bin/create_user.sh
/usr/local/bin/custom_auth.sh
/usr/local/bin/session_handler.sh
```

#### Purpose

| Script               | Role                                                       |
| -------------------- | ---------------------------------------------------------- |
| `custom_auth.sh`     | Validates credentials against remote authentication server |
| `create_user.sh`     | Creates local users after successful authentication        |
| `session_handler.sh` | Handles user session setup/cleanup                         |

> `custom_auth.sh` requires PAM `expose_authtok` support to access authentication tokens.

All scripts are available inside `sys_setup/`.

