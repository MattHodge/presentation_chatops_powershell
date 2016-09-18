all: clean

demo:
	vagrant up
	vagrant reload --provision
	vagrant reload --provision
	vagrant reload --provision
	vagrant reload --provision
	vagrant snapshot save clean

clean:
	vagrant snapshot restore clean --no-provision

purge:
	vagrant destroy -f

halt:
	vagrant halt

help:
	@echo "    build-demo"
	@echo "        Build demo from scratch."
	@echo "    clean"
	@echo "        Puts the demo in the ready state."
	@echo "    backup-plan"
	@echo "        DSC config already applied to hubot server"
	@echo "    purge"
	@echo "        Destroy VMs"
	@echo "    halt"
	@echo "        Stop VMs"
