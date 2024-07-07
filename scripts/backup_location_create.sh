velero backup-location create velero-s3-bucket \
  --provider aws \
  --bucket velero-s3-bucket \
  --config region=us-west-2,s3ForcePathStyle="true" \
  --default