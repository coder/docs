const anchorRe = /<a\shref=".*".*>/g

const containsDangerousAnchor = (line) => {
  if (anchorRe.test(line)) {
    if (
      line.includes('target="_blank"') &&
      !line.includes('rel="noreferrer noopener"')
    ) {
      return true
    }
  }
  return false
}

function dangerousLink(params, onError) {
  params.tokens.forEach((token) => {
    if (token.type === "html_inline") {
      if (containsDangerousAnchor(token.content)) {
        onError({
          lineNumber: token.lineNumber,
        })
      }
    }

    // This performs the check on children of a block (line)
    if (token.children && token.children.length) {
      token.children.forEach((childToken) => {
        if (childToken.type === "html_inline") {
          if (containsDangerousAnchor(token.content)) {
            onError({
              lineNumber: childToken.lineNumber,
            })
          }
        }
      })
    }
  })
}

module.exports = {
  names: ["@cdr/dangerous-link"],
  description: "_blank target requires noreferrer noopener",
  tags: ["links"],
  function: dangerousLink,
}
