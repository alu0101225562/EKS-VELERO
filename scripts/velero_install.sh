velero install \
  --provider aws \
  --plugins velero/velero-plugin-for-aws:v1.10.0 \
  --sa-annotations eks.amazonaws.com/role-arn=arn:aws:iam::1111111111:role/eks-velero-backup \
  --no-default-backup-location \
  --snapshot-location-config region=us-west-2 \
  --use-node-agent \
  --use-volume-snapshots \
  --uploader-type "restic" \
  --no-secret