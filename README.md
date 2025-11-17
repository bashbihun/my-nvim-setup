# 🚀 Neovim Config - Java & Kotlin Development

Config Neovim modern untuk Java dan Kotlin development dengan fitur lengkap seperti VSCode.

## 📋 Requirements

### 1. Neovim (minimal v0.8)
```bash
# Ubuntu/Debian
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt update
sudo apt install neovim

# macOS
brew install neovim

# Arch Linux
sudo pacman -S neovim
```

### 2. Java JDK
```bash
# Ubuntu/Debian
sudo apt install default-jdk

# macOS
brew install openjdk

# Arch Linux
sudo pacman -S jdk-openjdk
```

### 3. Kotlin Compiler
```bash
# Ubuntu/Debian
sudo snap install kotlin --classic

# macOS
brew install kotlin

# Arch Linux
sudo pacman -S kotlin
```

### 4. Git
```bash
sudo apt install git      # Ubuntu/Debian
brew install git          # macOS
sudo pacman -S git        # Arch Linux
```

### 5. Nerd Font (untuk icons)
Download dan install: https://www.nerdfonts.com/
Recommended: `JetBrainsMono Nerd Font`

## 📦 Installation

### 1. Backup config lama (jika ada)
```bash
mv ~/.config/nvim ~/.config/nvim.backup
```

### 2. Buat struktur folder
```bash
mkdir -p ~/.config/nvim/lua/{core,plugins,utils}
```

### 3. Copy files ke lokasi yang sesuai

**File struktur:**
```
~/.config/nvim/
├── init.lua
├── lua/
│   ├── core/
│   │   ├── options.lua
│   │   ├── keymaps.lua
│   │   └── autocmds.lua
│   ├── plugins/
│   │   ├── init.lua
│   │   ├── lsp.lua
│   │   ├── cmp.lua
│   │   ├── treesitter.lua
│   │   ├── telescope.lua
│   │   ├── nvim-tree.lua
│   │   ├── git.lua
│   │   └── ui.lua
│   └── utils/
│       ├── java.lua
│       ├── kotlin.lua
│       └── projects.lua
└── README.md
```

### 4. Install plugins
```bash
nvim
```
Plugins akan otomatis di-install oleh Lazy.nvim pada first run.

## ⌨️ Keybindings

### File & Project Management
| Key | Action |
|-----|--------|
| `Space + e` | Toggle file explorer |
| `Space + a` | Create new file |
| `Space + A` | Create new folder |
| `Space + np` | Create new project |
| `Ctrl + p` | Find files (fuzzy search) |
| `Space + ff` | Find files |
| `Space + fg` | Search in files (live grep) |
| `Space + fb` | Find buffers |
| `Space + fr` | Recent files |

### Coding
| Key | Action |
|-----|--------|
| `F5` | Quick run (Java/Kotlin) |
| `Space + jr` | Java run |
| `Space + jb` | Java build |
| `Space + jt` | Java test |
| `Space + kr` | Kotlin run |
| `Space + kb` | Kotlin build |
| `Space + kt` | Kotlin test |
| `gd` | Go to definition |
| `K` | Hover documentation |
| `Space + ca` | Code actions |
| `Space + rn` | Rename symbol |
| `gr` | Find references |

### Spring Boot
| Key | Action |
|-----|--------|
| `Space + sr` | Spring Boot run |
| `Space + sb` | Spring Boot build |
| `Space + st` | Spring Boot test |
| `Space + sd` | Spring Boot dev mode |

### Git
| Key | Action |
|-----|--------|
| `Space + gb` | Git blame |
| `Space + gd` | Git diff |
| `Space + gp` | Preview changes |
| `Space + gg` | Git status |
| `Space + gc` | Git commits |
| `Space + gB` | Git branches |
| `Space + gs` | Stage hunk |
| `Space + gr` | Reset hunk |
| `]c` | Next change |
| `[c` | Previous change |

### Buffer/Tab Navigation
| Key | Action |
|-----|--------|
| `Tab` | Next buffer |
| `Shift + Tab` | Previous buffer |
| `Space + bd` | Close buffer |
| `Space + 1-5` | Jump to buffer 1-5 |

### Terminal
| Key | Action |
|-----|--------|
| `Space + t` | Open terminal (choose split) |
| `Esc` | Exit terminal mode |

### Window Navigation
| Key | Action |
|-----|--------|
| `Ctrl + h/j/k/l` | Navigate windows |
| `Ctrl + Arrow` | Resize windows |

### General
| Key | Action |
|-----|--------|
| `Space + w` | Save file |
| `Space + q` | Quit |
| `Esc` | Clear search highlight |

## 🎨 Features

✅ **LSP Support** - Autocomplete, go to definition, diagnostics  
✅ **Syntax Highlighting** - Treesitter  
✅ **Git Integration** - GitSigns with visual indicators  
✅ **Fuzzy Finder** - Telescope (like Ctrl+P in VSCode)  
✅ **File Explorer** - nvim-tree with icons  
✅ **Tab Bar** - bufferline with file icons  
✅ **Status Bar** - lualine with Git info  
✅ **Terminal** - Integrated terminal (horizontal/vertical)  
✅ **Project Templates** - Auto-generate Java/Kotlin projects  
✅ **Auto Build** - Output ke folder `bin/`  

## 📁 Project Structure

Saat create project baru, struktur yang dibuat:

### Java Project
```
my-java-app/
├── src/
│   ├── main/java/com/example/
│   │   └── Main.java
│   └── test/java/com/example/
├── bin/              # Compiled output
├── lib/              # External libraries
├── build.gradle
├── .gitignore
└── README.md
```

### Kotlin Project
```
my-kotlin-app/
├── src/
│   ├── main/kotlin/com/example/
│   │   └── Main.kt
│   └── test/kotlin/com/example/
├── bin/              # Compiled output
├── lib/              # External libraries
├── build.gradle.kts
├── settings.gradle.kts
├── .gitignore
└── README.md
```

## 🔧 Customization

Edit file di folder `lua/` untuk customize:
- `core/options.lua` - Vim options
- `core/keymaps.lua` - Keybindings
- `plugins/*.lua` - Plugin configurations

## 🐛 Troubleshooting

### Plugin tidak ter-install
```bash
nvim
:Lazy sync
```

### LSP tidak jalan
```bash
nvim
:Mason
# Install jdtls dan kotlin-language-server
```

### Icons tidak muncul
Install Nerd Font dan set di terminal emulator.

## 📚 Resources

- [Neovim Docs](https://neovim.io/doc/)
- [Lazy.nvim](https://github.com/folke/lazy.nvim)
- [LSP Config](https://github.com/neovim/nvim-lspconfig)
- [Telescope](https://github.com/nvim-telescope/telescope.nvim)

## 🎉 Enjoy!

Config ini membuat Neovim jadi IDE modern untuk Java/Kotlin development!