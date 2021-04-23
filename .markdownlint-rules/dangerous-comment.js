/**
 * Checks for the existence of h2 and h3 headings in code fences.
 * Accidental use of headings in code blocks has the potential to impact
 * our docs searching
 */
function dangerousComment(params, onError) {
  params.tokens
    .filter((token) => token.type === "fence")
    .forEach((fence) => {
      if (fence.content && /(##|###)/g.test(fence.content)) {
        onError({
          lineNumber: fence.lineNumber,
        })
      }
    })
}

module.exports = {
  names: ["@cdr/dangerous-comment"],
  description:
    "Code fence cannot contain comments that match h2 or h3 headings (##, ###)",
  tags: ["code-fence", "comment"],
  function: dangerousComment,
}
