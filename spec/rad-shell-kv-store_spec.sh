#!/usr/bin/env shellspec

set +e

Describe 'rad-shell-kv-store'
  Include init-plugin/rad-shell-kv-store.zsh

  setup() {
    # Create a temporary file for each test
    RAD_SHELL_KV_STORE_PATH=$(mktemp)
    export RAD_SHELL_KV_STORE_PATH
    rad-kvs-init
  }

  cleanup() {
    rm -f "$RAD_SHELL_KV_STORE_PATH"
  }

  Before 'setup'
  After 'cleanup'

  It 'creates storage file if it does not exist'
    rm -f "$RAD_SHELL_KV_STORE_PATH"
    When call rad-kvs-init
    The file "$RAD_SHELL_KV_STORE_PATH" should be exist
  End

  It 'validates a file with only comment lines'
    # Create a storage file with only comment lines
    echo "# This is a comment" > "$RAD_SHELL_KV_STORE_PATH"
    echo "# Another comment" >> "$RAD_SHELL_KV_STORE_PATH"

    When call rad-kvs-validate
    The status should be success
  End

  It 'validates a file with comment lines'
    # Create a storage file with valid entries and comments
    echo "# This is a comment" > "$RAD_SHELL_KV_STORE_PATH"
    echo "validKey: validValue" >> "$RAD_SHELL_KV_STORE_PATH"
    echo "# Another comment" >> "$RAD_SHELL_KV_STORE_PATH"
    echo "anotherKey: anotherValue" >> "$RAD_SHELL_KV_STORE_PATH"

    When call rad-kvs-validate
    The status should be success
  End

  It 'fails validation for a file with invalid entries'
    # Create a storage file with an invalid entry
    echo "invalidEntry" > "$RAD_SHELL_KV_STORE_PATH"

    When call rad-kvs-validate
    The status should be failure
  End

  It 'stores and retrieves a value'
    rad-kvs-set "testKey" "testValue"
    When call rad-kvs-get "testKey"
    The output should equal "testValue"
  End

  It 'adds an item to a list'
    rad-kvs-list-add "testList" "item1"
    When call rad-kvs-get "testList"
    The output should equal "item1"
  End

  It 'removes an item from a list'
    rad-kvs-list-add "testList" "item1"
    rad-kvs-list-remove "testList" "item1"
    When call rad-kvs-get "testList"
    The output should be blank
  End

  It 'stores and retrieves an associative array item'
    rad-kvs-assoc-set "testArray" "subKey" "subValue"
    When call rad-kvs-assoc-get "testArray" "subKey"
    The output should equal "subValue"
  End
End
