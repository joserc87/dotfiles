# Define a timestamp function
timestamp() {
  date +"%Y-%m-%d_%H-%M-%S.%3N"
}

echo "L $(timestamp)" >> ~/lock.log
echo "U $(timestamp)" >> ~/lock.log
echo "L $(timestamp)" >> ~/lock.log
echo "U $(timestamp)" >> ~/lock.log
