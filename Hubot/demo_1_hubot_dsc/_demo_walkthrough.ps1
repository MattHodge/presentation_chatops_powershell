################
# DEMO 1 - Bring Bot Online
################

# RUN FROM Hubotserver
# Run from adminstrative prompt

# Stop the Hubot service
Stop-Service -Name Hubot_bender

# Check environment variables
Get-ChildItem env:

# set correct slack token - get it via Slack Web site
$env:HUBOT_SLACK_TOKEN = 'GET SLACK TOKEN'

# Start the bot
cd C:\myhubot
npm start

# test the bot
@bender help
@bender pug me

################
# DEMO 2 - Community Scripts
################

# Install npm package
npm install hubut-hackernews --save

# Look at package.json
cat C:\myhubot\package.json

# Add to ‘hubot-hackernews’ external scripts
notepad C:\myhubot\external-scripts.json

################
# DEMO 3 - Create Custom Script
################

# stop the bot. Add custom script
notepad C:\myhubot\scripts\getprocess.coffee

@bender help
@bender get process explorer
@bender get process svchost
@bender get process xxxxx

# make it more pretty

# open shutdown.coffee in atom

# Copy over shutdown.coffee
Copy-Item -Path 'C:\vagrant\shutdown.coffee' -Destination 'C:\myhubot\scripts'

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
# Use atom to edit shutdown.coffee

# Copy trello script
Copy-Item -Path 'C:\vagrant\trello.*' -Destination 'C:\myhubot\scripts'

# Start the bot with the new script
npm start

@bender: help
@bender: trello boards

# Set API Keys
(from .env file)

npm start

# try again
@bender: trello boards

# add a card
@bender trello add Go to Dutch PowerShell User Group | Website @ http://dupsug.com/

# stop hubot on Windows
