function _log --argument-names color icon text
    echo (set_color --bold $color)"$icon $text"(set_color normal)
end

function log_header
    _log blue $ICON_HEADER "$argv"
end

function log_step
    _log cyan $ICON_STEP "$argv"
end

function log_success
    _log green $ICON_SUCCESS "$argv"
end

function log_warning
    _log yellow $ICON_WARNING "$argv"
end

function log_error
    _log red $ICON_ERROR "$argv" >&2
end
