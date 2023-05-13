# EC2 auto join directory service domain

```
$ terraform apply -auto-approve

ec2_private_ip = "10.10.xx.xx"
```

## Login to windows using Session Manager
```
PS C:\Windows\system32> systeminfo | findstr "Domain"

Domain:                    seamlessad.local
```