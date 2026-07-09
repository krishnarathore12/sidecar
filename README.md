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
npm install -g @openai/codex   # or: brew install --cask codex
codex login                    # sign in with your ChatGPT subscription
```

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

**Default to delegation.** For any substantive task, launch a bridge subagent instead of doing the work in the main conversation. The main thread's job is to orchestrate: scope the task, delegate it, verify the result, and report back concisely.

- **sol** (GPT 5.6 Sol xhigh via Codex CLI): writing or modifying code, implementation, debugging, bug fixing, code review, test writing.
- **terra** (GPT 5.6 Terra xhigh via Codex CLI): codebase exploration, research, analysis, refactoring, documentation, second opinions.
- **sonnet** (Claude Sonnet 5): moderate, well-scoped tasks — multi-file edits, quick fixes, scripted chores, summarization — and tasks needing the full Claude Code toolset (web search, MCP tools) that the CLI bridges lack.
- **opus** (Claude Opus 4.8, high effort): the hardest reasoning tasks — architecture decisions, gnarly debugging, security-sensitive changes, design reviews — or a Claude-native second opinion alongside terra.

Rules:

- When a task needs both research and implementation, delegate in sequence: terra (or sonnet) to explore and gather context first, then sol to implement with that context in the prompt.
- Launch independent subagents in parallel in a single message rather than one at a time.
- Give each subagent a complete, self-contained prompt: the goal, relevant file paths, constraints, and what to return.
- Verify subagent output before reporting: read the changed files, run the tests or the code.
- Handle directly only: trivial single-file edits that are faster to do than to delegate, quick factual answers, pure conversation, or cases where every subagent route is unavailable.
- Use built-in agents (Explore, Plan, general-purpose) only when the task genuinely doesn't fit any of the four.
```

## Usage

Once installed, Claude delegates automatically based on the task, or you can ask explicitly:

- *"Launch a sol subagent to fix the failing tests"*
- *"Get a second opinion from terra on this design"*
- *"Have opus review the auth flow for security issues"*

## Troubleshooting

- **Model rejected** — upgrade the Codex CLI (`npm i -g @openai/codex@latest` or `brew upgrade --cask codex`). If Homebrew claims you're already up to date while an update exists, clear its API cache: `rm -rf ~/Library/Caches/Homebrew/api && brew upgrade --cask codex`.
- **Fails in non-git directories** — the GPT agents already pass `--skip-git-repo-check`; make sure you didn't remove it if you customize the prompts.

## License

MIT
