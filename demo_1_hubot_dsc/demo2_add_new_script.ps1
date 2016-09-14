# RUN FROM Hubotserver
# Run from adminstrative prompt

# Check environment variables
Get-ChildItem env:

# Stop the Hubot service
Stop-Service -Name Hubot_demobot

# Take a look at the packages.json file
cd C:\myhubot
cat package.json

# Notice in dependencies list no 'powershell-node' package

# Create shutdown.coffee
notepad C:\myhubot\scripts\shutdown.coffee

# Install the additional package
npm install node-powershell --save

# See the change in package.json
cat package.json

# Start the bot with the new script
npm start

# Go to slack and do a help
@bender: help

# Notice the new help items in the list
@bender: restart 172.28.128.101
@bender: shutdown win2012r2
@bender: restart fakemachine

# What if we do something bad?
@bender: restart (New-Item -Path C:\test.txt)
@bender: restart (New-Item -Path C:\test.txt)

# Anyone know how to solve this problem with our script?
# Lets edit shutdown.coffee and update it.
