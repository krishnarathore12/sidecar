# sidecar

Bridge agents for [Claude Code](https://code.claude.com) that delegate work to other frontier models running on your own subscriptions:

- **`codex`** — runs **GPT 5.6 Sol at xhigh reasoning effort** via the [OpenAI Codex CLI](https://github.com/openai/codex). Best for implementation, debugging, bug fixing, code review, and test writing.
- **`pi`** — runs **GLM 5.2 at xhigh thinking** via the [pi coding agent](https://github.com/badlogic/pi-mono) through the OpenCode Go provider. Best for codebase exploration, research, analysis, refactoring, documentation, and second opinions.

Each agent is a thin wrapper (Sonnet 5 at low reasoning effort) that passes your task to the external CLI, verifies the result, and reports back — so the heavy lifting happens on the external model while your Claude Code context stays clean.

## Prerequisites

You need the CLIs installed and authenticated with **your own** subscriptions:

### Codex CLI

```bash
npm install -g @openai/codex   # or: brew install --cask codex
codex login                    # sign in with your ChatGPT subscription
```

### pi coding agent

```bash
npm install -g @earendil-works/pi-coding-agent   # or: brew install pi-coding-agent
```

Then start `pi` once and run `/login` to authenticate the **OpenCode Go** provider (requires an [OpenCode Go](https://opencode.ai/go) subscription).

> **Using a different GLM provider?** The agent pins `--provider opencode-go --model glm-5.2`. If you access GLM elsewhere (e.g. Hugging Face), edit `agents/pi.md` accordingly — run `pi --list-models | grep -i glm` to see what your account offers.

## Install

In Claude Code:

```
/plugin marketplace add krishnarathore12/sidecar
/plugin install sidecar@windflow
```

Verify with `/context` — you should see `codex` and `pi` under Custom Agents.

## Make Claude use them proactively (recommended)

Add this to your `~/.claude/CLAUDE.md` (or a project `CLAUDE.md`):

```markdown
# Subagent delegation policy

When launching subagents, almost always prefer the custom bridge agents over built-in ones:

- **codex** (GPT 5.6 Sol xhigh via Codex CLI): implementation, debugging, bug fixing, code review, test writing.
- **pi** (GLM 5.2 xhigh via pi harness): codebase exploration, research, analysis, refactoring, documentation, second opinions.

Use built-in agents (Explore, Plan, general-purpose) only when the task genuinely doesn't fit either, or when the codex/pi CLIs are unavailable or failing.
```

## Usage

Once installed, Claude delegates automatically based on the task, or you can ask explicitly:

- *"Launch a codex subagent to fix the failing tests"*
- *"Get a second opinion from pi on this design"*

## Troubleshooting

- **pi errors about providers or API keys** — your OpenCode Go login is missing: start `pi`, run `/login`, and pick the OpenCode Go provider. Check available models with `pi --list-models`.
- **Codex rejects the model** — `gpt-5.6-sol` requires an up-to-date Codex CLI; upgrade with `npm i -g @openai/codex@latest` (or `brew upgrade --cask codex`).
- **Codex fails in non-git directories** — the agent already passes `--skip-git-repo-check`; make sure you didn't remove it if you customize the prompt.

## License

MIT
