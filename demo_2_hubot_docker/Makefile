all: demo

demo:
	docker-compose up

build-demo:
	vagrant up --provision
	vagrant reload
	vagrant provision
	vagrant snapshot save clean

clean:
	vagrant snapshot restore clean --no-provision

purge:
	vagrant destroy -f

halt:
	vagrant halt

known_hosts:
	cat ~/.ssh/known_hosts | grep 172.28.128.200  || true

ps-ssh:
	cat ~/.ssh/known_hosts | grep -v 172.28.128.200 > ~/.ssh/known_hosts_tmp || true
	rm ~/.ssh/known_hosts
	mv ~/.ssh/known_hosts_tmp ~/.ssh/known_hosts
	powershell -Command '& { \
		$$s = New-PSSession -HostName 172.28.128.200 -UserName vagrant -KeyPath /Users/Matthew/.ssh/powershell_win2012 ; \
		Invoke-Command -Session $$s -ScriptBlock { Write-Output "Remote PC: $$($$env:ComputerName)" } ; \
		Invoke-Command -Session $$s -ScriptBlock { Write-Output "Remote PS Version: $$($$PSVersionTable.PSVersion)" } \
	}'

docker_coding:
	docker-compose stop
	docker-compose rm -f
	docker-compose up -d
	docker-compose logs -f

help:
	@echo "    demo"
	@echo "        Runs hubot in docker"
	@echo "    build-demo"
	@echo "        Prepares the demo environment"
	@echo "    purge"
	@echo "        Destroy VMs and remove SSH key"
	@echo "    halt"
	@echo "        Stop VMs"
	@echo "    ps-ssh"
	@echo "        Test PowerShell over SSH"
	@echo "    known_hosts"
	@echo "        See if box is in known_hosts"
