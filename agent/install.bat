echo off
echo ---Checking for dependencies---
where curl --version >nul 2>nul
if errorlevel 1 (
    echo curl is not installed
    echo Please install curl
    echo Press any key to exit...
    pause >nul
    exit
) else (
    echo curl is installed
)
where python -version >nul 2>nul
if errorlevel 1 (
    echo python is not installed
    echo Please install python
    echo Press any key to exit
    pause >nul
    exit
) else (
    echo python is installed
)
if exist venv\ (
    echo venv exists
) else (
    echo venv does not exist
    echo creating python virtual environment
    call python -m venv ./venv
)
if errorlevel 1 (
    echo failed to activate python virtual environment
    echo Press any key to exit
    pause >nul
    exit
) else (
    echo python virtual environment created
)
echo downloading requirements.txt
curl https://raw.githubusercontent.com/Aashay-Thakur/Prototype/react/agent/requirements.txt -O
if exist requirements.txt (
    echo found requirements.txt
) else (
    echo requirements.txt does not exist
    echo looks like requirements.txt was not downloaded successfully
    echo please include requirements.txt in the same directory as install.bat
    echo Press any key to exit...
    pause >nul
    exit
)
echo activating python virtual environment
call ./venv/Scripts/activate.bat
if errorlevel 1 (
    echo failed to activate python virtual environment
    echo Press any key to exit
    pause >nul
    exit
) else (
    echo python virtual environment activated
)
echo checking if requirements are up to date
pip freeze > temp.txt
fc /b temp.txt requirements.txt > nul
if errorlevel 1 (
    echo requirements.txt is not up to date
    echo Installing requirements.txt
    pip install -r requirements.txt
    if errorlevel 1 (
        echo failed to install requirements
        echo Press any key to exit
        pause >nul
        exit
    ) else (
        echo requirements installed successfully
    )
) else (
    echo requirements are up to date
)
del temp.txt
echo downloading agent.py
curl https://raw.githubusercontent.com/Aashay-Thakur/Prototype/react/agent/agent.py -O
if exist agent.py (
    echo downloaded agent.py successfully
) else (
    echo agent.py does not exist
    echo looks like agent.py was not downloaded successfully
    echo Press any key to exit...
    pause >nul
    exit
)
echo ---Installation complete---
echo starting agent.py
python agent.py