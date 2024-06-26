# polkadot-node

This repository contains Terraform configuration files to provision AWS EC2 instances and Ansible playbooks to deploy a Polkadot node on the instances. There are two approaches provided for deploying Polkadot:

1. Using a binary download and systemd service.
2. Using Docker.

## Prerequisites

Before running the Terraform and Ansible scripts, ensure you have the following prerequisites:

1. **Terraform** installed on your local machine.
2. **Ansible** installed on your local machine.
3. **AWS Account** to provide the credentials needed by Terraform/Ansible

## Files

- `main.tf`: The main Terraform configuration file for provisioning AWS EC2 instances with SSH access
- `variables.tf`: Terraform file to define variables
- `inventory.yaml`: File to list known hosts - in this case, the two EC2 instances provisioned via terraform.
- `deploy_pdn_v1.0.0yaml`: The Ansible playbook for deploying Polkadot using Docker.
- `polkadot_systemd.yaml`: The main Ansible playbook for deploying Polkadot using a binary and systemd service.
- `polkadot.service.j2`: The Jinja2 template for the Polkadot systemd service file.

## Usage

### 1. Provision EC2 Instances with Terraform

1. **Clone the repository and navigate to its directory**
2. **Configure variables**:
    Create a `terraform.tfvars` file to specify your custom configurations. This file should contain your public IP for SSH access and your SSH public key.

    Example terraform.tfvars:
    ```hcl
    public_ip = "your-public-ip/32"
    public_key = "your-ssh-public-key"
    ```
2. **Initialize Terraform**:
    ```sh
    terraform init
    ```
3. **Add your access keys**:
    ```sh
    export AWS_ACCESS_KEY_ID=<insert your aws access key id>                        
    export AWS_SECRET_ACCESS_KEY=<insert your aws secret access key>
    
4. **Apply the Terraform configuration**:

    ```sh
    terraform apply
    ```

    Type `yes` when prompted to confirm the apply. This will provision two EC2 instances.

### 2. Configure Ansible Inventory
Add the domain of the two EC2 instances, as well as the path to your private keys into the `inventory.yaml` file.
```yml
aws_cluster:
  hosts:
    pdn1:
      ansible_host: "your.ec2.host.domain"
      ansible_ssh_private_key_file: <insert path to private key>
    pdn2:
      ansible_host: "your.ec2.host.domain"
      ansible_ssh_private_key_file: <insert path to private key>
  vars:
    ansible_user: ubuntu
```

### 3. Deploy Polkadot Using Binary and Systemd Service
    
Execute the following command to run the playbook:

```sh
ansible-playbook -i inventory polkadot_systemd.yaml
```


### 4. Deploy Polkadot Using Docker
Execute the following command to run the playbook:

```sh
ansible-playbook -i inventory deploy_pdn_v1.0.0.yaml
```

## Terraform Configuration Details

### Security Groups

- **allow_ping**: Allows ICMP traffic for ping.
- **allow_ssh**: Allows SSH traffic from a specific IP address in `terraform.tfvars`

### Key Pair

- **my_keypair**: Uses a provided public key from `terraform.tfvars` for SSH access.

### EC2 Instances

- **pd_node**: Provisions two `t2.micro` instances with a 30 GB `gp3` root volume. This is what is available in the free tier.
