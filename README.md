# ENSC151

## Homebrew Installation Instructions

Open Terminal and type following commands ONE by ONE

> Install "Homebrew"

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

> Now, we need to let MacOs Terminal know where is brew application located (By executing following commands, we add a PATH to "Homebrew" application in SHELL PATH)

```bash
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
```

> Type in following command so that you don't have to restart Terminal Application

```bash
eval "$(/opt/homebrew/bin/brew shellenv)"
```

## Install Git

> Type following command to install Git on your Mac

```bash
brew install git
```

## Running Automation Script

> Run Automation Script to setup Eclipse IDE on your M1 Mac

```bash
cd ~/Downloads
git clone https://github.com/jenish-rudani/ENSC151 ENSC151_M1_Mac_UbuntuSetup
cd ENSC151_M1_Mac_UbuntuSetup
chmod +x arm64-ensc151sw.sh
./arm64-ensc151sw.sh
```

## Restart your MAC
> Do not forget to restart!!

```bash
sudo shutdown -r now
```

