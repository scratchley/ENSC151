#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

SHARED_DIR_PATH=~/Public/VMsf-22_04
SHELL_SCRIPT_TO_RUN_ON_INSTANCE=./instanceCommandsClean.sh
SSH_DIR_PATH=~/.ssh

######### Shared Directory
if [ -d $SHARED_DIR_PATH ] 
then
  echo -e "${RED}Directory $SHARED_DIR_PATH exists.${NC} [SKIPPING]" 
else
  echo -e "Creating an Empty Directory: $SHARED_DIR_PATH "
  mkdir $SHARED_DIR_PATH
  cp $SHELL_SCRIPT_TO_RUN_ON_INSTANCE $SHARED_DIR_PATH
fi

######### SSH Directory
if [ -d $SSH_DIR_PATH ] 
then
  echo -e "${RED}Directory $SSH_DIR_PATH exists.${NC} [SKIPPING]" 
else
  echo "Creating an Empty Directory: $SSH_DIR_PATH "
  mkdir $SSH_DIR_PATH
fi

######### Homebrew
if ! command -v brew &> /dev/null
then
  echo -e "${RED}Homebrew could not be found${NC}"
  echo -e "${GREEN}Installing Homebrew... (You will need Enter your PASSWORD and press ENTER)${NC}"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
  exit
else
  echo -e "${RED}Homebrew is Already Installed.${NC} [SKIPPING]"
fi

######### Xquartz
if ! command -v xquartz &> /dev/null
then
  echo -e "${RED}Xquartz could not be found${NC}"
  echo -e "${GREEN}Installing Xquartz... (Enter your PASSWORD [if asked] and press ENTER)${NC}"
  brew install --cask xquartz
  exit
else
  echo -e "${RED}Xquartz is Already Installed.${NC} [SKIPPING]"
fi

########## Multipass Installation
if ! command -v multipass &> /dev/null
then
  echo -e "${RED}multipass could not be found"
  echo -e "Installing multipass... (Enter your PASSWORD)"
  brew install multipass
  exit
else
  echo -e "${RED}Multipass is Already Installed.${NC} [SKIPPING]"
fi

########## Check if Prinary Instance installed on Multipass 
multipass list | grep 'primary' &> /dev/null
if [ $? == 0 ]; then
  echo -e "${RED}primary instance is already installed.${NC} [Need to Purge it]"
  echo -e "${RED}Purging 'primary instance'${NC}"
  multipass delete -p primary
fi

########## Create Primary Instances
echo -e "${GREEN}Creating 'primary instance'${NC}"
multipass launch 22.04 -n primary -c 4 -m 4G -d 50G 

########## SSH KeyGen
RSA_KEY_FILE_PATH=~/.ssh/id_rsa
if [[ -f "$RSA_KEY_FILE_PATH" ]]; then
  echo -e "${RED}$RSA_KEY_FILE_PATH exists.${NC}"
else
  ssh-keygen -f $RSA_KEY_FILE_PATH -t rsa -b 2048 -N ''
fi
multipass exec primary -- bash -c "echo `cat $RSA_KEY_FILE_PATH.pub` >> ~/.ssh/authorized_keys"

########## Mount $HOME on the instance
multipass mount $SHARED_DIR_PATH primary:/home/ubuntu/VMsf

########## Execute SHELL_SCRIPT_TO_RUN_ON_INSTANCE on Instance
multipass exec primary -- source /home/ubuntu/VMsf/instanceCommandsClean.sh



########## Updating and Upgrading ubuntu instance
multipass exec primary -- sudo apt-mark hold linux-image-generic linux-headers-generic grub-efi*
multipass exec primary -- sudo apt update
multipass exec primary -- sudo apt upgrade -y

########## Reboot Primary Instance for upgrade to take effect
multipass restart primary

########## Installing necessary packages inside multipass primary instance
multipass exec primary -- sudo apt install -y g++ aptitude aptitude-doc-en gcc-doc  binutils-doc make make-doc git  git-doc valgrind valgrind-dbg systemtap systemtap-doc linux-tools-generic linux-tools-common errno cpp-doc gdb-doc libboost-test-dev libboost-doc
sleep 1
multipass exec primary -- sudo snap set system refresh.retain=2
multipass exec primary -- sudo snap install cmake --classic
multipass exec primary -- sudo apt-get install -y dpkg-dev --no-install-recommends
multipass exec primary -- sudo apt install -y gtk3-binver-3.0.0 libgtk-3-dev


# don't need this
# multipass exec primary -- sudo apt install -y openjdk-8-jre # // do we need more (or less), like (only) openjdk-8-jre-headless

########## Installing Eclipse
multipass exec primary --working-directory /home/ubuntu/VMsf -- wget https://eclipse.mirror.rafal.ca/technology/epp/downloads/release/2022-06/R/eclipse-cpp-2022-06-R-linux-gtk-aarch64.tar.gz
multipass exec primary --working-directory /home/ubuntu -- tar -xvzf VMsf/eclipse-cpp-2022-06-R-linux-gtk-aarch64.tar.gz
multipass exec primary --working-directory /home/ubuntu -- rm VMsf/eclipse-cpp-2022-06-R-linux-gtk-aarch64.tar.gz
