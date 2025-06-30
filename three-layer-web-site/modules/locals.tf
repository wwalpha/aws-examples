locals {
  db_names = tomap({
    it11 = "ith"
    it12 = "iti"
    it13 = "itj"
    it14 = "itk"
    it15 = "itl"
    it16 = "itm"
    it17 = "itn"
  })

  db_instance_class = tomap({
    it11 = "db.t3.medium"
    it12 = "db.t3.medium"
    it13 = "db.t3.medium"
    it14 = "db.t3.medium"
    it15 = "db.t3.medium"
    it16 = "db.t3.medium"
    it17 = "db.t3.medium"
  })

  app_instance_class = tomap({
    it11 = "t3a.medium"
    it12 = "t3a.medium"
    it13 = "t3a.medium"
    it14 = "t3a.medium"
    it15 = "t3a.medium"
    it16 = "c5.large"
    it17 = "t3a.medium"
  })

  origin_read_timeout = tomap({
    it11 = 30
    it12 = 30
    it13 = 30
    it14 = 30
    it15 = 60
    it16 = 30
    it17 = 30
  })

  # autoscaling_groups_proxy = var.autoscaling_groups == 0 ? [] : [aws_autoscaling_group.proxy[0].name]
  # autoscaling_groups_app   = var.autoscaling_groups == 0 ? [] : [aws_autoscaling_group.app[0].name]
  # autoscaling_groups_batch = var.autoscaling_groups == 0 || var.batch_env == false ? [] : [aws_autoscaling_group.batch[0].name]

  # rds_batch_count = var.batch_env ? var.rds_app_multi_az ? 0 : 1 : 0
  # app_batch_count = var.addition_batch ? 1 : var.batch_env ? var.autoscaling_groups : 0

  cloudfront_id = aws_cloudfront_distribution.this.id
}

