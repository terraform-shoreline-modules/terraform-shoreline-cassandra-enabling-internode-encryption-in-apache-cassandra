

#!/bin/bash



# Set the desired Cassandra version here

desired_version=${VERSION}



# Check if Cassandra is already installed and what version is running

installed_version=$(cassandra -v | grep 'Cassandra' | cut -d ' ' -f 3)

if [ -z "$installed_version" ]; then

  echo "Cassandra is not installed."

  exit 1

fi



echo "Cassandra version $installed_version is currently installed."



# Check if the installed version supports internode encryption

if [[ "$installed_version" != *"-beta"* ]] && [[ "$installed_version" < "4.0" ]]; then

  echo "Cassandra version $installed_version does not support internode encryption."

  echo "Upgrading to version $desired_version..."



  # Download the desired Cassandra version

  wget https://downloads.apache.org/cassandra/$desired_version/apache-cassandra-$desired_version-bin.tar.gz



  # Extract the downloaded Cassandra version

  tar -xzf apache-cassandra-$desired_version-bin.tar.gz



  # Stop the currently running Cassandra instance

  sudo service cassandra stop



  # Replace the Cassandra installation directory with the new version

  sudo mv apache-cassandra-$desired_version /usr/share/cassandra



  # Start the new Cassandra instance

  sudo service cassandra start



  # Verify that the new version is running

  installed_version=$(cassandra -v | grep 'Cassandra' | cut -d ' ' -f 3)

  if [[ "$installed_version" != *"$desired_version"* ]]; then

    echo "Failed to upgrade to Cassandra version $desired_version."

    exit 1

  fi



  echo "Successfully upgraded to Cassandra version $desired_version."

else

  echo "Cassandra version $installed_version already supports internode encryption."

fi



exit 0