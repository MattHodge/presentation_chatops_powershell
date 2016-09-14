#
# FROM MAC
#
cd ~/projectsgit/presentation_chatops_powershell/demo_2_hubot_docker
docker-compose up -d

# see the bot is up
docker ps

# check inside the container
docker exec -it <id> /bin/bash

#
# FROM CONTAINER
#

# inside the container
powershell --help
powershell -Command '& { $PSVersionTable }'
powershell -Command '& { $IsLinux }'

# test SSH remoting
ssh -i /root/.ssh/my_ssh_key vagrant@172.28.128.200

# exit container
exit

# attach to see the logs
docker-compose logs -f

#
# FROM SLACK
#

@bender help
@bender get process explorer 172.28.128.200
