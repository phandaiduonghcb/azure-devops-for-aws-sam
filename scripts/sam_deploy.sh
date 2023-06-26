#!/bin/bash
echo "Current working dir: ${$PWD}"
echo "AWS ID $(aws sts get-caller-identity --query "Account" --output text)"

# Use s3api to check if the bucket exists
aws s3api head-bucket \
  --bucket "${BUCKET_NAME}" \
  --region "${AWS_DEFAULT_REGION}" \
  &>/dev/null  # Redirect error output to null

# Check the command status to determine if bucket exists or not
if [ $? -eq 0 ]; then
  echo "Bucket ${BUCKET_NAME} exists"
else
  echo "Bucket ${BUCKET_NAME} does not exist"
  aws s3 mb ${BUCKET_NAME}
fi
sam deploy --stack-name ${STACK_NAME}--template-file build/template.yaml --s3-bucket ${BUCKET_NAME} --capabilities CAPABILITY_IAM