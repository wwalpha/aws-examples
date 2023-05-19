resource "aws_glue_workflow" "this" {
  name                = "glue-workflow"
  max_concurrent_runs = 1
}

resource "aws_glue_trigger" "start" {
  name              = "raw-crawler"
  type              = "ON_DEMAND"
  workflow_name     = aws_glue_workflow.this.name
  start_on_creation = false

  actions {
    crawler_name = aws_glue_crawler.raw.name
  }
}

resource "aws_glue_trigger" "raw_etl" {
  name              = "raw-etl"
  type              = "CONDITIONAL"
  workflow_name     = aws_glue_workflow.this.name
  start_on_creation = false

  predicate {
    logical = "ANY"

    conditions {
      logical_operator = "EQUALS"
      crawler_name     = aws_glue_crawler.raw.name
      crawl_state      = "SUCCEEDED"
    }
  }

  actions {
    job_name = aws_glue_job.raw_etl.name
  }
}

resource "aws_glue_trigger" "refined_crawler" {
  name              = "refined-crawler"
  type              = "CONDITIONAL"
  workflow_name     = aws_glue_workflow.this.name
  start_on_creation = false

  predicate {
    conditions {
      job_name = aws_glue_job.raw_etl.name
      state    = "SUCCEEDED"
    }
  }

  actions {
    crawler_name = aws_glue_crawler.refined.name
  }
}
