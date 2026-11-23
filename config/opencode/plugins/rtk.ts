import { execFile } from "node:child_process"
import { Plugin } from "@opencode/plugin"

// RTK OpenCode plugin — rewrites commands to use rtk for token savings.
// Requires: rtk >= 0.23.0 in PATH.
//
// This is a thin delegating plugin: all rewrite logic lives in `rtk rewrite`,
// which is the single source of truth (src/discover/registry.rs).
// To add or change rewrite rules, edit the Rust registry — not this file.

const checkRtk = () =>
  new Promise<void>((resolve, reject) => {
    execFile("rtk", ["--version"], { encoding: "utf8" }, (error) => {
      if (error) reject(error)
      else resolve()
    })
  })

const rewriteCommand = (command: string) =>
  new Promise<string>((resolve) => {
    execFile("rtk", ["rewrite", command], { encoding: "utf8" }, (error, stdout) => {
      if (
        error &&
        (typeof error.code !== "number" || error.code < 1 || error.code > 3)
      ) {
        console.warn("[rtk] command rewrite failed; passing the command through unchanged")
      }
      resolve(stdout)
    })
  })

const isRecord = (value: unknown): value is Record<string, unknown> =>
  value !== null && typeof value === "object" && !Array.isArray(value)

export default Plugin.define({
  id: "rtk.command-rewrite",
  async setup(ctx) {
    try {
      await checkRtk()
    } catch {
      console.warn("[rtk] rtk binary not found in PATH — plugin disabled")
      return
    }

    const registration = await ctx.tool.hook("execute.before", async (input) => {
      const tool = input.tool.toLowerCase()
      if (tool !== "bash" && tool !== "shell") return
      if (!isRecord(input.input)) return

      const command = input.input.command
      if (typeof command !== "string" || !command) return

      const rewritten = (await rewriteCommand(command)).trim()
      if (rewritten && rewritten !== command) {
        input.input.command = rewritten
      }
    })

    return () => registration.dispose()
  },
})
