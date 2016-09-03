all: demo

build-demo:
	vagrant up --provision
	vagrant reload
	vagrant provision
	vagrant snapshot save clean
	# now run dsc against the node

clean:
	vagrant snapshot restore clean --no-provision

backup-plan:
	vagrant snapshot restore backup_plan --no-provision

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
