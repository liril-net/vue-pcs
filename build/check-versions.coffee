chalk = require 'chalk'
semver = require 'semver'
packageConfig = require '../package'
shell = require 'shelljs'

exec = (cmd) ->
  require 'child_process'
  .execSync cmd
  .toString()
  .trim()

versionRequirements = [
  name: 'node'
  currentVersion: semver.clean(process.version)
  versionRequirement: packageConfig.engines.node
]

if shell.which 'npm'
  versionRequirements.push
    name: 'npm'
    currentVersion: exec 'npm --version'
    versionRequirement: packageConfig.engines.npm

module.exports = ->
  warnings = []
  for mod in versionRequirements
    if not semver.satisfies mod.currentVersion, mod.versionRequirement
      warnings.push "#{mod.name}:#{chalk.red(mod.currentVersion)} should be #{chalk.green(mod.versionRequirement)}"

  if warnings.length
    console.log ''
    console.log chalk.yellow 'To use this template, you must update following to modules:'
    console.log()
    for warning in warnings
      console.log "   #{warning}"
    console.log()
    process.exit 1
