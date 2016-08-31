all: prepare_demo

prepare_demo:
	vagrant up --provision
	vagrant reload
	vagrant provision
	vagrant snapshot save clean
	# now run dsc against the node

clean:
	vagrant snapshot restore clean --no-provision

purge:
	vagrant destroy -f
