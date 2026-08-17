import { commands, formatEslintSummary, parseCsv } from './commands.ts'

Deno.test('kebabify preserves the parent and renames equivalent targets', async () => {
  const directory = await Deno.makeTempDir()
  const parent = `${directory}/ParentDir`
  await Deno.mkdir(parent)
  const source = `${parent}/My_File`
  const target = `${parent}/my-file`
  await Deno.writeTextFile(source, 'content')

  try {
    await commands.kebabify([source])
    await Deno.stat(target)
  } finally {
    await Deno.remove(directory, { recursive: true })
  }
})

Deno.test('parseCsv preserves quoted commas and escaped quotes', () => {
  const actual = parseCsv(
    'name,note\nAda,"hello, world"\nLinus,"said ""hi"""\n',
  )
  const expected = [
    ['name', 'note'],
    ['Ada', 'hello, world'],
    ['Linus', 'said "hi"'],
  ]
  if (JSON.stringify(actual) !== JSON.stringify(expected)) {
    throw new Error(
      `Expected ${JSON.stringify(expected)}, got ${JSON.stringify(actual)}`,
    )
  }
})

Deno.test('formatEslintSummary groups and filters rule occurrences', () => {
  const reports = [{
    messages: [
      { ruleId: 'no-console', severity: 1 },
      { ruleId: 'no-console', severity: 2 },
      { ruleId: 'no-any', severity: 2 },
    ],
  }]
  if (
    formatEslintSummary(reports, 2) !==
      'RULE        COUNT\nno-console  1\nno-any      1'
  ) {
    throw new Error('Expected errors-only summary')
  }
})
