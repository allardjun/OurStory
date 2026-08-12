# Running this activity

This repository is the pristine copy.
It is never used for a class directly — each time you run the activity you make a fresh instance from it, and the instance is what the students fork.

## Prerequisites

**Students need nothing at all.** No accounts beyond GitHub, no installations, no terminal. Everything they do is in a browser.

**You need the GitHub CLI**, once, on your own machine.

1. Install it: <https://github.com/cli/cli#installation> (on a Mac, `brew install gh`).
2. Sign in: `gh auth login`, and follow the prompts. Choose **GitHub.com**, **HTTPS**, and authenticate in the browser.

The full walkthrough is at <https://docs.github.com/en/github-cli/github-cli/quickstart>.

Check it worked:

```bash
gh auth status
```

If that prints your username, you are ready.
Everything below assumes it.

## Once, ever

Make this repository a template, so instances can be created from it in one command:

```bash
gh repo edit allardjun/OurStory --template
```

## For each class

```bash
./scripts/new-instance.sh "Bootcamp 2026"
```

That is the whole setup.
It creates `allardjun/OurStory-Bootcamp-2026`, records the instance name so it appears on the site, turns on GitHub Pages, sets the editing-zone size, puts the site link in the repository's About box, and prints every URL you will need.

**It is safe to run twice.**
It creates what is missing and leaves what exists alone, so if your wifi drops halfway through, just run it again.

## Before the class starts

**Rehearse it.**
This invents a class, has them each edit a line, merges everything, and reports how many conflicts you would have got:

```bash
./scripts/dry-run.sh 12          # 12 students picking lines the way people actually do
./scripts/dry-run.sh 12 uniform  # the same class, picking with genuinely equal probability
```

It works on a throwaway copy and pushes nothing.
On the full-length Magic Mitten with twelve students, expect roughly four or five conflicts.

### Why "pick any line, anywhere" is enough

It is tempting to think a long story means no collisions.
It does not, because people do not choose uniformly — they overwhelmingly edit near the top.

In the 2024 class, of seven students editing a hundred-and-twenty-line file: one took line 4, four took line 8, one took line 12, one took line 25, and one took line 109.
Five of seven landed in the first twelve lines, and there was a four-way pileup on a single line.
Uniform choice would have predicted well under one collision.

That bias roughly doubles the conflict rate relative to uniform picking, which is why the stories here are full length and the instruction is simply "pick any line".
Do not ask students to coordinate, and do not assign line numbers — the clustering is doing the work for you.

### If you ever need more conflicts

There is a dial for it, off by default.
Setting `HOT_LINES` to a number shades the first N lines on the story page and tells students to pick inside them:

```bash
gh variable set HOT_LINES --repo allardjun/OurStory-Bootcamp-2026 --body 12
```

With `S` students choosing among `L` lines, the fraction who collide is roughly `1 − (1 − 1/L)^(S−1)`:

| Class size | Zone of 8 lines | of 12 lines | of 20 lines |
| ---------- | --------------- | ----------- | ----------- |
| 8          | 61%             | 46%         | 30%         |
| 12         | 77%             | 62%         | 43%         |
| 20         | 92%             | 81%         | 62%         |

Reach for this only if a rehearsal comes out flat.
Resolving a conflict is a class-level outcome: it is enough that several happen and the room watches them being fixed, and forcing every single student into one costs you the free choice of line, which is most of the fun.

## The run sheet

Roughly five minutes a step, about fifty minutes in total.

| # | What happens | You are doing |
| - | ------------ | ------------- |
| 0 | Everyone rolls a 1 or a 2 for their group; class votes on a story | Open the **Pick the story** workflow in the Actions tab, choose the winner from the dropdown, press **Run workflow**. The site rebuilds in under a minute. |
| 1 | Everyone forks — Group A from you, Group B from a Group A student | Project the **fork network** page and watch it grow. This is dead time otherwise, and it is the best moment to explain what a fork is. |
| 2 | Everyone edits one line, anywhere, and commits | Project **The story** page. Walk the room. |
| 3 | Group B opens pull requests to their Group A partner | |
| 4 | Group A merges them, and resolves the conflicts | Expect noise here. This is the point of the lesson, not an interruption. |
| 5 | Group A opens pull requests to you | |
| 6 | You merge them live, one at a time | Do this on the projector, slowly. Pull requests after the first will conflict. Do not fix them yourself — tell that student to click **Resolve conflicts**, and narrate what they are doing. |
| 7 | Look at what you made | **The story**, then **Who wrote what**, then **The tree**. |

### The one timing rule

**Everybody must fork before any merging starts.**

A student who forks after their classmates' work has already been merged is copying a version that already contains it, so they cannot collide with it and will never see a conflict.
Hold the whole room at step 1 until every fork exists, and do not merge anything before then.
This is the single thing most likely to flatten the lesson, and it is invisible if you do not know to look for it.

### Talking points that land

- **On the fork network page:** every one of those dots is a complete copy of the entire history. Nobody asked permission for it.
- **When the first conflict appears:** git is not confused and has not lost anything. It knows exactly what both people wrote and is refusing to guess which one is right, because that is a decision only a person can make.
- **On the "Who wrote what" page:** the colour is whoever *last* touched the line. If you resolved a conflict, the line is yours now, and the person you overwrote has vanished from this view even though their work is still in the history. This is what blame does and does not tell you, and it is a good moment to say that "blame" is a terrible name for it.
- **On the green tick:** that is a program somebody wrote, running on somebody else's computer, every time anyone proposes a change. Nobody ran it on purpose. That is all continuous integration is.

## When something goes wrong

**A student cannot find the Fork button.** They are probably already inside their own fork. The top of the page tells you whose copy you are in.

**A Group B student cannot find anyone to fork from.** Group A has not finished. Give them the fork-network page and let them watch, or move them to Group A.

**The site has not updated.** Check the Actions tab of the instance repo. The build takes 30–60 seconds after each merge; Pages can take another minute to serve it.

**A pull request shows a red cross.** That is the checker doing its job. Open it and read the message — it is written for students, and it is almost always leftover `<<<<<<<` markers or a resolution that deleted most of the story.

**Pages is not switched on.** Repository Settings → Pages → Source: **GitHub Actions**. Then re-run `new-instance.sh`.

**A student's fork has no Actions.** Forks have workflows disabled until the owner enables them, so Group A will not see green ticks on the pull requests their partners send them. This is fine and worth one sentence: the checks run in *your* repository, where the story actually lives.

## What is in here

| | |
| - | - |
| `story.md` | The shared document. The only file students touch. |
| `stories/` | The four base texts, trimmed short so that collisions actually happen. |
| `site/build.py` | Builds the three pages. No dependencies, so it runs anywhere. |
| `site/check_story.py` | The pull-request check. Written to be read by a beginner. |
| `scripts/new-instance.sh` | Idempotent per-class setup. |
| `scripts/dry-run.sh` | Rehearse a whole session locally. |
| `scripts/classmates.sh` | Walk the fork tree and pull every copy in as a remote. |
| `scripts/tree.sh`, `scripts/blame.sh` | The terminal versions, for the Codespace demo. |

## Codespaces, and how long they take

**Measuring it.** From your own machine, time the whole thing from outside:

```bash
time gh codespace create --repo allardjun/OurStory-Bootcamp-2026 --branch main
```

That prints real wall-clock minutes.
From inside a running Codespace, the Command Palette has **Codespaces: View Creation Log**, which timestamps each phase so you can see whether the time went on pulling the image or on the setup commands.

**Does creating one before class make the next one faster?**
Only in one specific way, but it is the way you want.

- **Keeping the same Codespace: yes, and it is dramatic.** Create it before class, then *stop* it rather than deleting it. Resuming a stopped Codespace takes seconds, because the machine and its disk still exist. If you are demonstrating from your own screen, do exactly this: create it the night before, stop it, and resume it during class.
- **Creating a fresh Codespace: no.** Every new Codespace is a new virtual machine. Yours having existed does not help the next one, and it certainly does not help a student's.

**To make everyone's first launch fast, use prebuilds.** Repository **Settings → Codespaces → Set up prebuild**, for `main`. GitHub then builds the container ahead of time and keeps it ready, which turns minutes into seconds. It costs Actions minutes and some storage.

One catch worth knowing before you rely on it: **prebuilds belong to a repository, and do not follow forks.** Students who open a Codespace on their own fork get a cold build regardless of what you have prebuilt. If you want the class to see a fast Codespace, have them open it on *your* instance repository, or treat Codespaces as the after-class bonus track that the README already makes it.

## Seeing the whole class from a terminal

`./scripts/classmates.sh --list` prints the fork tree, including forks of forks, which is what your Group B students produce:

```
  chelsebn/OurStory-Bootcamp-2026
      gauthamp123/OurStory-Bootcamp-2026   (from chelsebn/OurStory-Bootcamp-2026)
      akarshkd/OurStory-Bootcamp-2026      (from chelsebn/OurStory-Bootcamp-2026)

  11 copies: 6 from the original, 5 from a classmate.
```

Without `--list` it adds each copy as a git remote and fetches it, after which `./scripts/tree.sh` draws the entire class — every student's commits, in one graph, in one terminal.
This is the best terminal counterpart to the network graph, and it is worth doing live at step 7.

**In a Codespace this needs no setup.** The GitHub CLI is preinstalled there and already authenticated, so students do not sign in to anything. The script also falls back to plain `curl` against the public API, so it works even where `gh` is absent or signed out — the fork list of a public repository is readable without credentials.

## Notes on the design

**Why the stories are short.** Conflict frequency is entirely determined by class size divided by the number of editable lines. The 2024 story was long enough that collisions were down to luck, and most students never saw one. Each base text here is trimmed to about twenty lines, and the editing zone narrows it further.

**Why line numbers are file line numbers.** The numbers in the gutter of the story page are the same ones GitHub shows in its editor, including the gaps where blank lines are. They look slightly odd, and they are correct, which matters more when a beginner is trying to find line 9.

**Why the story is Markdown and the PDF is gone.** The 2024 instance committed `main.pdf` along with the Latex build files. Every student's pull request would touch the PDF, and conflicts in a binary file cannot be resolved in the web editor — they just stop. Now nothing built is committed, and the published site plays the role the PDF used to.

**How students are split into groups.** Step 0 of the README is a single link to random.org that returns one number, 1 or 2, as plain text and nothing else:

```
https://www.random.org/integers/?num=1&min=1&max=2&col=1&base=10&format=plain&rnd=new
```

`format=plain` is what strips away the surrounding page, and `rnd=new` is what stops a cached value coming back — leave both in.
This replaces the Google search widget the earlier instances used, which required typing a query, and which is a third-party interface that can change shape without warning.

One thing to watch: a fair coin does not give you a balanced room.
With twelve students you will sometimes get a 4/8 split, which leaves half of Group B queueing behind very few Group A partners at step 1.
Ask for a show of hands after the roll, and if it is badly lopsided, just move a few people across — the activity does not care how they were assigned, only that the ratio is roughly even.

**Why the two groups stayed.** Forking from a classmate rather than from you is what makes the network graph a tree instead of a fan, and it gives Group A a merge to perform rather than only a pull request to open. It costs you a few minutes of Group B waiting at step 1, which the fork-network page covers.
