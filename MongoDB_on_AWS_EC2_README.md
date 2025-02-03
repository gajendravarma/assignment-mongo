
# Deploy MongoDB on AWS EC2

This guide will walk you through deploying a MongoDB instance on an AWS EC2 instance, setting up necessary configurations

## Prerequisites

- An AWS account
- SSH key pair for EC2 access
- EC2 instance running a supported Linux OS (e.g., Ubuntu 22.04)
- Security group with proper access for SSH (port 22) and MongoDB (port 27017)

## Steps to Deploy MongoDB on AWS EC2

### 1. Launch an EC2 Instance

- Go to the [EC2 Dashboard](https://console.aws.amazon.com/ec2).
- Click **Launch Instance**.
- Choose an Amazon Machine Image (AMI). For MongoDB, an Ubuntu or Amazon Linux instance is recommended.
- Select an instance type 
- Configure instance details
- Add storage (at least 20 GB recommended).
- Configure the security group:
  - Add a rule to allow SSH (port 22) from your IP address.
  - Add a rule to allow MongoDB (port 27017) from trusted sources (IP or VPC).
- Review and launch the instance, selecting your SSH key pair.

### 2. Connect to Your EC2 Instance

Once your EC2 instance is running, SSH into it using your private key:

```bash
ssh -i /path/to/your-key.pem ubuntu@<your-ec2-public-ip>
```

### 3. Update and Install Dependencies

Update your package list and install MongoDB:

```bash
sudo apt update
sudo apt install -y mongodb
```

### 4. Start and Enable MongoDB Service

Start the MongoDB service and enable it to start on boot:

```bash
sudo systemctl start mongodb
sudo systemctl enable mongodb
```

Check the status of MongoDB to ensure it’s running:

```bash
sudo systemctl status mongodb
```

### 5. Secure MongoDB 

# To bind MongoDB to only listen to local connections and secure it with authentication:

- Edit the MongoDB configuration file:

  ```bash
  sudo nano /etc/mongodb.conf
  ```

- Uncomment and modify the following line to bind MongoDB to localhost:

  ```bash
  bindIp: 127.0.0.1
  ```

- access db from other servres
    ```bash
  bindIp: 0.0.0.0
  ```

- Restart MongoDB:

  ```bash
  sudo systemctl restart mongodb
  ```

### 6. Configure Firewall for Remote Access

If you need to access MongoDB remotely, adjust the security group to allow inbound traffic on port 27017. Alternatively, configure the firewall on the EC2 instance to accept external connections.

### 7. Verify Remote Access 

To connect to MongoDB remotely, use the following connection string:

```bash
mongos --host <your-ec2-public-ip> --port 27017 -u admin -p yourpassword --authenticationDatabase admin
```

### 8. Set Up Automatic Backups

To ensure your MongoDB data is backed up, you can use AWS services like S3 for storing backups. Install `mongodump` and set up a cron job to back up your database.

- Create Backup Script (/home/ubuntu/mongo_backup.sh)

```bash
#!/bin/bash
TIMESTAMP=$(date +%F-%H%M)
BACKUP_DIR="/home/ubuntu/mongo_backups"
mkdir -p $BACKUP_DIR
mongodump --out $BACKUP_DIR/mongodump-$TIMESTAMP
#find $BACKUP_DIR -type d -mtime +7 -exec rm -rf {} \;  # Delete backups older than 7 days(this is for optional)
```

-Example cron job for daily backup:

```bash
crontab -e
```

Add the following line:

```bash
*/30 * * * * /home/ubuntu/mongo_backup.sh >> /var/log/mongo_backup.log 2>&1
```

# conclusion
Above steps are  lauch EC2 instance , install mongodb, add security group for access mongodb, Remote access and backups




