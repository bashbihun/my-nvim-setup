-- ========================================
-- Golang Utility Functions
-- File: ~/.config/nvim/lua/utils/golang.lua
-- ========================================

-- Fungsi untuk compile dan run Go
function CompileAndRunGo()
  local file = vim.fn.expand("%:p")
  
  print("🐹 Running Go program...")
  
  if vim.g.test_output_mode == "split" then
    RunTestWithOutput("go run " .. file)
  else
    vim.cmd("!go run " .. file)
  end
end

-- Fungsi untuk build Go
function BuildGo()
  local file = vim.fn.expand("%:t:r")
  local bin_dir = vim.fn.getcwd() .. "/bin"
  
  vim.fn.mkdir(bin_dir, "p")
  
  print("🔨 Building Go program...")
  vim.cmd("!go build -o " .. bin_dir .. "/" .. file)
  print("✅ Build complete: " .. bin_dir .. "/" .. file)
end

-- Fungsi untuk test Go
function TestGo()
  print("🧪 Running Go tests...")
  
  if vim.g.test_output_mode == "split" then
    RunTestWithOutput("go test -v ./...")
  else
    vim.cmd("!go test -v ./...")
  end
end

-- Fungsi untuk test file saat ini
function TestGoFile()
  local file = vim.fn.expand("%:p")
  
  if not file:match("_test%.go$") then
    print("❌ Not a test file! Test files should end with '_test.go'")
    return
  end
  
  print("🧪 Running tests in current file...")
  
  if vim.g.test_output_mode == "split" then
    RunTestWithOutput("go test -v " .. file)
  else
    vim.cmd("!go test -v " .. file)
  end
end

-- Fungsi untuk test function saat ini
function TestGoFunction()
  local file = vim.fn.expand("%:p")
  
  if not file:match("_test%.go$") then
    print("❌ Not a test file!")
    return
  end
  
  -- Get current line and find test function name
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
  
  -- Search upward for test function
  local test_name = nil
  
  for i = cursor_line, 1, -1 do
    local line = lines[i]
    
    -- Find test function: func TestXxx(t *testing.T)
    local name = line:match("^func%s+(Test%w+)%s*%(")
    if name then
      test_name = name
      break
    end
    
    -- Stop if we hit another function
    if line:match("^func%s+") and not line:match("^func%s+Test") then
      break
    end
  end
  
  if not test_name then
    print("❌ No test function found! Make sure cursor is inside a Test* function")
    return
  end
  
  print("🧪 Running test: " .. test_name)
  
  if vim.g.test_output_mode == "split" then
    RunTestWithOutput("go test -v -run " .. test_name)
  else
    vim.cmd("!go test -v -run " .. test_name)
  end
end

-- Fungsi untuk format Go code
function FormatGo()
  print("🎨 Formatting Go code...")
  vim.cmd("!gofmt -w " .. vim.fn.expand("%:p"))
  vim.cmd("edit!")
  print("✅ Code formatted!")
end

-- Fungsi untuk run Go dengan race detector
function RunGoRace()
  local file = vim.fn.expand("%:p")
  print("🏁 Running with race detector...")
  vim.cmd("!go run -race " .. file)
end

-- Fungsi untuk install dependencies
function GoModTidy()
  print("📦 Running go mod tidy...")
  vim.cmd("!go mod tidy")
  print("✅ Dependencies updated!")
end

-- Fungsi untuk create Go project
function CreateGoProject()
  vim.ui.input({ prompt = "Project name: " }, function(project_name)
    if not project_name or project_name == "" then return end
    
    vim.ui.input({ prompt = "Module path (e.g., github.com/user/project): " }, function(module_path)
      if not module_path or module_path == "" then 
        module_path = project_name
      end

      local base_dir = vim.fn.getcwd() .. "/" .. project_name

      -- Buat struktur folder
      vim.fn.mkdir(base_dir .. "/cmd/" .. project_name, "p")
      vim.fn.mkdir(base_dir .. "/pkg", "p")
      vim.fn.mkdir(base_dir .. "/internal", "p")
      vim.fn.mkdir(base_dir .. "/api", "p")
      vim.fn.mkdir(base_dir .. "/configs", "p")
      vim.fn.mkdir(base_dir .. "/bin", "p")

      -- Buat main.go
      local main_content = [[package main

import (
	"fmt"
)

func main() {
	fmt.Println("Hello, Go!")
}
]]
      vim.fn.writefile(vim.split(main_content, "\n"), base_dir .. "/cmd/" .. project_name .. "/main.go")

      -- Buat go.mod
      vim.fn.system("cd " .. base_dir .. " && go mod init " .. module_path)

      -- Buat .gitignore
      local gitignore_content = [[# Binaries
bin/
*.exe
*.exe~
*.dll
*.so
*.dylib

# Test binary
*.test

# Output of go coverage tool
*.out

# Dependency directories
vendor/

# Go workspace file
go.work

# IDE
.idea/
.vscode/
*.swp
*.swo
]]
      vim.fn.writefile(vim.split(gitignore_content, "\n"), base_dir .. "/.gitignore")

      -- Buat README.md
      local readme_content = [[# ]] .. project_name .. [[

Go project created with Neovim

## Structure
```
├── cmd/]] .. project_name .. [[/    # Main applications
├── pkg/                  # Public libraries
├── internal/             # Private application code
├── api/                  # API definitions
├── configs/              # Configuration files
└── bin/                  # Compiled binaries
```

## Run
```bash
# With Neovim: Space + gr
# Or manually:
go run cmd/]] .. project_name .. [[/main.go
```

## Build
```bash
go build -o bin/]] .. project_name .. [[ cmd/]] .. project_name .. [[/main.go
```

## Test
```bash
go test -v ./...
```
]]
      vim.fn.writefile(vim.split(readme_content, "\n"), base_dir .. "/README.md")

      -- Buat Makefile
      local makefile_content = [[.PHONY: run build test clean

run:
	go run cmd/]] .. project_name .. [[/main.go

build:
	go build -o bin/]] .. project_name .. [[ cmd/]] .. project_name .. [[/main.go

test:
	go test -v ./...

clean:
	rm -rf bin/
	go clean

fmt:
	go fmt ./...

lint:
	golangci-lint run
]]
      vim.fn.writefile(vim.split(makefile_content, "\n"), base_dir .. "/Makefile")

      print("✅ Go project created: " .. project_name)
      vim.cmd("cd " .. base_dir)
      vim.cmd("edit cmd/" .. project_name .. "/main.go")
    end)
  end)
end

-- Keymapping untuk Go
vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    local filename = vim.fn.expand("%:t")
    
    if filename:match("_test%.go$") then
      -- Test file keybindings
      vim.keymap.set("n", "<leader>gr", ":lua CompileAndRunGo()<CR>", { buffer = true, desc = "Go Run" })
      vim.keymap.set("n", "<leader>gb", ":lua BuildGo()<CR>", { buffer = true, desc = "Go Build" })
      vim.keymap.set("n", "<leader>gt", ":lua TestGo()<CR>", { buffer = true, desc = "Go Test All" })
      vim.keymap.set("n", "<leader>gf", ":lua TestGoFile()<CR>", { buffer = true, desc = "Go Test File" })
      vim.keymap.set("n", "<leader>gm", ":lua TestGoFunction()<CR>", { buffer = true, desc = "Go Test Function" })
      vim.keymap.set("n", "<leader>go", ":lua ToggleTestOutputMode()<CR>", { buffer = true, desc = "Toggle Output" })
      
      print("🧪 Go test shortcuts: <leader>gt (all), <leader>gf (file), <leader>gm (function)")
    else
      -- Regular Go file keybindings
      vim.keymap.set("n", "<F5>", ":lua CompileAndRunGo()<CR>", { buffer = true, desc = "Go Run" })
      vim.keymap.set("n", "<leader>gr", ":lua CompileAndRunGo()<CR>", { buffer = true, desc = "Go Run" })
      vim.keymap.set("n", "<leader>gb", ":lua BuildGo()<CR>", { buffer = true, desc = "Go Build" })
      vim.keymap.set("n", "<leader>gt", ":lua TestGo()<CR>", { buffer = true, desc = "Go Test" })
      vim.keymap.set("n", "<leader>gR", ":lua RunGoRace()<CR>", { buffer = true, desc = "Go Run (race)" })
    end
    
    -- Common keybindings
    vim.keymap.set("n", "<leader>gF", ":lua FormatGo()<CR>", { buffer = true, desc = "Go Format" })
    vim.keymap.set("n", "<leader>gT", ":lua GoModTidy()<CR>", { buffer = true, desc = "Go Mod Tidy" })
  end
})

print("✅ Golang utilities loaded!")