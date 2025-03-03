# Configuration
RAD_SHELL_KV_STORE_PATH="${RAD_SHELL_KV_STORE_PATH:-$HOME/.rad-shell-db.yaml}"
RAD_SHELL_KV_STORE_BACKUP_PATH="${RAD_SHELL_KV_STORE_PATH}.bak"

# Function: Ensure storage file exists
rad-kvs-init() {
  if [[ ! -f "$RAD_SHELL_KV_STORE_PATH" ]]; then
    echo "# rad-shell storage file (human-readable YAML format)" > "$RAD_SHELL_KV_STORE_PATH"
  fi
}

# Function: Validate storage file format
rad-kvs-validate() {
  # If the file does not exist, return an error
  [[ ! -f "$RAD_SHELL_KV_STORE_PATH" ]] && return 1

  # If the file is empty, consider it valid
  if [[ ! -s "$RAD_SHELL_KV_STORE_PATH" ]]; then
    return 0
  fi

  # Check if all non-comment lines are valid key-value pairs
  while IFS= read -r line; do
    # Skip comment lines
    [[ "$line" =~ ^# ]] && continue
    # Check for valid key-value format
    [[ "$line" =~ ^[a-zA-Z0-9_-]+:\  ]] || return 1
  done < "$RAD_SHELL_KV_STORE_PATH"

  return 0
}

# Function: Backup storage file
rad-kvs-backup() {
  rad-kvs-validate || { rad-red "rad-kvs-backup: Skipping backup of invalid kvs!"; return 1; }
  [[ -f "$RAD_SHELL_KV_STORE_PATH" ]] && cp -f "$RAD_SHELL_KV_STORE_PATH" "$RAD_SHELL_KV_STORE_BACKUP_PATH"
}

# Function: Read a value by key
rad-kvs-get() {
  local key="$1"
  local value
  value=$(grep -E "^${key}:" "$RAD_SHELL_KV_STORE_PATH" | sed -E "s/^${key}: //")
  [[ -z "$value" ]] && return 1
  [[ "$RAD_SHELL_DEBUG" == "true" ]] && echo "Retrieved $key: $value" >&2  # Debugging output to stderr
  echo "$value"
}

# Function: Write a value by key
rad-kvs-set() {
  local key="$1"
  local value="$2"

  rad-kvs-backup || { rad-red "rad-kvs-set: rad-kvs-backup failed!"; return 1; }
  rad-kvs-validate || { rad-red "rad-kvs-set: rad-kvs-validate failed!"; return 1; }

  [[ "$RAD_SHELL_DEBUG" == "true" ]] && echo "Setting $key to $value" >&2  # Debugging output to stderr
  if grep -qE "^${key}:" "$RAD_SHELL_KV_STORE_PATH"; then
    sed -i '' -E "s|^(${key}:).*|\1 ${value}|" "$RAD_SHELL_KV_STORE_PATH"
  else
    echo "${key}: ${value}" >> "$RAD_SHELL_KV_STORE_PATH"
  fi

  rad-kvs-validate || { mv "$RAD_SHELL_KV_STORE_BACKUP_PATH" "$RAD_SHELL_KV_STORE_PATH"; return 1; }
}

# Function: Get an item from an associative array
rad-kvs-assoc-get() {
  local array_key="$1"
  local key="$2"
  rad-kvs-get "${array_key}_${key}"
}

# Function: Set an item in an associative array
rad-kvs-assoc-set() {
  local array_key="$1"
  local key="$2"
  local value="$3"
  [[ "$RAD_SHELL_DEBUG" == "true" ]] && echo "Setting associative array item ${array_key}_${key} to $value" >&2  # Debugging output to stderr
  rad-kvs-set "${array_key}_${key}" "$value"
}

# Function: Get a list (comma-separated values)
rad-kvs-list-get() {
  local key="$1"
  rad-kvs-get "$key"
}

# Function: Add an item to a list (allow duplicates) using array operations
rad-kvs-list-add() {
  local key="$1"
  local item="$2"
  local list
  list=$(rad-kvs-list-get "$key")

  [[ "$RAD_SHELL_DEBUG" == "true" ]] && echo "Adding $item to list $key" >&2  # Debugging output to stderr
  # Append the new item to the list
  if [[ -z "$list" ]]; then
    list="$item"
  else
    list="${list},${item}"
  fi

  rad-kvs-set "$key" "$new_list"
}

# Function: Remove an item from a list
rad-kvs-list-remove() {
  local key="$1"
  local item="$2"
  local list
  list=$(rad-kvs-list-get "$key")

  [[ -z "$list" ]] && return 1
  # Split the list into an array and rebuild it without the specified item
  local new_list=""
  IFS=',' read -r -a items <<< "$list"
  for i in "${items[@]}"; do
    if [[ "$i" != "$item" ]]; then
      if [[ -z "$new_list" ]]; then
        new_list="$i"
      else
        new_list="${new_list},${i}"
      fi
    fi
  done

  rad-kvs-set "$key" "$list"
}

# Initialize storage
rad-kvs-init
