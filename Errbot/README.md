# ChatOps with PowerShell Errbot

<!-- TOC depthFrom:2 -->

- [Installation](#installation)

<!-- /TOC -->

## Installation

Install on Windows 2016 Standard with GUI.

* Run an administrative PowerShell session:
```powershell
choco install python -version 3.5.2.20161029 -y
choco install git.install -y
```
* Close the session
* Run an administrative PowerShell session:
```powershell
cd \
git clone https://github.com/MattHodge/PSErrbot.git
cd PSErrbot
pip install -r requirements.txt
$env:SLACK_API_KEY = 'xxxx-xxxxxxxxxxxxx'
errbot
```
