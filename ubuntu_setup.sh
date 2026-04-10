#!/usr/bin/env bash

set -e

echo "🔄 Actualizando sistema..."
sudo apt update -y

# =========================

# 📦 Dependencias base

# =========================

echo "📦 Instalando dependencias base..."
sudo apt install -y ca-certificates curl gnupg lsb-release wget software-properties-common apt-transport-https build-essential

# =========================

# 🐙 Git

# =========================

if command -v git >/dev/null 2>&1; then
echo "✅ Git ya está instalado: $(git --version)"
else
echo "🐙 Instalando Git..."
sudo apt install -y git
fi

# =========================

# 🐳 Docker

# =========================

if command -v docker >/dev/null 2>&1; then
echo "✅ Docker ya está instalado: $(docker --version)"
else
echo "🐳 Instalando Docker..."

sudo install -m 0755 -d /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | 
sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo $VERSION_CODENAME) stable" | 
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update -y

sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo usermod -aG docker $USER
fi

# =========================

# 💻 Zsh + Oh My Zsh

# =========================

if command -v zsh >/dev/null 2>&1; then
echo "✅ Zsh ya está instalado"
else
echo "💻 Instalando Zsh..."
sudo apt install -y zsh
fi

if [ -d "$HOME/.oh-my-zsh" ]; then
echo "✅ Oh My Zsh ya está instalado"
else
echo "✨ Instalando Oh My Zsh..."
RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# =========================

# 🔌 Plugins Zsh

# =========================

ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}

install_plugin () {
if [ ! -d "$2" ]; then
echo "➕ Instalando $1..."
git clone $3 $2
else
echo "✅ $1 ya está instalado"
fi
}

install_plugin "autosuggestions" "$ZSH_CUSTOM/plugins/zsh-autosuggestions" "https://github.com/zsh-users/zsh-autosuggestions"
install_plugin "syntax-highlighting" "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" "https://github.com/zsh-users/zsh-syntax-highlighting"
install_plugin "completions" "$ZSH_CUSTOM/plugins/zsh-completions" "https://github.com/zsh-users/zsh-completions"
install_plugin "z" "$ZSH_CUSTOM/plugins/zsh-z" "https://github.com/agkozak/zsh-z"

# fzf

if [ -d "$HOME/.fzf" ]; then
echo "✅ fzf ya está instalado"
else
echo "🔍 Instalando fzf..."
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all
fi

# Plugins en .zshrc

echo "⚙️ Configurando plugins..."
sed -i 's/^plugins=.*/plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-completions fzf zsh-z)/' ~/.zshrc || true

# =========================

# 🧠 VS Code

# =========================

if command -v code >/dev/null 2>&1; then
echo "✅ VS Code ya está instalado"
else
echo "🧠 Instalando VS Code..."

wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg

sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg

echo "deb [arch=amd64,arm64 signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | 
sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null

sudo apt update -y
sudo apt install -y code
fi

# =========================
# 🔑 SSH Key (para Docker/Git)
# =========================
if [ -f "$HOME/.ssh/id_ed25519" ]; then
  echo "✅ SSH key ya existe"
else
  echo "🔑 Generando SSH key..."
  mkdir -p ~/.ssh
  ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -N ""

  echo "📋 Tu clave pública:"
  cat ~/.ssh/id_ed25519.pub
fi

echo ""
echo "🎉 Setup completo!"
echo "👉 Ejecuta: newgrp docker"
echo "👉 Reinicia terminal para Zsh"
