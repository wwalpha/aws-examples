locals {
  raw_etl = <<EOT
import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job

args = getResolvedOptions(sys.argv, ["JOB_NAME"])
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args["JOB_NAME"], args)

# Script generated for node S3 bucket
S3bucket_node1 = glueContext.create_dynamic_frame.from_catalog(
    database="glue-raw-db",
    table_name="pkc_uploads_376965",
    transformation_ctx="S3bucket_node1",
)

# Script generated for node ApplyMapping
ApplyMapping_node2 = ApplyMapping.apply(
    frame=S3bucket_node1,
    mappings=[
        ("encounter_id", "long", "encounter_id", "long"),
        ("patient_nbr", "long", "patient_nbr", "long"),
        ("race", "string", "race", "string"),
        ("gender", "string", "gender", "string"),
        ("age", "string", "age", "string"),
        ("weight", "string", "weight", "string"),
        ("admission_type_id", "long", "admission_type_id", "long"),
        ("discharge_disposition_id", "long", "discharge_disposition_id", "long"),
        ("admission_source_id", "long", "admission_source_id", "long"),
        ("time_in_hospital", "long", "time_in_hospital", "long"),
        ("payer_code", "string", "payer_code", "string"),
        ("medical_specialty", "string", "medical_specialty", "string"),
        ("num_lab_procedures", "long", "num_lab_procedures", "long"),
        ("num_procedures", "long", "num_procedures", "long"),
        ("num_medications", "long", "num_medications", "long"),
        ("number_outpatient", "long", "number_outpatient", "long"),
        ("number_emergency", "long", "number_emergency", "long"),
        ("number_inpatient", "long", "number_inpatient", "long"),
        ("diag_1", "string", "diag_1", "string"),
        ("diag_2", "string", "diag_2", "string"),
        ("number_diagnoses", "long", "number_diagnoses", "long"),
        ("max_glu_serum", "string", "max_glu_serum", "string"),
        ("a1cresult", "string", "a1cresult", "string"),
        ("metformin", "string", "metformin", "string"),
        ("repaglinide", "string", "repaglinide", "string"),
        ("nateglinide", "string", "nateglinide", "string"),
        ("chlorpropamide", "string", "chlorpropamide", "string"),
        ("glimepiride", "string", "glimepiride", "string"),
        ("acetohexamide", "string", "acetohexamide", "string"),
        ("glipizide", "string", "glipizide", "string"),
        ("glyburide", "string", "glyburide", "string"),
        ("tolbutamide", "string", "tolbutamide", "string"),
        ("pioglitazone", "string", "pioglitazone", "string"),
        ("rosiglitazone", "string", "rosiglitazone", "string"),
        ("acarbose", "string", "acarbose", "string"),
        ("miglitol", "string", "miglitol", "string"),
        ("troglitazone", "string", "troglitazone", "string"),
        ("tolazamide", "string", "tolazamide", "string"),
        ("examide", "string", "examide", "string"),
        ("citoglipton", "string", "citoglipton", "string"),
        ("insulin", "string", "insulin", "string"),
        ("glyburide-metformin", "string", "glyburide-metformin", "string"),
        ("glipizide-metformin", "string", "glipizide-metformin", "string"),
        ("glimepiride-pioglitazone", "string", "glimepiride-pioglitazone", "string"),
        ("metformin-rosiglitazone", "string", "metformin-rosiglitazone", "string"),
        ("metformin-pioglitazone", "string", "metformin-pioglitazone", "string"),
        ("change", "string", "change", "string"),
        ("diabetesmed", "string", "diabetesmed", "string"),
        ("readmitted", "string", "readmitted", "string"),
    ],
    transformation_ctx="ApplyMapping_node2",
)

# Script generated for node S3 bucket
S3bucket_node3 = glueContext.getSink(
    path="s3://pkc-uploads-376965",
    connection_type="s3",
    updateBehavior="UPDATE_IN_DATABASE",
    partitionKeys=[],
    compression="gzip",
    enableUpdateCatalog=True,
    transformation_ctx="S3bucket_node3",
)
S3bucket_node3.setCatalogInfo(catalogDatabase="glue-raw-db", catalogTableName="test001")
S3bucket_node3.setFormat("csv")
S3bucket_node3.writeFrame(ApplyMapping_node2)
job.commit()
EOT
}
