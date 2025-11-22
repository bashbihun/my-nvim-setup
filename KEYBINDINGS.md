# ⌨️ Complete Keybindings Cheatsheet

All keyboard shortcuts for Neovim Java/Kotlin/Spring Boot setup.

---

## 🎯 General

| Key | Action | Description |
|-----|--------|-------------|
| `Space + w` | Save file | Write file |
| `Space + q` | Quit | Close current window |
| `Space + Q` | Quit all | Force quit all |
| `Esc` | Clear highlight | Clear search highlight |

---

## 📁 File Management

| Key | Action | Description |
|-----|--------|-------------|
| `Space + e` | Toggle file explorer | Open/close nvim-tree |
| `Space + a` | Create file | Create new file with path |
| `Space + A` | Create folder | Create new folder |
| `Space + np` | New project | Create Java/Kotlin/Spring Boot project |

---

## 🔍 Search & Navigation

| Key | Action | Description |
|-----|--------|-------------|
| `Ctrl + p` | Find files | Fuzzy file search (like VSCode) |
| `Space + ff` | Find files | Same as Ctrl+P |
| `Space + fg` | Live grep | Search text in all files |
| `Space + fb` | Find buffers | Search open buffers |
| `Space + fr` | Recent files | Recently opened files |
| `Space + fh` | Help tags | Search help documentation |

---

## 📑 Buffer/Tab Navigation

| Key | Action | Description |
|-----|--------|-------------|
| `Tab` | Next buffer | Go to next open file |
| `Shift + Tab` | Previous buffer | Go to previous open file |
| `Space + bd` | Close buffer | Close current file |
| `Space + 1` | Go to buffer 1 | Jump to first buffer |
| `Space + 2` | Go to buffer 2 | Jump to second buffer |
| `Space + 3` | Go to buffer 3 | Jump to third buffer |
| `Space + 4` | Go to buffer 4 | Jump to fourth buffer |
| `Space + 5` | Go to buffer 5 | Jump to fifth buffer |

---

## 🪟 Window Navigation

| Key | Action | Description |
|-----|--------|-------------|
| `Ctrl + h` | Go left | Move to left window |
| `Ctrl + j` | Go down | Move to bottom window |
| `Ctrl + k` | Go up | Move to top window |
| `Ctrl + l` | Go right | Move to right window |
| `Ctrl + ↑` | Increase height | Resize window taller |
| `Ctrl + ↓` | Decrease height | Resize window shorter |
| `Ctrl + ←` | Decrease width | Resize window narrower |
| `Ctrl + →` | Increase width | Resize window wider |

---

## 🖥️ Terminal

| Key | Action | Description |
|-----|--------|-------------|
| `Space + t` | Open terminal | Choose horizontal/vertical split |
| `Esc` (in terminal) | Exit terminal mode | Back to normal mode |

**Note:** Terminal opens with interactive menu to choose split direction.

---

## ☕ Java Commands

| Key | Action | Description |
|-----|--------|-------------|
| `F5` | Quick run | Compile and run current Java file |
| `Space + jr` | Java run | Compile and run Java file |
| `Space + jb` | Java build | Build entire Java project |
| `Space + jt` | Java test | Run JUnit tests |

**Active in:** `.java` files

---

## 🎯 Kotlin Commands

| Key | Action | Description |
|-----|--------|-------------|
| `F5` | Quick run | Compile and run current Kotlin file |
| `Space + kr` | Kotlin run | Compile and run Kotlin file |
| `Space + kb` | Kotlin build | Build entire Kotlin project |
| `Space + kt` | Kotlin test | Run Kotlin tests |

**Active in:** `.kt` files

---

## 🐹 Golang Commands

| Key | Action | Description |
|-----|--------|-------------|
| `F5` | Quick run | Run Go program |
| `Space + gr` | Go run | Run current file |
| `Space + gb` | Go build | Build to bin/ folder |
| `Space + gt` | Go test | Run all tests |
| `Space + gR` | Go run (race) | Run with race detector |
| `Space + gF` | Go format | Format code (gofmt) |
| `Space + gT` | Go mod tidy | Update dependencies |

**Testing (in _test.go files):**
| Key | Action | Description |
|-----|--------|-------------|
| `Space + gt` | Test all | Run all tests |
| `Space + gf` | Test file | Run tests in current file |
| `Space + gm` | Test function | Run test at cursor |
| `Space + go` | Toggle output | Split/inline output |

**Active in:** `.go` files

---

## 🍃 Spring Boot Commands

| Key | Action | Description |
|-----|--------|-------------|
| `Space + sr` | Spring Boot run | Run Spring Boot application |
| `Space + sb` | Spring Boot build | Build Spring Boot JAR |
| `Space + sd` | Spring Boot dev | Run with DevTools (hot reload) |

**Testing (in test files):**
| Key | Action | Description |
|-----|--------|-------------|
| `Space + st` | Run all tests | Run all tests in project |
| `Space + sc` | Run test class | Run all tests in current class |
| `Space + sm` | Run test method | Run test method at cursor |
| `Space + so` | Toggle output | Switch split/inline output mode |

**Active in:** Spring Boot projects (with pom.xml or build.gradle)

---

## 🔀 Git Integration

| Key | Action | Description |
|-----|--------|-------------|
| `Space + gg` | Git status | Show changed files |
| `Space + gc` | Git commits | Show commit history |
| `Space + gB` | Git branches | List and switch branches |
| `Space + gb` | Git blame | Show who edited this line |
| `Space + gd` | Git diff | Show changes in current file |
| `Space + gp` | Preview hunk | Preview Git changes |
| `Space + gs` | Stage hunk | Stage changes |
| `Space + gr` | Reset hunk | Discard changes |
| `Space + gu` | Undo stage | Undo staged changes |
| `]c` | Next change | Jump to next Git change |
| `[c` | Previous change | Jump to previous Git change |

---

## 🧠 LSP (Code Intelligence)

| Key | Action | Description |
|-----|--------|-------------|
| `gd` | Go to definition | Jump to where function/class is defined |
| `K` | Hover docs | Show documentation for symbol under cursor |
| `Space + rn` | Rename | Rename symbol across project |
| `Space + ca` | Code action | Show available code actions/fixes |
| `gr` | References | Find all references to symbol |
| `[d` | Previous diagnostic | Jump to previous error/warning |
| `]d` | Next diagnostic | Jump to next error/warning |

---

## 📝 Autocompletion

| Key | Action | Description |
|-----|--------|-------------|
| `Ctrl + Space` | Trigger completion | Show autocomplete suggestions |
| `Tab` | Next suggestion | Select next item |
| `Shift + Tab` | Previous suggestion | Select previous item |
| `Enter` | Confirm | Accept selected suggestion |
| `Ctrl + e` | Abort | Close completion menu |
| `Ctrl + b` | Scroll docs up | Scroll documentation backward |
| `Ctrl + f` | Scroll docs down | Scroll documentation forward |

---

## 🎨 nvim-tree (File Explorer)

**When in nvim-tree:**

| Key | Action | Description |
|-----|--------|-------------|
| `Enter` | Open file/folder | Open file or expand folder |
| `a` | Create | Create new file/folder |
| `d` | Delete | Delete file/folder |
| `r` | Rename | Rename file/folder |
| `x` | Cut | Cut file/folder |
| `c` | Copy | Copy file/folder |
| `p` | Paste | Paste file/folder |
| `R` | Refresh | Refresh tree |
| `H` | Toggle hidden | Show/hide hidden files |
| `?` | Help | Show all keybindings |
| `q` | Close | Close file explorer |

---

## 🚀 Quick Reference by Context

### **When editing Java file:**
```
F5          → Quick run
Space + jr  → Run Java
Space + jb  → Build project
Space + jt  → Test
gd          → Go to definition
K           → Show docs
```

### **When editing Kotlin file:**
```
F5          → Quick run
Space + kr  → Run Kotlin
Space + kb  → Build project
Space + kt  → Test
gd          → Go to definition
K           → Show docs
```

### **In Spring Boot project:**
```
Space + sr  → Run Spring Boot
Space + sb  → Build JAR
Space + st  → Run tests
Space + sd  → Dev mode (hot reload)
```

### **File management:**
```
Space + e   → File explorer
Ctrl + p    → Find files
Space + a   → New file
Space + np  → New project
Space + t   → Terminal (horizontal/vertical)
```

### **Git workflow:**
```
Space + gg  → Git status
Space + gb  → Git blame
Space + gp  → Preview changes
]c / [c     → Next/prev change
```

---

## 💡 Tips

### **Leader Key:**
- Leader = `Space`
- All custom shortcuts start with `Space`

### **Context-aware:**
- Java commands only work in `.java` files
- Kotlin commands only work in `.kt` files
- Spring Boot commands auto-detect project type

### **F5 is universal:**
- Works for both Java and Kotlin
- Quick compile and run current file

### **Combine with Vim motions:**
```
Space + jr  → Run Java
:w          → Save first
dd          → Delete line
yy          → Copy line
p           → Paste
u           → Undo
Ctrl + r    → Redo
```

---

## 📚 Learn More

- `:help` - Neovim help
- `:checkhealth` - Check configuration
- `:Mason` - Manage LSP servers
- `:Lazy` - Manage plugins
- `:LspInfo` - Check LSP status

---

## 🎯 Print This!

Save this cheatsheet for quick reference while coding! 🚀