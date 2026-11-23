# My_Setups

Scripts to set up a fresh development machine in one command, so I don't have to repeat the same steps every time.

## ubuntu_setup.sh

Sets up an Ubuntu machine with the tools I use every day. It checks what is already installed and skips it.

| Tool | What it installs |
|---|---|
| Base packages | `build-essential`, `curl`, `wget`, `gnupg`, certificates… |
| Git | Version control |
| Vim | Text editor |
| Docker | Docker Engine, Docker Compose and Buildx (from Docker's official repository) |
| Zsh + Oh My Zsh | Shell with plugins: autosuggestions, syntax highlighting, completions, `z` and `fzf` |
| VS Code | Code editor (from Microsoft's official repository) |

### Usage

```bash
git clone https://github.com/JorgeMarquez05/My_Setups.git
cd My_Setups
chmod +x ubuntu_setup.sh
./ubuntu_setup.sh
```

> The script uses `sudo`, so it will ask for your password.
> After it finishes, log out and back in (or restart) so Zsh and the Docker group take effect.
