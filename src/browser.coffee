window.log = (val) -> $('body').append("<div>#{JSON.stringify(val)}</div>");
window.onerror = (errorMsg, url, lineNumber) ->
  log "Error occured at (#{lineNumber}): #{errorMsg}"
  return false;
