/**
 * @file add_clog_to_manifest.ts
 * @description Adds a changelog entry to manifest.json
 * @example add_clog_to_manifest.ts --version=1.18.3
 */
import { writeFileSync } from "fs"
import parseArgs from "minimist"
import { resolve } from "path"
import semverCompare from "semver-compare"
import manifestJSON from "../manifest.json"

/**
 * Prints information for how to use this program and exits with status code 1
 */
const usage = () => {
  console.log("Usage: append_manifest.ts [--version=<version>]")
  console.log("Update manifest.json with a changelog")
  console.log("Arguments:")
  console.log("    <version>: A version string 'x.y.z'")
  process.exit(1)
}

interface Arguments {
  /** A version string in the form of x.y.z. */
  version?: string
}

/**
 * Parses arguments
 */
const init = (): Arguments => {
  const args = parseArgs(process.argv.slice(2))
  const result: Arguments = {}
  if (args.version && typeof args.version === "string") {
    result.version = args.version
  }
  return result
}

/**
 * Appends manifest.json with a changelog entry using the provided version
 */
const appendClogManifest = (version: string): void => {
  const clogIdx = manifestJSON.routes.findIndex(
    (route) => route.path === "./changelog/index.md"
  )

  if (clogIdx < 0) {
    console.error("failed to parse manifest.json")
    process.exit(1)
  }

  ;(manifestJSON.routes[clogIdx].children as { path: string }[]).unshift({
    path: `./changelog/${version}.md`,
  })

  // Capture the semver version from /(1.2.3).md
  const filenameRegex = /\/([0-9\.]+)\.md$/gi

  manifestJSON.routes[clogIdx].children.sort((a, b) => {
    const versionA = a.path.match(filenameRegex)
    const versionB = b.path.match(filenameRegex)
    if (
      versionA === null ||
      versionA.length !== 1 ||
      versionB === null ||
      versionB.length !== 1
    ) {
      console.error("failed to parse manifest.json")
      process.exit(1)
    }
    return -semverCompare(versionA[0], versionB[0])
  })

  console.log("appending manifest.json with clog version: ", version)
  const serializedJSON = JSON.stringify(manifestJSON, null, 2)
  const manifestPath = resolve(__dirname, "../", "manifest.json")
  writeFileSync(manifestPath, serializedJSON, "utf8")
}

/**
 * Main program
 */
const main = () => {
  const args = init()
  if (!args.version) {
    console.error("version is a required argument")
    return usage()
  }
  appendClogManifest(args.version)
  console.log("Done")
  console.info("tip: run yarn fmt:fix to prettify manifest.json")
  process.exit(0)
}

main()
