# IP List Status Check

Test IP addresses online/offline status for example from /etc/hosts.

## Usage

```
[OPTIONS] ip-list-status-check
```
## Usage examples

### Set the IPs list source file

```
IP_SOURCE='/etc/hosts' ip-list-status-check
```

### Use RegExp to find target set of IPs

```
LOCAL_IP_PREFIX='^10\.10\.10\.' ip-list-status-check
```

### Print help

```
ip-list-status-check --help|help
```

## Example of check result

```
---------------------------------
- PROGRAM: ip-list-status-check -
---------------------------------
-                               -
- IP Address		Status      -
- ............................. -
- 10.10.10.1		Online      -
- 10.10.10.2		Online      -
- 10.10.10.3		Online      -
- 10.10.10.4		Online      -
- 10.10.10.5		Offline     -
- 10.10.10.6		Online      -
- 10.10.10.10		Offline     -
- 10.10.10.11		Online      -
- 10.10.10.12		Online      -
- 10.10.10.20		Online      -
- 10.10.10.21		Online      -
- 10.10.10.22		Online      -
.................................
- SCRIPT END                    -
---------------------------------
```
