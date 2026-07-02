# Git Troubleshooting Notes

## Issue: GitHub Authentication Failed (Password Not Supported)

### Error
```
remote: Invalid username or token.
Password authentication is not supported for Git operations.
fatal: Authentication failed
```

---

## Root Cause

I was using an HTTPS remote URL:

```
https://github.com/username/repo.git
```

GitHub no longer supports password authentication for Git over HTTPS.

---

## Fix

### 1. Check current remote
```bash
git remote -v
```

### 2. Change remote to SSH
```bash
git remote set-url origin git@github.com:username/repo.git
```

### 3. Verify SSH connection
```bash
ssh -T git@github.com
```

Expected:
```
Hi username! You've successfully authenticated.
```

### 4. Push again
```bash
git push -u origin master
```

---

## Key Learning

- GitHub does NOT accept passwords for Git operations
- SSH keys are the correct authentication method
- Always verify remote URL (HTTPS vs SSH)

---

## Prevention Rule

Before pushing, always run:
```bash
git remote -v
```

If it shows HTTPS  switch to SSH immediately.
