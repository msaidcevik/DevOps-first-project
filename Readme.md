# The application is deployed in a container on AWS EC2 with Terraform and Jenkins manages this process.

## Create and configure Jenkins Server
```txt
Instance Type: t2.micro
AMI: Amazon Linux 2
Security Groups: 22, 80, 8080
```
- Install `jenkins`, `docker`, `docker-compose` and `awscli2` in Jenkins Server.
- Create a `Role` about `AmazonEC2FullAccess` on the `Jenkins Server`. Go `Action > Security > Modify IAM Role` and attach role `AmazonEC2FullAccess`.

- Connect `Jenkins Sever` and go to the `Manage Jenkins > Manage Plugins` and install the following.
```txt
locale
Deploy to container 
Docker 
Terraform
SSH-Agent
```
- Configure `Terraform` and `Docker` in `Global Tool Configuration`  

    - `Terraform` 
        - Name: `terraform-01`
        - Install directory: `/usr/bin`

    ![conf-tf](./terraform.png)

    
    - `Docker`
        - Name: `docker`
        - Install directory: `/usr/bin`

    ![conf-docker](./docker.png)

- Manage Credentials
    - Kind: `SSH Username with private key`
    - ID: `ec2-firstkey`
    - Username: `ec2-user`
    - Copy private key

    - Kind: `Username and password`
    - Username: `project`
    - Password: `12345`
    - Description: `github`






