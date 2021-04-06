# Automated Falcon workflow

The Falcon workflow can be automated with Ansible. The below is a demo 
of how it works.

## Demo steps

### Git clone this repository
	
	git clone https://github.com/audreystott/ansible-falcon.git
	cd ansible-falcon

### Download your data

If wanting to use your own data, download them to the ~/ansible-falcon/falcon directory.

### Run the following Ansible script

	ansible-playbook ansible.yaml –i vars_list

