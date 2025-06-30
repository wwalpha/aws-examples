# ----------------------------------------------------------------------------------------------
# EC2 Launch Template - App
# ----------------------------------------------------------------------------------------------
resource "aws_launch_template" "app" {
  name                    = "feature-honbu-${var.env_name}-app"
  disable_api_termination = false
  update_default_version  = true
  ebs_optimized           = true
  image_id                = var.ami_id_app
  instance_type           = lookup(local.app_instance_class, var.env_name)
  key_name                = "lawson_phase2"
  vpc_security_group_ids  = [var.sg_client_vpn, aws_security_group.app.id]

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size           = 100
      volume_type           = "gp3"
      encrypted             = true
      iops                  = 3000
      delete_on_termination = true
    }
  }

  iam_instance_profile {
    arn = aws_iam_instance_profile.app.arn
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "feature-honbu-app"
    }
  }
}

# ----------------------------------------------------------------------------------------------
# EC2 Launch Template - Proxy
# ----------------------------------------------------------------------------------------------
resource "aws_launch_template" "proxy" {
  name                    = "feature-honbu-${var.env_name}-proxy"
  disable_api_termination = false
  update_default_version  = true
  ebs_optimized           = true
  image_id                = var.ami_id_proxy
  instance_type           = lookup(local.app_instance_class, var.env_name)
  key_name                = "lawson_phase2"
  vpc_security_group_ids  = [var.sg_client_vpn, aws_security_group.proxy.id]

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size           = 8
      volume_type           = "gp3"
      encrypted             = true
      iops                  = 3000
      delete_on_termination = true
    }
  }

  iam_instance_profile {
    arn = aws_iam_instance_profile.app.arn
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "feature-honbu-proxy"
    }
  }
}


# ----------------------------------------------------------------------------------------------
# EC2 Launch Template - Batch
# ----------------------------------------------------------------------------------------------
resource "aws_launch_template" "batch" {
  name                    = "feature-honbu-${var.env_name}-batch"
  disable_api_termination = false
  update_default_version  = true
  ebs_optimized           = true
  image_id                = var.ami_id_batch
  instance_type           = lookup(local.app_instance_class, var.env_name)
  key_name                = "lawson_phase2"
  vpc_security_group_ids  = [var.sg_client_vpn, aws_security_group.batch.id]

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size           = 100
      volume_type           = "gp3"
      encrypted             = true
      iops                  = 3000
      delete_on_termination = true
    }
  }

  iam_instance_profile {
    arn = aws_iam_instance_profile.batch.arn
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "feature-honbu-batch"
    }
  }
}
