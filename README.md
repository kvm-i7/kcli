<p align="center">
  <a href="https://kvm-i7.host">
    <img src="https://github.com/kvm-i7/.github/blob/main/profile/logo.png?raw=true" alt="KVM-i7 Logo" width="150">
  </a>
</p>

<h1 align="center">kcli</h1>

<p align="center">
  <a href="https://discord.gg/t3vps"><img src="https://img.shields.io/badge/Join_our_Discord-2.1K%2B_Members-5865F2?style=for-the-badge&logo=discord&logoColor=white"></a>
  <a href="https://kvm-i7.host/status.html"><img src="https://img.shields.io/badge/Service_Status-Online-23a55a?style=for-the-badge&logo=data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCAyNCAyNCIgZmlsbD0iI2ZmZiI+PHBhdGggZD0iTTEyIDE3LjI3TDQuNSAxMi41bDEuNDE0LTEuNDE0TDExIDE0LjQ0bDYuMDgtNi4wOEwxOC41IDEyLjV6Ii8+PC9zdmc+"></a>
</p>

A simple, powerful, and portable POSIX shell CLI for managing your [KVM-i7](https://kvm-i7.host) VPS.

## Features
- **Cross-Platform**: Works on Linux, macOS, and Windows (via Git Bash/WSL).
- **Lightweight**: No complex runtimes, just `curl` and `jq`.
- **Secure**: Handles your API token securely via a config file or environment variable.
- **Full API Coverage**: Implements all documented endpoints.
- **Easy to Use**: Simple, memorable commands for all major actions.

## Installation

### 1. Prerequisites
You need `curl` and `jq` installed on your system.

- **Debian/Ubuntu:**
  ```bash
  sudo apt update && sudo apt install curl jq
  ```
- **RedHat/Fedora/CentOS:**
  ```bash
  sudo dnf install curl jq
  ```
- **macOS (with Homebrew):**
  ```bash
  brew install curl jq
  ```
- **Arch Linux:**
  ```bash
  sudo pacman -S curl jq
  ```

### 2. Install kcli
You can install the script with a single command. It will be downloaded to `/usr/local/bin`, making it available system-wide.

```bash
curl -L https://raw.githubusercontent.com/kvm-i7/kcli/main/kcli -o /usr/local/bin/kcli && chmod +x /usr/local/bin/kcli
```
*You may need to prefix the command with `sudo` if you are not running as root.*

## Setup
Before you can use `kcli`, you must set your API token. You can get this token from your provider's control panel.

Run the following command, replacing `<your-token>` with your actual token:
```bash
kcli set-token <your-token>
```
This will securely store your token in `~/.kcli.conf`.

## Usage
The basic syntax is `kcli <command> [arguments]`.

### Commands
| Command             | Description                                                   |
| ------------------- | ------------------------------------------------------------- |
| `start`             | Start the VPS.                                                |
| `stop`              | Stop the VPS.                                                 |
| `status`            | Get the current power status of the VPS.                      |
| `hardware`          | Fetch hardware information (cores, ram, disk).                |
| `usage`             | Fetch current resource usage (cpu, memory).                   |
| `ssh-info`          | Fetch SSH connection details and token.                       |
| `exec "<command>"`  | Execute a command on the VPS. Must be quoted.                 |
| `reinstall-options` | List all available OS templates for reinstallation.           |
| `reinstall <tmpl>`  | Reinstall the VPS with a new OS. Use the `template` string.   |
| `help`              | Show the help message.                                        |

### Examples

**Check VPS Status**
```bash
kcli status
```

**Execute a Remote Command**
```bash
kcli exec "df -h"
```

**Reinstall the Operating System**
First, find an OS template you want to use:
```bash
kcli reinstall-options
```
The output will be a JSON array. Pick a `template` value from the list, for example `local:vztmpl/ubuntu-24.04-standard_24.04-2_amd64.tar.zst`.

Then, run the reinstall command with that template string:
```bash
kcli reinstall "local:vztmpl/ubuntu-24.04-standard_24.04-2_amd64.tar.zst"
```

### Advanced: Environment Variable
For CI/CD pipelines or other non-interactive environments, you can provide the token via the `KVM_I7_TOKEN` environment variable instead of using the config file.

```bash
export KVM_I7_TOKEN="<your-token>"
kcli status
```

## Community
Join our community on [Discord](https://discord.gg/t3vps) for support and discussion.

## License
This project is licensed under the MIT License. See the [LICENSE](https://github.com/kvm-i7/kcli/blob/main/LICENSE) file for details.

