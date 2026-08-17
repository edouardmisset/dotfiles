import { basename, dirname, join } from '@std/path'

export type Command = (args: string[]) => Promise<void>

function usage(message: string): never {
  throw new Error(message)
}

async function run(
  command: string,
  args: string[],
  options: Deno.CommandOptions = {},
): Promise<Deno.CommandStatus> {
  return await new Deno.Command(command, { args, ...options }).spawn().status
}

async function commandExists(command: string): Promise<boolean> {
  try {
    return (await new Deno.Command('which', {
      args: [command],
      stdout: 'null',
      stderr: 'null',
    }).output()).success
  } catch {
    return false
  }
}

async function readJson(path: string): Promise<Record<string, unknown>> {
  return JSON.parse(await Deno.readTextFile(path)) as Record<string, unknown>
}

function taskNames(config: Record<string, unknown>): string[] {
  const tasks = config.tasks
  return tasks && typeof tasks === 'object' && !Array.isArray(tasks)
    ? Object.keys(tasks)
    : []
}

export const commands = {
  async kebabify(args) {
    if (args.length === 0) usage('Usage: kebabify <file1> [file2...]')
    for (const path of args) {
      try {
        await Deno.lstat(path)
      } catch (error) {
        if (error instanceof Deno.errors.NotFound) {
          console.error(`Skipping: '${path}' not found`)
          continue
        }
        throw error
      }
      const targetName = basename(path)
        .replace(/([a-z0-9])([A-Z])/g, '$1-$2')
        .replaceAll('_', '-')
        .toLowerCase()
      const target = join(dirname(path), targetName)
      if (target === path) continue
      try {
        await Deno.lstat(target)
        const [sourceInfo, targetInfo] = await Promise.all([
          Deno.stat(path),
          Deno.stat(target),
        ])
        if (
          sourceInfo.dev === targetInfo.dev &&
          sourceInfo.ino === targetInfo.ino
        ) {
          await Deno.rename(path, target)
          console.log(`Renamed: ${path} -> ${target}`)
        } else {
          console.error(`Skipping: '${target}' already exists`)
        }
      } catch (error) {
        if (!(error instanceof Deno.errors.NotFound)) throw error
        await Deno.rename(path, target)
        console.log(`Renamed: ${path} -> ${target}`)
      }
    }
  },

  async csv2json([path]) {
    if (!path) usage('Usage: csv2json <csv_file>')
    const text = (await Deno.readTextFile(path)).replace(/^\uFEFF/, '')
    const rows = parseCsv(text)
    const [headers = [], ...records] = rows
    console.log(
      JSON.stringify(
        records.map((record) =>
          Object.fromEntries(
            headers.map((header, index) => [header, record[index] ?? '']),
          )
        ),
        null,
        2,
      ),
    )
  },

  async 'eslint-summary'(args) {
    let severity: 1 | 2 | undefined
    const [filter, ...eslintArgs] = args
    if (filter === '--warnings-only') severity = 1
    else if (filter === '--errors-only') severity = 2
    else if (filter === '-h' || filter === '--help') {
      usage(
        'Usage: eslint-summary [--warnings-only|--errors-only] [eslint args...]',
      )
    } else eslintArgs.unshift(...args)

    if (!await commandExists('pnpm')) {
      usage("error: required command 'pnpm' not found")
    }
    const result = await new Deno.Command('pnpm', {
      args: [
        'exec',
        'eslint',
        '.',
        '--cache',
        '--format',
        'json',
        ...eslintArgs,
      ],
      stdout: 'piped',
      stderr: 'null',
    }).output()
    const output = new TextDecoder().decode(result.stdout).trim()
    if (!output) usage('No eslint output (check that eslint runs correctly).')

    let reports: EslintReport[]
    try {
      reports = JSON.parse(output) as EslintReport[]
    } catch {
      usage('Could not parse eslint JSON output.')
    }
    console.log(formatEslintSummary(reports, severity))
  },

  async killport([port]) {
    if (!port) usage('Usage: killport <port>')
    if (!/^\d+$/.test(port)) usage('Port must be a number')
    const lookup = await new Deno.Command('lsof', {
      args: ['-t', `-i:${port}`],
    }).output()
    const pids = new TextDecoder().decode(lookup.stdout).trim().split(/\s+/)
      .filter(Boolean)
    if (pids.length === 0) usage(`No process found on port ${port}`)
    const killed = await run('kill', ['-9', ...pids])
    if (!killed.success) Deno.exit(killed.code)
  },

  async install(args) {
    if (await exists('deno.json')) {
      if (!await commandExists('deno')) usage('Error: deno is not installed')
      Deno.exit((await run('deno', ['install', ...args])).code)
    }
    if (!await exists('package.json')) {
      usage('Error: No package.json or deno.json found')
    }
    if (!await commandExists('vp')) {
      usage(
        "Error: vp (Vite+) is not installed. Run './install' or 'brew install vite-plus'.",
      )
    }
    Deno.exit((await run('vp', ['install', ...args])).code)
  },

  async run(args) {
    if (await exists('deno.json')) {
      if (!await commandExists('deno')) usage('Error: deno is not installed')
      const tasks = taskNames(await readJson('deno.json'))
      const [task] = args
      if (!task) {
        console.error('Available tasks:')
        console.log(tasks.join('\t'))
        return
      }
      if (!tasks.includes(task)) {
        usage(
          `Error: Task '${task}' not found in deno.json 🚫\nAvailable tasks:\n${
            tasks.join('\t')
          }`,
        )
      }
      Deno.exit((await run('deno', ['task', ...args])).code)
    }
    if (!await exists('package.json')) {
      usage('Error: No package.json or deno.json found')
    }
    if (!await commandExists('vp')) {
      usage(
        "Error: vp (Vite+) is not installed. Run './install' or 'brew install vite-plus'.",
      )
    }
    Deno.exit((await run('vp', ['run', '--cache', ...args])).code)
  },

  async 'time-it'(args) {
    const [command, ...commandArgs] = args
    if (!command) usage('Usage: time-it <command> [arguments...]')
    const display = args.map((arg) => JSON.stringify(arg)).join(' ')
    console.log(`Executing: ${display}\n`)
    const startedAt = performance.now()
    const child = new Deno.Command(command, {
      args: commandArgs,
      stdout: 'piped',
      stderr: 'piped',
    }).spawn()
    const [status] = await Promise.all([
      child.status,
      child.stdout.pipeTo(Deno.stdout.writable, { preventClose: true }),
      child.stderr.pipeTo(Deno.stderr.writable, { preventClose: true }),
    ])
    const elapsed = Math.round(performance.now() - startedAt)
    if (!status.success) {
      console.error(
        `❌ Command failed after ${elapsed} ms with code ${status.code}`,
      )
      Deno.exit(status.code)
    }
    console.log(`✅ Command executed successfully in ${elapsed} ms`)
  },

  async gmove([branch, startingPoint]) {
    if (!branch) usage('Usage: gmove <new-branch-name> [starting-point]')
    const staged = await new Deno.Command('git', {
      args: ['diff', '--staged', '--name-only'],
    }).output()
    const files = new TextDecoder().decode(staged.stdout).trim().split('\n')
      .filter(Boolean)
    if (files.length === 0) usage('Error: no staged changes to move')
    for (
      const [command, args] of [
        ['git', ['stash', '--', ...files]],
        ['git', ['add', '-A']],
        ['git', [
          'commit',
          '--no-verify',
          '--no-gpg-sign',
          '--message',
          '--wip-- [skip ci]',
        ]],
        ['git', ['branch', branch, ...(startingPoint ? [startingPoint] : [])]],
        ['git', ['checkout', branch]],
        ['git', ['stash', 'pop']],
      ] as const
    ) {
      const status = await run(command, [...args])
      if (!status.success) Deno.exit(status.code)
    }
  },

  async selection([sourceDir = '/Volumes/media/PF']) {
    const home = Deno.env.get('HOME') ?? usage('HOME is not set')
    const destination = join(home, 'Movies', 'pff')
    const videos = await listVideos(sourceDir)
    const solo = selectSolo(
      videos.filter((name) => name.toLowerCase().includes('solo')),
    )
    const noSolo = shuffle(
      videos.filter((name) => !name.toLowerCase().includes('solo')),
    ).slice(0, 30)
    await replaceDirectoryWithLinks(
      join(sourceDir, 'solo'),
      sourceDir,
      solo,
      convertSoloName,
    )
    await replaceDirectoryWithLinks(
      join(sourceDir, 'selection'),
      sourceDir,
      noSolo,
    )
    await replaceDirectoryWithCopies(
      join(destination, 'solo'),
      sourceDir,
      solo,
      convertSoloName,
    )
    await replaceDirectoryWithCopies(
      join(destination, 'selection'),
      sourceDir,
      noSolo,
    )
    await run('open', [
      join(destination, 'solo'),
      join(destination, 'selection'),
    ])
  },
} as const satisfies Record<string, Command>

type EslintMessage = { ruleId: string | null; severity: number }
type EslintReport = { messages: EslintMessage[] }

export function formatEslintSummary(
  reports: EslintReport[],
  severity?: 1 | 2,
): string {
  const counts = new Map<string, number>()
  for (const report of reports) {
    for (const message of report.messages) {
      if (!message.ruleId || (severity && message.severity !== severity)) {
        continue
      }
      counts.set(message.ruleId, (counts.get(message.ruleId) ?? 0) + 1)
    }
  }
  if (counts.size === 0) return 'No matching lint issues found.'

  const rows = [...counts.entries()].sort(([, left], [, right]) => right - left)
  const width = Math.max('RULE'.length, ...rows.map(([rule]) => rule.length))
  return [
    `${'RULE'.padEnd(width)}  COUNT`,
    ...rows.map(([rule, count]) => `${rule.padEnd(width)}  ${count}`),
  ].join('\n')
}

async function exists(path: string): Promise<boolean> {
  try {
    await Deno.lstat(path)
    return true
  } catch (error) {
    if (error instanceof Deno.errors.NotFound) return false
    throw error
  }
}

export function parseCsv(text: string): string[][] {
  const rows: string[][] = [[]]
  let value = ''
  let quoted = false
  for (let index = 0; index < text.length; index++) {
    const character = text[index]
    if (character === '"') {
      if (quoted && text[index + 1] === '"') {
        value += '"'
        index++
      } else quoted = !quoted
    } else if (character === ',' && !quoted) {
      rows.at(-1)?.push(value)
      value = ''
    } else if ((character === '\n' || character === '\r') && !quoted) {
      if (character === '\r' && text[index + 1] === '\n') index++
      rows.at(-1)?.push(value)
      rows.push([])
      value = ''
    } else value += character
  }
  if (value || rows.at(-1)?.length) rows.at(-1)?.push(value)
  return rows.filter((row) =>
    row.length > 0 && (row.length > 1 || row[0] !== '')
  )
}

function shuffle<T>(values: T[]): T[] {
  const shuffled = [...values]
  for (let index = shuffled.length - 1; index > 0; index--) {
    const swapIndex = Math.floor(Math.random() * (index + 1))
    ;[shuffled[index], shuffled[swapIndex]] = [
      shuffled[swapIndex],
      shuffled[index],
    ]
  }
  return shuffled
}

async function listVideos(directory: string): Promise<string[]> {
  const videos: string[] = []
  for await (const entry of Deno.readDir(directory)) {
    if (
      entry.isFile && entry.name.toLowerCase().endsWith('.mp4') &&
      !entry.name.startsWith('.')
    ) videos.push(entry.name)
  }
  return videos
}

function cleanSoloName(name: string): string {
  return name.split('.').slice(0, -1).join('.').split('solo')[0].split(' ')
    .slice(0, 3).join(' ').replaceAll('-', '').trim().toLocaleLowerCase()
    .normalize('NFC')
}

function selectSolo(names: string[]): string[] {
  const grouped = new Map<string, string[]>()
  for (const name of shuffle(names)) {
    grouped.set(cleanSoloName(name), [
      ...(grouped.get(cleanSoloName(name)) ?? []),
      name,
    ])
  }
  return [...grouped.values()].map((values) =>
    values[Math.floor(Math.random() * values.length)]
  ).slice(0, 30)
}

function convertSoloName(name: string): string {
  return name.replace(/\s+-\s.*solo.*/i, '.mp4')
}

async function replaceDirectory(path: string): Promise<void> {
  await Deno.remove(path, { recursive: true }).catch((error) => {
    if (!(error instanceof Deno.errors.NotFound)) throw error
  })
  await Deno.mkdir(path, { recursive: true })
}

async function replaceDirectoryWithLinks(
  destination: string,
  source: string,
  names: string[],
  transform = (name: string) => name,
): Promise<void> {
  await replaceDirectory(destination)
  for (const name of names) {
    await Deno.symlink(join(source, name), join(destination, transform(name)))
  }
}

async function replaceDirectoryWithCopies(
  destination: string,
  source: string,
  names: string[],
  transform = (name: string) => name,
): Promise<void> {
  await replaceDirectory(destination)
  for (const name of names) {
    await Deno.copyFile(join(source, name), join(destination, transform(name)))
  }
}
