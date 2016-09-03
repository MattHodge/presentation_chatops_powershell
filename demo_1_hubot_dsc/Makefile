all: prep_demo

buil_demo:
	vagrant up --provision
	vagrant reload
	vagrant provision
	vagrant snapshot save clean
	# now run dsc against the node

prep_demo:
	vagrant snapshot restore clean --no-provision

purge:
	vagrant destroy -f
