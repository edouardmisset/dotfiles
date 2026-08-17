import { dirname, fromFileUrl, join } from '@std/path'

const toolsDirectory = dirname(dirname(fromFileUrl(import.meta.url)))
const binDirectory = join(toolsDirectory, 'bin')
const commandNames = [
  'csv2json',
  'eslint-summary',
  'gmove',
  'install',
  'kebabify',
  'killport',
  'run',
  'selection',
  'time-it',
]
await Deno.mkdir(binDirectory, { recursive: true })
await Deno.chmod(join(binDirectory, 'dev-tools'), 0o7_5_5)

for (const name of commandNames) {
  const link = join(binDirectory, name)
  await Deno.remove(link).catch((error) => {
    if (!(error instanceof Deno.errors.NotFound)) throw error
  })
  await Deno.symlink('dev-tools', link)
}

console.log(
  `Installed ${commandNames.length} dev-tools commands in ${binDirectory}`,
)
