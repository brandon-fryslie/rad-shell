bindkey '^[D' zaw-rad-dev

function zaw-src-rad-dev() {
    local format_string="table {{ .Names }}\\t{{ .Image }}\\t{{ .Status }}\\t{{ .Ports }}\\t{{ .Size }}"
    local results="$(find ~/.zgen -wholename '*plugin.zsh')"

    local title=$(printf '%-40s %-20s' "Repo" "Plugin")
    local desc="$(echo "$results" | find ~/.zgen -wholename '*plugin.zsh' | perl -ne 'printf("%-40s %-20s\n", $1, $2) if m#^(?:.*/.zgen/)(?:git@[\w+\.-]+COLON-)?([\w\.@-]+/[\w\.-]+?)(?:.git)?(?:-master)?/.*?([\w-]+\.plugin\.zsh)$#g')"

    : ${(A)candidates::=${(f)results}}
    : ${(A)cand_descriptions::=${(f)desc}}
    actions=(\
        zaw-src-dev-cd \
        zaw-src-dev-edit \
        zaw-rad-append-to-buffer \
    )
    act_descriptions=(\
        "cd" \
        "edit" \
        "append path to buffer" \
    )
    options=(-t "$title" -m)
}

# Helper functions
# Get the plugin directory from the filename
zaw-rad-dev-get-plugin-dir() {
    echo $1 | perl -pe 's#^(.*/.zgen/[^/]+?/[^/]+?)/.*#\1#'
}

# Command functions
function zaw-src-dev-cd() {
    BUFFER="cd $(zaw-rad-dev-get-plugin-dir $1)"
    zaw-rad-action ${reply[1]}
}

function zaw-src-dev-edit() {
    BUFFER="$(rad-get-visual-editor) $(zaw-rad-dev-get-plugin-dir $1)"
    zaw-rad-action ${reply[1]}
}

zaw-register-src -n rad-dev zaw-src-rad-dev
