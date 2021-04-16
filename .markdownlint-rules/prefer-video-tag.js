/**
 * Enforices that <video> be used for video files.
 */
function preferVideoTag(params, onError) {
  params.tokens.forEach((token) => {
    // This performs the check if a block (line) starts with standalone []()
    if (token.type === "link_open") {
      if (token.attrs && token.attrs.length) {
        token.attrs.forEach((attr) => {
          if (attr[0] === "href") {
            if (attr[1] && /.(gif|mp4)$/g.test(attr[1])) {
              onError({
                lineNumber: token.lineNumber,
              })
            }
          }
        })
      }
    }

    // This performs the check on children of a block (line)
    if (token.children && token.children.length) {
      token.children.forEach((childToken) => {
        if (childToken.type === "link_open") {
          if (childToken.attrs && childToken.attrs.length) {
            childToken.attrs.forEach((attr) => {
              if (attr[0] === "href") {
                if (attr[1] && /.(gif|mp4)$/g.test(attr[1])) {
                  onError({
                    lineNumber: childToken.lineNumber,
                  })
                }
              }
            })
          }
        }
      })
    }
  })
}

module.exports = {
  names: ["@cdr/prefer-video-tag"],
  description: "Prefer <video> tags over []() for video files.",
  tags: ["video", "html"],
  function: preferVideoTag,
}
