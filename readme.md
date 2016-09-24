# Pre-Setup
1. Disable Franz notifcations
2. Prepare environment
```
cd ~/projectsgit/presentation_chatops_powershell/demo_1_hubot_dsc
make

cd ~/projectsgit/presentation_chatops_powershell/demo_2_hubot_docker
make

docker rm $(docker ps -aq) -f

# on hubot node:
npm install node-powershell --save
```
3. Open the presentation_chatops_powershell folder in atom
4. New Demo Channel in Slack
