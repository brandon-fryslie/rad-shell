#!/bin/zsh

# Configuration
RAD_SHELL_KV_STORE_PATH="${RAD_SHELL_KV_STORE_PATH:-$HOME/.rad-shell-db.yaml}"
RAD_SHELL_KV_STORE_BACKUP_PATH="${RAD_SHELL_KV_STORE_PATH}.bak"

# Function: Ensure storage file exists
rad-storage-init() {
  if [[ ! -f "$RAD_SHELL_KV_STORE_PATH" ]]; then
    echo "# rad-shell storage file (human-readable YAML format)" > "$RAD_SHELL_KV_STORE_PATH"
  fi
}

# Function: Validate storage file format
rad-storage-validate() {
  [[ ! -f "$RAD_SHELL_KV_STORE_PATH" ]] && return 1
  grep -qE "^[a-zA-Z0-9_-]+: " "$RAD_SHELL_KV_STORE_PATH" || return 1
}

# Function: Backup storage file
rad-storage-backup() {
  [[ -f "$RAD_SHELL_KV_STORE_PATH" ]] && cp "$RAD_SHELL_KV_STORE_PATH" "$RAD_SHELL_KV_STORE_BACKUP_PATH"
}

# Function: Read a value by key
rad-storage-get() {
  local key="$1"
  local value
  value=$(grep -E "^${key}:" "$RAD_SHELL_KV_STORE_PATH" | sed -E "s/^${key}: //")
  echo "Retrieved $key: $value" >&2  # Debugging output to stderr
  echo "$value"
}

# Function: Write a value by key
rad-storage-set() {
  local key="$1"
  local value="$2"

  rad-storage-backup
  rad-storage-validate || return 1

  echo "Setting $key to $value" >&2  # Debugging output to stderr
  if grep -qE "^${key}:" "$RAD_SHELL_KV_STORE_PATH"; then
    sed -i '' -E "s|^(${key}:).*|\1 ${value}|" "$RAD_SHELL_KV_STORE_PATH"
  else
    echo "${key}: ${value}" >> "$RAD_SHELL_KV_STORE_PATH"
  fi

  rad-storage-validate || { mv "$RAD_SHELL_KV_STORE_BACKUP_PATH" "$RAD_SHELL_KV_STORE_PATH"; return 1; }
}

# Function: Get an item from an associative array
rad-storage-assoc-get() {
  local array_key="$1"
  local key="$2"
  rad-storage-get "${array_key}_${key}"
}

# Function: Set an item in an associative array
rad-storage-assoc-set() {
  local array_key="$1"
  local key="$2"
  local value="$3"
  echo "Setting associative array item ${array_key}_${key} to $value" >&2  # Debugging output to stderr
  rad-storage-set "${array_key}_${key}" "$value"
}

# Function: Get a list (comma-separated values)
rad-storage-list-get() {
  local key="$1"
  rad-storage-get "$key"
}

# Function: Add an item to a list (avoid duplicates)
rad-storage-list-add() {
  local key="$1"
  local item="$2"
  local list
  list=$(rad-storage-list-get "$key")

  echo "Adding $item to list $key" >&2  # Debugging output to stderr
  [[ -z "$list" ]] && list="$item" || {
    [[ ",$list," == *",$item,"* ]] || list="$list,$item"
  }

  rad-storage-set "$key" "$list"
}

# Function: Remove an item from a list
rad-storage-list-remove() {
  local key="$1"
  local item="$2"
  local list
  list=$(rad-storage-list-get "$key")

  [[ -z "$list" ]] && return 1
  list=$(echo "$list" | sed -E "s/(^|,)$item(,|$)//g; s/,,/,/g; s/^,//; s/,$//")

  rad-storage-set "$key" "$list"
}

# Initialize storage
rad-storage-init
