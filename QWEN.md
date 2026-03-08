# Claude Code Proxy - Project Context

## Project Overview

This is a **Claude Code Proxy** project that provides a script (`clc`) to run Claude Code through an SSH tunnel and squid proxy. The main purpose is to route Claude Code traffic through a remote proxy server to bypass network restrictions.

**Main Technologies:**
- Bash shell scripting
- SSH tunneling
- HTTP proxy (squid)
- Node.js support with nvm

## Architecture

The project consists of:
- `clc` - Main proxy script that creates SSH tunnel and routes traffic through a proxy
- `install.sh` - Installation script to set up the proxy in a user's PATH
- `README.md` - Documentation
- `.claude/settings.local.json` - Claude Code specific settings

## How It Works

1. The `clc` script establishes an SSH tunnel to a remote server (`dog@vdsina`)
2. Routes traffic through a squid proxy running on the remote server
3. Sets HTTP/HTTPS proxy environment variables
4. Launches Claude Code with traffic routed through the proxy

## Key Features

- **Automated SSH Tunnel**: Creates and manages SSH tunnel to remote proxy server
- **Node.js Version Management**: Automatically switches to Node.js 20 if nvm is available
- **Smart Command Handling**: Commands like `update` and `mcp` bypass the proxy tunnel
- **Proxy Management**: Sets up environment variables for HTTP/HTTPS proxies
- **Easy Installation**: Installation script that places the binary in an appropriate PATH location

## Configuration

The script connects to `dog@vdsina` via SSH, where `vdsina` should be configured in `~/.ssh/config` with appropriate SSH keys.

## Building and Running

### Installation
```bash
# Quick installation
./install.sh

# Manual installation
mkdir -p ~/.local/bin
cp clc ~/.local/bin/
chmod +x ~/.local/bin/clc
```

### Usage
```bash
# Run Claude Code through proxy
clc

# Run Claude Code commands that bypass proxy
clc update
clc mcp
```

## Development Conventions

The project uses bash scripting with the following patterns:
- Error handling with `set -e` in the install script
- Proper stderr output using `>&2`
- Environment variable management for proxy settings
- Process management for SSH tunnel lifecycle

## Environment Requirements

- SSH access to the remote server (configured as 'vdsina' in ~/.ssh/config)
- Squid proxy running on the remote server (port 3128)
- Claude Code CLI already installed (`claude` command available)

## Security Considerations

- SSH keys should be properly set up for passwordless authentication
- The proxy tunnel routes all Claude Code traffic through the remote server
- Sensitive environment variables are properly unset before proxy setup