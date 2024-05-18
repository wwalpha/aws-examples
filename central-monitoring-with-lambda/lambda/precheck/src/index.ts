import { PublishCommand, SNSClient } from '@aws-sdk/client-sns';
import { AssumeRoleCommand, STSClient } from '@aws-sdk/client-sts';
import { DescribeInstancesCommand, EC2Client } from '@aws-sdk/client-ec2';
import { S3Event, S3EventRecord, S3Handler } from 'aws-lambda';

const client = new SNSClient({ region: process.env.DEFAULT_REGION });
const stsClient = new STSClient({ region: process.env.DEFAULT_REGION });
const TOPIC_ARN = process.env.TOPIC_ARN;
const ASSUME_ROLE_NAME = process.env.ASSUME_ROLE_NAME;

// prod/334678299258/linux/i-0167ec091a184a693/config.txt
export const handler: S3Handler = async (e: S3Event) => {
  for (;;) {
    // Shift the first record from the array
    const record = e.Records.shift();

    // If there is no record, break the loop
    if (!record) {
      break;
    }

    try {
      // Call the precheck function
      await paramCheck(record);
    } catch (e) {
      console.error(e);
    }
  }
};

const paramCheck = async (record: S3EventRecord) => {
  const bucket = record.s3.bucket.name;
  const key = record.s3.object.key;
  const array = key.split('/');

  // If the array length is not 5, send an email
  if (array.length !== 5) {
    await sendMail('Precheck failed', `Bucket: ${bucket}\nKey:${key}`);
    return;
  }

  const accountId = array[1];
  const os = array[2].toUpperCase();
  const instanceId = array[3];

  // If the environment is not prod, send an email

  // If the accountId is not 12 digits, send an email
  if (accountId.length !== 12) {
    await sendMail(
      'Precheck failed',
      `Reason: Account ID is not 12 digits, please check bucket key.

      Bucket: ${bucket}
      Key:${key}
      AccountId: ${accountId}
      `
    );

    return;
  }

  // If the os is not linux or windows, send an email
  if (!(os == 'LINUX' || os == 'WINDOWS')) {
    await sendMail(
      'Precheck failed',
      `Reason: OS is not Linux or Windows, please check bucket key.

      Bucket: ${bucket}
      Key:${key}
      OS: ${accountId}
      `
    );
    return;
  }

  // If the instanceId is not 17 digits, send an email
  if (instanceId.length !== 17) {
    await sendMail(
      'Precheck failed',
      `Reason: Instance Id is not 17 digits, please check bucket key.

      Bucket: ${bucket}
      Key:${key}
      InstanceId: ${instanceId}
      `
    );

    return;
  }

  const isExist = await checkInstanceExist(bucket, key, accountId, instanceId);

  if (isExist === undefined) {
    return;
  }
};

const checkInstanceExist = async (bucket: string, key: string, accountId: string, instanceId: string) => {
  const result = await stsClient.send(
    new AssumeRoleCommand({
      RoleArn: `arn:aws:iam::${accountId}:role/${ASSUME_ROLE_NAME}`,
      RoleSessionName: 'precheck',
    })
  );

  const credentials = result.Credentials;

  // If the credentials are not returned, send an email
  if (credentials === undefined) {
    await sendMail(
      'Precheck failed',
      `Reason: Switch role failed, please check the role arn.

      RoleArn: ${accountId}
      InstanceId: ${instanceId}
      `
    );
    return false;
  }

  // Create an EC2 client
  const ec2Client = new EC2Client([
    {
      credentials: {
        accessKeyId: credentials.AccessKeyId,
        secretAccessKey: credentials.SecretAccessKey,
        sessionToken: credentials.SessionToken,
      },
    },
  ]);

  // Describe the instance
  const instance = await ec2Client.send(
    new DescribeInstancesCommand({
      InstanceIds: [instanceId],
    })
  );

  // If the instance is not returned, send an email
  if (instance.Reservations === undefined) {
    await sendMail(
      `Precheck failed: Instance does not exist [${instanceId}]`,
      `Reason: Instance does not exist, please check the instance id.

      Bucket: ${bucket}
      Key: ${key}
      Target InstanceId: ${instanceId}
      `
    );
    return false;
  }

  return true;
};

const sendMail = async (subject: string, message: string) => {
  await client.send(
    new PublishCommand({
      TopicArn: TOPIC_ARN,
      Subject: `【CWConfig】${subject}`,
      Message: message,
    })
  );
};
