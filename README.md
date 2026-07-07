# sidecar

Bridge agents for [Claude Code](https://code.claude.com) that delegate work to other frontier models running on your own subscriptions:

- **`codex`** — runs **GPT 5.5 at xhigh reasoning effort** via the [OpenAI Codex CLI](https://github.com/openai/codex). Best for implementation, debugging, bug fixing, code review, and test writing.
- **`opencode`** — runs **GLM 5.2 at max reasoning effort** via the [opencode CLI](https://opencode.ai). Best for codebase exploration, research, analysis, refactoring, documentation, and second opinions.

Each agent is a thin wrapper (Sonnet 5 at low reasoning effort) that passes your task to the external CLI, verifies the result, and reports back — so the heavy lifting happens on the external model while your Claude Code context stays clean.

## Prerequisites

You need the CLIs installed and authenticated with **your own** subscriptions:

### Codex CLI

```bash
npm install -g @openai/codex
codex login   # sign in with your ChatGPT subscription
```

### opencode CLI

```bash
curl -fsSL https://opencode.ai/install | bash
opencode auth login   # sign in with your opencode subscription
```

> **Note on the opencode provider:** the agent uses `opencode-go/glm-5.2`, which requires an **OpenCode Go** subscription. If you're on the pay-per-use Zen plan instead, edit `agents/opencode.md` and change the model to `opencode/glm-5.2`.

## Install

In Claude Code:

```
/plugin marketplace add krishnarathore12/sidecar
/plugin install sidecar@windflow
```

Verify with `/context` — you should see `codex` and `opencode` under Custom Agents.

## Make Claude use them proactively (recommended)

Add this to your `~/.claude/CLAUDE.md` (or a project `CLAUDE.md`):

```markdown
# Subagent delegation policy

When launching subagents, almost always prefer the custom bridge agents over built-in ones:

- **codex** (GPT 5.5 xhigh via Codex CLI): implementation, debugging, bug fixing, code review, test writing.
- **opencode** (GLM 5.2 max via opencode CLI): codebase exploration, research, analysis, refactoring, documentation, second opinions.

Use built-in agents (Explore, Plan, general-purpose) only when the task genuinely doesn't fit either, or when the codex/opencode CLIs are unavailable or failing.
```

## Usage

Once installed, Claude delegates automatically based on the task, or you can ask explicitly:

- *"Launch a codex subagent to fix the failing tests"*
- *"Get a second opinion from opencode on this design"*

## Troubleshooting

- **"Insufficient balance" from opencode** — you're hitting the Zen provider without balance. Either subscribe to OpenCode Go (keep `opencode-go/glm-5.2`) or switch the model in `agents/opencode.md` to match your plan.
- **"No allowed providers are available"** — the configured model has no active provider on your account; run `opencode models` to see what you have access to.
- **Codex fails in non-git directories** — the agent already passes `--skip-git-repo-check`; make sure you didn't remove it if you customize the prompt.

## License

MIT
