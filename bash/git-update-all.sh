#!/bin/bash

# Function to print the branch name in green
print_green() {
  printf "\033[32m%s\033[0m\n" "$1"
}

# Function to print the branch name in yellow
print_yellow() {
  printf "\033[33m%s\033[0m\n" "$1"
}

# Function to print the branch name in red
print_red() {
  printf "\033[31m%s\033[0m\n" "$1"
}

# Iterate over all subdirectories
for d in */ ; do
  # Enter the subdirectory
  cd "$d"

  # Check if it is a git repository
  if git rev-parse --git-dir > /dev/null 2>&1; then
    # Get the current branch name
    branch=$(git rev-parse --abbrev-ref HEAD)

    # Check if there are any changes in the working directory
    if git diff-index --quiet HEAD; then
      # No changes, so check out the master branch if not already on it
      if [ "$branch" != "master" ]; then
        git checkout master > /dev/null
      fi
      # Pull the latest changes
      if git pull > /dev/null; then
        # Print success message in green
        print_green "Successfully updated $d ($branch)"
      else
        # Print error message in red
        print_red "Failed to update $d ($branch)"
      fi
    else
      # Changes in the working directory, so don't pull
      # Get the number of changed files
      num_changes=$(git diff --name-only | wc -l)
      # Print warning message in yellow
      print_yellow "Working directory changes in $d ($branch, $num_changes file(s) changed)"
    fi
  fi

  # Return to the parent directory
  cd ..
done
