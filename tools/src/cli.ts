import { type Command, commands } from './commands.ts'

function printUsage(): void {
  console.error(`Usage: dev-tools <command> [arguments]

Commands:
${Object.keys(commands).sort().map((name) => `  ${name}`).join('\n')}`)
}

function commandFromInvocation(): { command?: Command; args: string[] } {
  const invokedAs = (process.argv0 ?? '').split('/').at(-1) ?? ''
  const directCommand = commands[invokedAs]
  if (directCommand) return { command: directCommand, args: Deno.args }

  const [name, ...args] = Deno.args
  return { command: name ? commands[name] : undefined, args }
}

const { command, args } = commandFromInvocation()

if (!command) {
  printUsage()
  Deno.exit(1)
}

try {
  await command(args)
} catch (error) {
  console.error(error instanceof Error ? error.message : String(error))
  Deno.exit(1)
}
