# Linking dotfiles with Stow
#
.DEFAULT_GOAL := arch

# Platform-specific packages
LINUX = bat \
chrome claude clipcat codex curl \
dunst \
fcitx5-rime feh font \
gemini ghostty git \
i3wm \
neofetch nitrogen npm \
pacman PaoPaoDNS picom PipeWire podman polybar proxychains python \
ranger redshift ripgrep rofi \
shell shellcheck ssh stow sxhkd \
termite tmux \
urxvt \
vscode \
wget \
xorg

.PHONY: linux clean

linux: ## Setup all symlinks
	stow $(LINUX)

clean: ## Remove all symlinks
	stow -D $(LINUX)

arch: ## Backup Arch Linux packages
	pacman -Qqen | grep -v -f <(pacman -Qqm) > ./scripts/archlinux/pkg_native
	pacman -Qqem | grep -v "debug" | sort > ./scripts/archlinux/pkg_aur

arch-install: ## Install Arch Linux packages
	sudo pacman -S --needed - < ./scripts/archlinux/pkg_native
	yay -S --needed --noconfirm - < ./scripts/archlinux/pkg_aur

arch-orphans: ## List orphaned packages → arch-orphans.txt
	./scripts/arch-maintenance.sh orphans

arch-cleanup: ## Remove orphaned packages (after review)
	./scripts/arch-maintenance.sh cleanup

arch-package-check: ## Analyze all packages → arch-package-analysis.txt
	./scripts/arch-maintenance.sh package-check

arch-check-deps: ## Check what depends on a package
	./scripts/arch-maintenance.sh check-deps

arch-clean-cache: ## Clean package cache (keeps 3 versions)
	./scripts/arch-maintenance.sh clean-cache

omz-init: ## Install oh-my-zsh
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" #install oh-my-zsh
	git clone --depth=1 https://github.com/spaceship-prompt/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt"
	ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"

tmux-init: ## Install tmux
	rm -rf ~/.config/tmux/plugins
	tmux new-session -d && tmux kill-session
	mkdir -p ~/.config/tmux/plugins
	git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm 2>/dev/null || true
	~/.config/tmux/plugins/tpm/bin/install_plugins

#TODO
post-archlinux-install:
	arch-install
	cp ./stow/.stowrc ~/.stowrc
	linux
	omz-init
	tmux-init

help: ## Show all Makefile targets
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
