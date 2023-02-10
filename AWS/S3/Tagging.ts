import * as AWS from "aws-sdk";
import * as fs from "fs";

const s3 = new AWS.S3({ apiVersion: "2006-03-01" });
const bucket = "test-bucket";
const obj = "test-tags.json";
const testKey = "testTag";

async function upload(file: string): Promise<void> {
  const params = {
    Bucket: bucket,
    Key: obj,
    Body: fs.createReadStream(file),
  };

  await s3.upload(params).promise();
}

async function getTagValue(): Promise<string> {
  const tagParams: AWS.S3.Types.GetObjectTaggingRequest = {
    Bucket: bucket,
    Key: obj,
  };
  const res = await s3.getObjectTagging(tagParams).promise();
  const value = res.TagSet.find((tag) => tag.Key === testKey).Value;
  return value;
}

async function updateTagValue(newValue: string): Promise<void> {
  const tagParams: AWS.S3.Types.PutObjectTaggingRequest = {
    Bucket: bucket,
    Key: obj,
    Tagging: {
      TagSet: [{ Key: testKey, Value: newValue }],
    },
  };
  await s3.putObjectTagging(tagParams).promise();
}

async function main() {
  // await upload("files/test.json");
  // return;

  await updateTagValue("value 1");
  let currentValue = await getTagValue();
  console.log("Value:", currentValue);
  await updateTagValue("value 2");
  currentValue = await getTagValue();
  console.log("Value:", currentValue);
}

main();

async function deleteTagSet() {
  const deleteTagParams = {
    Bucket: bucket,
    Key: obj,
  };
  await s3.deleteObjectTagging(deleteTagParams).promise();
}
