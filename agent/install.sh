#!/bin/bash

# check if script is being run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    echo "Press any key to exit..."
    read -n 1 -s
    exit
fi

setlocal

YELLOW_BG='\033[43m'
RED='\033[0;31m'
RESET='\033[0m'

echo "---Checking for dependencies---"

if command -v wget &>/dev/null; then
    echo "wget is installed"
else
    echo "wget is not installed"
    echo "Press any key to exit..."
    read -n 1 -s
    exit
fi

if command -v python3 &>/dev/null; then
    echo "python3 is installed"
else
    echo "python3 is not installed"
    echo "installing python3"
    apt-get install python3 -y
    if [ $? -eq 1 ]; then
        echo "Failed to install python3"
        echo "Press any key to exit..."
        read -n 1 -s
        exit
    else
        echo "python3 installed"
    fi
fi

if command -v pip &>/dev/null; then
    echo "pip is installed"
else
    echo "pip is not installed"
    echo "installing pip"
    apt-get install python3-pip -y
    if [ $? -eq 1 ]; then
        echo "Failed to install pip"
        echo "Press any key to exit..."
        read -n 1 -s
        exit
    else
        echo "pip installed"
    fi
fi

# check if venv module is installed
if python3 -c "import venv" &>/dev/null; then
    echo "venv module is installed"
else
    echo "venv module is not installed"
    echo "installing venv module"
    apt-get install python3-venv -y
    if [ $? -eq 1 ]; then
        echo "Failed to install venv module"
        echo "Press any key to exit..."
        read -n 1 -s
        exit
    else
        echo "venv module installed"
    fi
fi

if [ $? -eq 1 ]; then
    echo "Failed to create python virtual environment"
    echo "Press any key to exit"
    read -n 1 -s
    exit
else
    echo "Python virtual environment created"
fi

echo "Downloading requirements.txt"
wget -O requirements.txt https://raw.githubusercontent.com/VJTI-Lab-Link/Lab-Link/main/agent/requirements.txt

if [ $? -eq 0  ]; then
    echo "requirements.txt downloaded successfully"
else
    echo "Looks like requirements.txt was not downloaded successfully"
    if [ -e requirements.txt ]; then
        echo "found an old requirements.txt"
    else
        echo "requirements.txt does not exist"
        echo "Creating requirements.txt"
        touch requirements.txt
        echo "requirements.txt created"
        
        echo -e "${YELLOW_BG}${RED}Warning${RESET}: This is an empty requirements.txt file"
        echo -e "${YELLOW_BG}${RED}Warning${RESET}: This might cause errors"
        # echo "Press any key to continue..."
        # read -n 1 -s
    fi
fi

echo "Activating python virtual environment"
source venv/bin/activate

if [ $? -eq 1 ]; then
    echo "Failed to activate python virtual environment"
    echo "Press any key to exit"
    read -n 1 -s
    exit
else
    echo "Python virtual environment activated"
fi

if [ ! -s requirements.txt ]; then
    echo -e "${YELLO_BG}${RED}Warning${RESET}: Requirements.txt is empty"
    echo -e "${YELLO_BG}${RED}Warning${RESET}: Are you sure you want to continue?"
    echo -e "${YELLO_BG}${RED}Warning${RESET}: Please replace the contents of requirements.txt file with valid requirements"
    echo "Press any key to continue execution..."
    read -n 1 -s
fi

pip install -r requirements.txt

echo "Downloading agent.py"
wget -O agent.py https://raw.githubusercontent.com/VJTI-Lab-Link/Lab-Link/main/agent/agent.py

if [ $? -eq 0 ]; then
    echo "Downloaded agent.py successfully"
else
    echo "agent.py does not exist"
    echo "Looks like agent.py was not downloaded successfully"
    echo "Press any key to exit..."
    read -n 1 -s
    # exit
fi

apt install dbus-x11 -y

echo "---Installation complete---"
echo "Starting agent.py"
python3 agent.py
