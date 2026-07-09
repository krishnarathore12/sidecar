# sidecar

Bridge agents for [Claude Code](https://code.claude.com) that route subagent work to the right model for the job — external GPT 5.6 variants on your ChatGPT subscription, plus Claude-native workers:

- **`sol`** — **GPT 5.6 Sol at xhigh reasoning** via the [OpenAI Codex CLI](https://github.com/openai/codex). Best for implementation, debugging, bug fixing, code review, and test writing.
- **`terra`** — **GPT 5.6 Terra at xhigh reasoning** via the Codex CLI. Best for codebase exploration, research, analysis, refactoring, documentation, and second opinions.
- **`sonnet`** — **Claude Sonnet 5**, running natively in Claude Code. Best for moderate, well-scoped tasks and anything needing the full Claude Code toolset (web search, MCP tools).
- **`opus`** — **Claude Opus 4.8 at high effort**, running natively. Best for the hardest reasoning: architecture decisions, gnarly debugging, security-sensitive changes, design reviews.

The GPT agents are thin wrappers (Sonnet 5 at low reasoning effort) that pass your task to the Codex CLI, verify the result, and report back — the heavy lifting happens on the external model while your Claude Code context stays clean. The Claude agents run the task directly in their own isolated context.

## Prerequisites

Only the GPT agents need setup — the Codex CLI installed and authenticated with **your own** ChatGPT subscription:

```bash
npm install -g @openai/codex   # install via npm (recommended, see note)
codex login                    # sign in with your ChatGPT subscription
```

> **Install via npm, not Homebrew.** As of codex 0.144.0 the Homebrew cask is missing the `codex-code-mode-host` helper binary, so tool-using tasks fail with `codex-code-mode-host not found`. The npm package bundles it. If you have the cask, switch: `brew uninstall --cask codex && npm i -g @openai/codex@latest`.

> `gpt-5.6-sol` and `gpt-5.6-terra` require an up-to-date Codex CLI. If either model is rejected, upgrade with `npm i -g @openai/codex@latest` (or `brew upgrade --cask codex`).

The `sonnet` and `opus` agents use your existing Claude Code login; no extra setup.

## Install

In Claude Code:

```
/plugin marketplace add krishnarathore12/sidecar
/plugin install sidecar@windflow
```

Verify with `/context` — you should see `sol`, `terra`, `sonnet`, and `opus` under Custom Agents.

## Make Claude use them proactively (recommended)

Add this to your `~/.claude/CLAUDE.md` (or a project `CLAUDE.md`):

```markdown
# Subagent delegation policy

**Default to delegation.** For any substantive task, the main conversation orchestrates — it does not do the work itself. Follow this loop:

1. **Assess what you know.** Before decomposing, check whether you can already name the files, modules, and facts involved. If not, gather knowledge first: run quick targeted searches yourself (Glob/Grep, read a key file) or launch terra to scout. Never decompose blind — chunks drawn from guesses produce overlapping or misdirected agents.
2. **Decompose into atomic chunks.** Split the task into the smallest units that are independently completable and verifiable — one bug, one module, one question, one file-cluster each. A chunk is atomic when one agent can finish it without waiting on another agent's output. Prefer many small parallel chunks over one broad agent.
3. **Launch in parallel.** Dispatch ALL independent chunks as subagents in a single message — never serially when no data dependency exists. Sequence only chunks whose input genuinely depends on another's output (e.g., terra scouts → sol implements with the findings in its prompt).
4. **Verify and integrate.** Read the changed files, run the tests or the code, reconcile any conflicts between agents' outputs, and report back concisely.

Route each chunk to the right agent:

- **sol** (GPT 5.6 Sol xhigh via Codex CLI): writing or modifying code, implementation, debugging, bug fixing, code review, test writing.
- **terra** (GPT 5.6 Terra xhigh via Codex CLI): codebase exploration, research, analysis, refactoring, documentation, second opinions.
- **sonnet** (Claude Sonnet 5): moderate, well-scoped tasks — multi-file edits, quick fixes, scripted chores, summarization — and tasks needing the full Claude Code toolset (web search, MCP tools) that the CLI bridges lack.
- **opus** (Claude Opus 4.8, high effort): the hardest reasoning tasks — architecture decisions, gnarly debugging, security-sensitive changes, design reviews — or a Claude-native second opinion alongside terra.

Rules:

- Give each subagent a complete, self-contained prompt: the goal, relevant file paths, constraints, gathered context, and exactly what to return. Chunks must not require agents to coordinate with each other.
- Two agents must never edit the same file in parallel — if chunks overlap on files, merge them into one chunk or sequence them.
- Handle directly only: trivial single-file edits that are faster to do than to delegate, quick factual answers, pure conversation, or cases where every subagent route is unavailable.
- Use built-in agents (Explore, Plan, general-purpose) only when the task genuinely doesn't fit any of the four.
```

## Usage

Once installed, Claude delegates automatically based on the task, or you can ask explicitly:

- *"Launch a sol subagent to fix the failing tests"*
- *"Get a second opinion from terra on this design"*
- *"Have opus review the auth flow for security issues"*

## Troubleshooting

- **Model rejected** — upgrade the Codex CLI: `npm i -g @openai/codex@latest`.
- **`codex-code-mode-host not found`** — you installed codex via the Homebrew cask, which doesn't ship the helper. Switch to npm: `brew uninstall --cask codex && npm i -g @openai/codex@latest`.
- **Fails in non-git directories** — the GPT agents already pass `--skip-git-repo-check`; make sure you didn't remove it if you customize the prompts.

## License

MIT
