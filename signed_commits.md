# How to Sign Git Commits and Set Up Your Git Client

Signing your Git commits adds an extra layer of authenticity and security by allowing others to verify that the commits were made by you. This guide will walk you through setting up commit signing using GPG or SSH, configuring your Git client, and verifying your signed commits.

---

## Step 1: Choose a Signing Method
GitHub supports two methods for signing commits:

1. **GPG (GNU Privacy Guard)**: Traditional method using a GPG key pair.
2. **SSH (Secure Shell)**: Simplified signing using your existing SSH keys.

### Which Should You Use?
- Use **SSH** if you already use SSH for authentication with GitHub.
- Use **GPG** if you prefer traditional cryptographic signing or already have GPG keys set up.

---

## Step 2: Configure SSH Key for Signing (Recommended)

### 1. Ensure You Have an SSH Key
If you don’t already have an SSH key, generate one:
```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
```
This creates your key pair in `~/.ssh/`. Add the public key to GitHub via **Settings** → **SSH and GPG keys**.

### 2. Enable SSH Key Signing in GitHub
1. Go to [GitHub SSH Key Settings](https://github.com/settings/keys).
2. Ensure your SSH key is listed. If not, add your public key (`~/.ssh/id_ed25519.pub`).

### 3. Configure Git for SSH Signing
Run the following commands to enable SSH signing:
```bash
git config --global gpg.format ssh
git config --global user.signingkey ~/.ssh/id_ed25519
git config --global commit.gpgSign true
```
This tells Git to use your SSH key for signing commits and enables signing by default.

---

## Step 3: Configure GPG Key for Signing (Optional)

### 1. Install GPG
Ensure GPG is installed on your system:
```bash
sudo apt update && sudo apt install gnupg
```

### 2. Generate a New GPG Key
Run:
```bash
gpg --full-generate-key
```
Follow the prompts to:
- Choose key type: **RSA and RSA** (default).
- Key size: **4096 bits**.
- Expiration date: Choose as preferred.
- Provide your name and email (must match your GitHub email).

### 3. Export Your Public Key
Export the public key:
```bash
gpg --armor --export your_email@example.com
```
Copy the output and add it to GitHub via **Settings** → **SSH and GPG keys** → **New GPG Key**.

### 4. Configure Git for GPG Signing
Run:
```bash
gpg --list-secret-keys --keyid-format=long
```
Copy the `sec` key ID (e.g., `ABCDEF1234567890`) and configure Git:
```bash
git config --global user.signingkey ABCDEF1234567890
git config --global commit.gpgSign true
```
This enables GPG signing for all commits.

---

## Step 4: Verify Signed Commits

### 1. Make a Signed Commit
When signing is enabled globally, commits are signed automatically:
```bash
git commit -m "Your commit message"
```
To manually sign a commit:
```bash
git commit -S -m "Your commit message"
```

### 2. Verify the Commit
After pushing the commit, verify it on GitHub. Go to the repository, and the commit should display a **Verified** badge.

### 3. Troubleshooting Verification
- Ensure your email in Git (`git config user.email`) matches the email associated with your signing key and GitHub.
- If using GPG, ensure your key is uploaded to GitHub.

---

## Step 5: Test Your Setup
To test your configuration:

### SSH Signing Test:
```bash
git commit -S -m "Testing SSH signing"
git log --show-signature
```
You should see:
```
Good "SSH signature" made by...
```

### GPG Signing Test:
```bash
git commit -S -m "Testing GPG signing"
git log --show-signature
```
You should see:
```
Good signature from...
```

---

## Additional Tips

- To disable signing for a specific commit, use:
  ```bash
  git commit --no-gpg-sign -m "Commit without signing"
  ```

- To temporarily disable global signing, run:
  ```bash
  git config --global commit.gpgSign false
  ```

- Always keep your keys secure and backed up.

---

By following these steps, you can ensure that all your Git commits are signed and verified, enhancing your credibility and security in collaborative development environments.
