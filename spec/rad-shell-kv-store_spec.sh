#!/usr/bin/env shellspec

Describe 'rad-shell-kv-store'
  Include init-plugin/rad-shell-kv-store.zsh

  BeforeEach 'rad-storage-init'

  It 'creates storage file if it does not exist'
    rm -f "$RAD_SHELL_KV_STORE_PATH"
    When call rad-storage-init
    The file "$RAD_SHELL_KV_STORE_PATH" should be exist
  End

  It 'stores and retrieves a value'
    rad-storage-set "testKey" "testValue"
    When call rad-storage-get "testKey"
    The output should equal "testValue"
  End

  It 'adds an item to a list'
    rad-storage-list-add "testList" "item1"
    When call rad-storage-get "testList"
    The output should equal "item1"
  End

  It 'removes an item from a list'
    rad-storage-list-add "testList" "item1"
    rad-storage-list-remove "testList" "item1"
    When call rad-storage-get "testList"
    The output should be blank
  End

  It 'stores and retrieves an associative array item'
    rad-storage-assoc-set "testArray" "subKey" "subValue"
    When call rad-storage-assoc-get "testArray" "subKey"
    The output should equal "subValue"
  End
End
