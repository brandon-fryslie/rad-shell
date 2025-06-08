# Cross-platform get path
rad-realpath() {
  local f base dir
  set +e

  f=$@
  [ -d "$f" ] && {
    base=""
    dir="$f"
  }
  [ ! -d "$f" ] && {
    base="/$(basename "$f")"
    dir=$(dirname "$f")
  }
  dir="$(cd "${dir}" && /bin/pwd)"
  echo "${dir}${base}"
}

# Add a directory to the path only if it's not already there
rad-addpath() {
  local new_path=$1
  local add_last=${2:-false}

  # Check if the new path is provided
  if [[ -z "$new_path" ]]; then
    rad-red "Usage: rad-addpath <path>"
    return 1
  fi

  # Check if the new path is already in $PATH
  if [[ ":$PATH:" != *":$new_path:"* ]]; then
    if [[ "${add_last}" == "true" ]]; then
      export PATH="$PATH:$new_path"
    else
      export PATH="$new_path:$PATH"
    fi
  fi
}

# Deduplicate the $PATH variable safely
rad-dedupe-exec-path() {
  # Use a temporary variable to store deduplicated PATH
  new_path=""
  seen=" "

  # Split PATH using ':' and iterate over each directory
  IFS=':' set -f # Disable globbing
  for dir in $PATH; do
    # Ensure the directory is not empty and not already seen
    if [ -n "$dir" ] && ! echo "$seen" | grep -q " $dir "; then
      new_path="${new_path:+$new_path:}$dir"
      seen="$seen$dir "
    fi
  done
  unset IFS; set +f # Restore IFS and globbing

  # Only update PATH if it changed
  if [ "$new_path" != "$PATH" ]; then
    export PATH="$new_path"
  fi
}
