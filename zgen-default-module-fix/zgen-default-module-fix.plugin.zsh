# We need this to tell prezto we have loaded its default modules
# Other modules may rely on this being set, but due to the way we load these
# plugins with Zgen to maintain the correct ordering, we need to patch this up
# ourselves
# See: https://github.com/tarjoilija/zgen/issues/74
for module in "environment" "terminal" "editor" "history" "directory" "spectrum" "utility" "completion" "prompt" "fasd"; do
  zstyle ":prezto:module:$module" loaded 'yes'
done
