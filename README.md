# Ansible Version Manager (AVM)
[![Build Status](https://travis-ci.org/ahelal/avm.svg?branch=master)](https://travis-ci.org/ahelal/avm)

Ansible Version Manager (AVM) is a tool to manage multi Ansible installation by creating a python virtual environment for each version.

## Why
* Running multiple version of Ansible on the same host.
* Using the development version of ansible for testing and using stable version for production.
* Make your CI run multiple versions for testing i.e. travis, concourse, jenkins, ... or test-kitchen or molecule.
* Create a wrapper script to manage Ansible within your teams and make upgrading roll back easier for many users with different OS and shells.
* If you need add python packages to and make it accessible to Ansible without effecting your global python installation. i.e. boto, dnspython, netaddr or others

## Incompatibly as of 1.0.0 version
* Change in variable names
* Stopped using bash arrays ```i.e. ANSIBLE_VERSIONS[0]``` to be more Posix and use flat variables ```i.e. ANSIBLE_VERSIONS_0```

For more info check [Setup variable](Setup variable)

## How

You have two options using a **setup script** or **command** to install

### Setup wrapper script
Create a wrapper script this would be useful for CI or if you want your team to have unified installation.

```bash
#!/bin/sh
set -e

## This is an example setup script that you would encapsulate the installation
# What version of avm setup to use
AVM_VERSION="v1.0.0"
## Install Ansible 1.9.6 using pip and label it 'v1'
export ANSIBLE_VERSIONS_0="1.9.6"
export INSTALL_TYPE_0="pip"
export ANSIBLE_LABEL_0="v1"
## Install Ansible 2.1.1 using pip and label it 'v2'
export ANSIBLE_VERSIONS_1="2.1.1.0"
export INSTALL_TYPE_1="pip"
export ANSIBLE_LABEL_1="v2"
## Install Ansible devel using git and label it 'devel'
export ANSIBLE_VERSIONS_2="devel"
export INSTALL_TYPE_2="git"
export ANSIBLE_LABEL_2="devel"
# Whats the default version
ANSIBLE_DEFAULT_VERSION="v2.1"

## Create a temp dir to download avm
avm_dir="$(mktemp -d 2> /dev/null || mktemp -d -t 'mytmpdir')"
git clone https://github.com/ahelal/avm.git "${avm_dir}" > /dev/null 2>&1
/bin/sh $${avm_dir}/setup.sh

## Run the setup
. $my_temp_dir/setup.sh
# You can do other stuff here like install other tools for your team
exit 0
```

### Setup Command
You would need first to install avm
```bash
git https://github.com/ahelal/avm.git
cd avm
./setup.sh
```

then you can use the avm cli to install
```bash
# Install stable release (defaults to pip)
avm install --version 2.2.0.0 --label production

# Install development release
avm install --version devel --label dev --type git

# if you have some python lib to install in the virtual env you can also add python requirements.txt file
avm install --version 2.0.0.0 --label legacy --requirements /path/to/requirements.txt
```

### avm command usage
Once install you can use *avm* the cli to switch between version. for more info run **avm --help**
```
Usage:
    avm  info
    avm  list
    avm  path <version>
    avm  use <version>
    avm  activate <version>
    avm  install (-v version) [-t type] [-l label] [-r requirements]

Options:
    info                        Show ansible version in use
    list                        List installed versions
    path <version>              Print binary path of specific version
    use  <version>              Use a <version> of ansible
    activate <version>          Activate virtualenv for <version>
```

## Setup variable

If you are using [Setup wrapper script](Setup wrapper script) you can change override any of the following variables in your script

| Name | default | Description |
|----------------------|---------|-----------------------------------------------------------------------------------------------------------------------------------------------------------|
| AVM_VERSION | master | avm version to install. Supports releases, tags, branches. if set to "local" will use will use pwd instead of downloading from github good for debugging. |
| AVM_VERBOSE |  | Setup verbosity could be empty or v or vv |
| SETUP_USER | $USER | The user that will have avm |
| SETUP_USER_HOME | $USER home dir | The home dir of user  |
| AVM_IGNORE_SUDO |  | Simply ignore sudo errors. |
| DEFAULT_INSTALL_TYPE | pip | Default installation type if not defined. |
| AVM_UPDATE_VENV | 0 |  |
| ANSIBLE_BIN_PATH | /usr/local/bin |  |
| ANSIBLE_VERSIONS_X |  |  |
| ANSIBLE_LABEL_X |  |  |
| INSTALL_TYPE_X |  |  |
| UBUNTU_PKGS |  |  |




## Ansible bin path it should be something in your path
ANSIBLE_BIN_PATH="${ANSIBLE_BIN_PATH:-/usr/local/bin}"

## Supported platforms
Currently tested under
* OSX
* Ubuntu 14.04, 16.04
* Alpine 3.4 (early support)

## support shells
* bash
* dash
* zsh
* busybox ash

## Alpine docker

Experimental support for Alpine in docker

if your installing for **non root** user you require
```bash
apk add sudo
echo "auth       sufficient pam_rootok.so" > /etc/pam.d/su
```

if your creating an image that does not have python or gcc you can do a cleanup at the end
```bash
apk del build-dependencies
```

## Debugging
### Level 1
Run your setup with ```AVM_VERBOSE="v" your_setup.sh```
This should give ou insight on all the goodies
### Level 2
extreme debugging
Run your setup with ```AVM_VERBOSE="vv" your_setup.sh```

## License
License (MIT)

## Contribution
Your contribution is welcome.
