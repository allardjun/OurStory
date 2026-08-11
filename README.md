# Let's write a short story together

Everyone in this room is going to change one line of the same story, at the same time, and we are going to end up with a single story that has all of our edits in it.

You do not need to install anything.
Everything happens in this web page.
If you get lost at any point, put your hand up, and then just watch until the next step — you can catch up at any step, and nothing you do can break anything.

**What you will have done by the end:**

1. Made your own copy of somebody else's project (a **fork**).
2. Changed a file and saved that change with a message explaining it (a **commit**).
3. Asked someone to take your change into their copy (a **pull request**).
4. Had your change collide with somebody else's, and sorted it out (a **merge conflict**). This is the interesting one.
5. Seen your name on the line you wrote, in a history that will still be there in ten years.

---

## Step 0 — Which group are you in?

**[Click here to roll a 1 or a 2.](https://www.random.org/integers/?num=1&min=1&max=2&col=1&base=10&format=plain&rnd=new)**

That page shows you a single number and nothing else.

- **You rolled 1: you are in Group A.**
- **You rolled 2: you are in Group B.**

Remember which one you are.
Group A goes first, and Group B copies from Group A.

## Step 1 — Everyone: make your copy now

Do this now, even if you are in Group B, and do it *before* anybody starts merging.
This matters: the whole point is that we all start from the same version and then collide.

**Group A:** click the **Fork** button at the top right of this page, then click **Create fork**.

**Group B:** you are going to fork from a classmate in Group A instead.

- Click the **number next to the Fork button** at the top of this page.
- You will see a list of people who have already forked it. Pick any one of them.
- Open their copy, and click **Fork** on *their* page.

Now check the name at the very top of the page.
It should say **your username**, with a small note underneath saying "forked from" someone else.
If it does not say your username, you are still looking at somebody else's copy — go back and click Fork.

## Step 2 — Everyone: pick a line and change it

In **your own copy**:

- Click the file **`story.md`**.
- Click the **pencil icon** near the top right.
- **Pick any one line, anywhere in the story**, and rewrite it to say whatever you like.

Keep it to that one line, and keep it printable — this is a public web page that will outlive the class.

Do not coordinate with anybody about which line to take.
If you and somebody else happen to choose the same one, that is not a problem you have caused; it is the most interesting thing that can happen today, and step 4 is about what to do next.

Then scroll down to **Commit changes**:

- In the first box, write a short description of what you changed, like `made the frog purple`.
- Click the green **Commit changes** button.

That message is not decoration. In six months it is the only thing that will explain why you did that.

## Step 3 — Group B: send your change to your Group A partner

- Click the **Pull requests** tab at the top.
- Click **New pull request**.
- You should see your change on the right, and your Group A partner's copy on the left.
- Click **Create pull request**, then **Create pull request** again.

Now go and tell your Group A partner you have sent it.

## Step 4 — Group A: take in your partners' changes

You will have a pull request waiting under the **Pull requests** tab.
Open it and click **Merge pull request**.

**If it says "This branch has conflicts that must be resolved" — good.**
That is the most useful thing that can happen today, and it means you and your partner both changed the same line.
Nothing is broken and nothing is lost.

- Click **Resolve conflicts**.
- You will see both versions of the line, wrapped in marker lines that look like `<<<<<<<`, `=======` and `>>>>>>>`.
- Decide what that line should say. You can keep yours, keep theirs, or write a new line combining both.
- **Delete the three marker lines as well.** Nothing starting with `<<<<<<<`, `=======` or `>>>>>>>` should be left.
- Click **Mark as resolved**, then **Commit merge**.

## Step 5 — Everyone in Group A: send everything up to the instructor

Same as step 3: **Pull requests** → **New pull request** → **Create pull request**.

Your instructor will merge these one at a time on the screen, and you will watch several of them conflict.
If yours conflicts, you can fix it yourself with the **Resolve conflicts** button, exactly as in step 4.

## Step 6 — Everyone: watch it come together

There is a link to the story website in the **About** box at the top right of the instructor's repository.
It has three pages:

- **The story** — the whole thing, as it stands right now.
- **Who wrote what** — every line, coloured by whose it is. Find yours.
- **The tree** — every copy, every change, and every merge, as one picture.

That website is rebuilt automatically every single time a change is merged, by a program that runs on GitHub's computers rather than anybody's laptop.
The green tick you saw on your pull request came from the same place: it is a small program that checks the story still makes sense before it is allowed in.

---

## If you want to keep going

Your copy is now behind the instructor's, because it does not have anybody else's edits.
On your repository's front page, click **Sync fork** and then **Update branch** to pull everyone else's work into your copy.

If you would like to try the same thing without the buttons, click the green **Code** button, then **Codespaces**, then **Create codespace on main**.
That gives you a full computer in your browser with a terminal in it, and no installation.
[CHEATSHEET.md](CHEATSHEET.md) has the handful of commands that do everything you just did by clicking.

Once you are in there, this one is worth running:

```bash
./scripts/classmates.sh     # find everyone else's copy and pull it into yours
./scripts/tree.sh           # then draw the entire class as one picture
```
