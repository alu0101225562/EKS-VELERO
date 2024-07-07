kubectl -n wp-mysql annotate pod/wordpress-79d68d56b9-z6dlw backup.velero.io/backup-volumes=wordpress-persistent-storage
kubectl -n wp-mysql annotate pod/wordpress-mysql-6b7b9b4c87-7vdlx backup.velero.io/backup-volumes=mysql-persistent-storage

velero restore create aks-wp-mysql-restore-no-tg --from-backup eks-wp-mysql-backup --exclude-resources targetgroupbindings