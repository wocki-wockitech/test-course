# Solution

Step-by-step walkthrough.

## 1. See the conflict

```bash
cat file.txt
```

You'll see conflict markers:

```
<<<<<<< HEAD
line one (main)
=======
line one (feature)
>>>>>>> feature
```

## 2. Edit the file

Open `file.txt` in any editor (the sandbox provides `nano` and `vim`):

```bash
nano file.txt
```

Replace the entire content with the expected resolved line:

```
line one (resolved)
```

Save and exit.

## 3. Stage and commit

```bash
git add file.txt
git commit -m "resolve merge conflict"
```

## 4. Verify

```bash
git status   # should say "working tree clean"
cat file.txt # should show: line one (resolved)
```

Click **Check** — the verifier will confirm the result.
