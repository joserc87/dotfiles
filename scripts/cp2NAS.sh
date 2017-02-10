DATE_DIR=$(date +"%d.%m.%y_%H.%M.%S")
if [ ! -d /Volumes/dev/ ]; then
  mkdir /Volumes/dev
  mount_smbfs //192.168.0.45/dev /Volumes/dev
fi
mkdir /Volumes/dev/_TMP/${DATE_DIR}
cp -R $@ /Volumes/dev/_TMP/${DATE_DIR}/
