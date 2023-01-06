#!/bin/bash

# Iterate over all subdirectories
for d in */ ; do
  # Enter the subdirectory
  cd "$d"

  # Check if it is a git repository
  if git rev-parse --git-dir > /dev/null 2>&1; then
    # Check if there are any changes in the working directory
    if git diff-index --quiet HEAD; then
      # No changes, so check out the master branch
      git checkout master

      # Pull the latest changes
      if git pull; then
        # Print success message
        echo "Successfully updated $d"
      else
        # Print error message
        echo "Failed to update $d"
      fi
    else
      # Changes in the working directory, so don't pull
      echo "Working directory changes in $d, skipping pull"
    fi
  fi

  # Return to the parent directory
  cd ..
done
