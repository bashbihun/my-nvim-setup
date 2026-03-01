-- ========================================
-- JavaScript/TypeScript Utility Functions
-- File: ~/.config/nvim/lua/utils/javascript.lua
-- ========================================

-- Detect runtime (Node.js, Bun, Deno)
function DetectJSRuntime()
  if vim.fn.filereadable("bun.lockb") == 1 or vim.fn.filereadable("bunfig.toml") == 1 then
    return "bun"
  elseif vim.fn.filereadable("deno.json") == 1 or vim.fn.filereadable("deno.jsonc") == 1 then
    return "deno"
  else
    return "node"
  end
end

-- Detect package manager
function DetectPackageManager()
  if vim.fn.filereadable("bun.lockb") == 1 then
    return "bun"
  elseif vim.fn.filereadable("pnpm-lock.yaml") == 1 then
    return "pnpm"
  elseif vim.fn.filereadable("yarn.lock") == 1 then
    return "yarn"
  else
    return "npm"
  end
end

-- Run JavaScript/TypeScript file
function RunJS()
  local file = vim.fn.expand("%:p")
  local runtime = DetectJSRuntime()
  local cmd

  if runtime == "bun" then
    cmd = "bun run " .. file
  elseif runtime == "deno" then
    cmd = "deno run --allow-all " .. file
  else
    cmd = "node " .. file
  end

  print("🚀 Running with " .. runtime .. "...")

  if vim.g.test_output_mode == "split" then
    RunTestWithOutput(cmd)
  else
    vim.cmd("!" .. cmd)
  end
end

-- Run dev server
function RunDevServer()
  local pm = DetectPackageManager()
  local cmd = pm .. " run dev"

  print("🔥 Starting dev server with " .. pm .. "...")

  if vim.g.test_output_mode == "split" then
    RunTestWithOutput(cmd)
  else
    vim.cmd("!" .. cmd)
  end
end

-- Build project
function BuildJS()
  local pm = DetectPackageManager()
  local cmd = pm .. " run build"

  print("🔨 Building project with " .. pm .. "...")
  vim.cmd("!" .. cmd)
end

-- Run tests
function TestJS()
  local pm = DetectPackageManager()

  -- Detect test framework
  local package_json = vim.fn.json_decode(vim.fn.readfile("package.json"))
  local test_cmd = pm .. " test"

  if package_json and package_json.scripts and package_json.scripts.test then
    test_cmd = pm .. " run test"
  end

  print("🧪 Running tests with " .. pm .. "...")

  if vim.g.test_output_mode == "split" then
    RunTestWithOutput(test_cmd)
  else
    vim.cmd("!" .. test_cmd)
  end
end

-- Run specific test file
function TestJSFile()
  local file = vim.fn.expand("%:p")
  local pm = DetectPackageManager()

  if not file:match("%.test%.") and not file:match("%.spec%.") then
    print("❌ Not a test file! Test files should contain .test. or .spec.")
    return
  end

  local cmd = pm .. " test " .. file

  print("🧪 Running test file...")

  if vim.g.test_output_mode == "split" then
    RunTestWithOutput(cmd)
  else
    vim.cmd("!" .. cmd)
  end
end

-- Install dependencies
function InstallDeps()
  local pm = DetectPackageManager()

  print("📦 Installing dependencies with " .. pm .. "...")
  vim.cmd("!" .. pm .. " install")
end

-- Format with Prettier
function FormatJS()
  print("🎨 Formatting with Prettier...")
  vim.cmd("!npx prettier --write " .. vim.fn.expand("%:p"))
  vim.cmd("edit!")
  print("✅ File formatted!")
end

-- Lint with ESLint
function LintJS()
  print("🔍 Linting with ESLint...")
  vim.cmd("!npx eslint " .. vim.fn.expand("%:p"))
end

-- Type check (TypeScript)
function TypeCheck()
  if vim.fn.filereadable("tsconfig.json") == 0 then
    print("❌ No tsconfig.json found!")
    return
  end

  print("🔍 Type checking with TypeScript...")
  vim.cmd("!npx tsc --noEmit")
end

-- Create React project
function CreateReactProject()
  vim.ui.input({ prompt = "Project name: " }, function(project_name)
    if not project_name or project_name == "" then return end

    vim.ui.select({ "Vite + React", "Next.js", "Create React App" }, {
      prompt = "Select template:"
    }, function(choice)
      if choice == "Vite + React" then
        vim.cmd("!npm create vite@latest " .. project_name .. " -- --template react-ts")
      elseif choice == "Next.js" then
        vim.cmd("!npx create-next-app@latest " .. project_name .. " --typescript")
      elseif choice == "Create React App" then
        vim.cmd("!npx create-react-app " .. project_name .. " --template typescript")
      end

      print("✅ React project created: " .. project_name)
      print("📂 cd " .. project_name .. " && nvim")
    end)
  end)
end

-- Create Vue project
function CreateVueProject()
  vim.ui.input({ prompt = "Project name: " }, function(project_name)
    if not project_name or project_name == "" then return end

    vim.cmd("!npm create vue@latest " .. project_name)
    print("✅ Vue project created: " .. project_name)
    print("📂 cd " .. project_name .. " && nvim")
  end)
end

-- Create Svelte project
function CreateSvelteProject()
  vim.ui.input({ prompt = "Project name: " }, function(project_name)
    if not project_name or project_name == "" then return end

    vim.cmd("!npm create svelte@latest " .. project_name)
    print("✅ Svelte project created: " .. project_name)
    print("📂 cd " .. project_name .. " && nvim")
  end)
end

-- Create Node.js project
function CreateNodeProject()
  vim.ui.input({ prompt = "Project name: " }, function(project_name)
    if not project_name or project_name == "" then return end

    local base_dir = vim.fn.getcwd() .. "/" .. project_name

    -- Create structure
    vim.fn.mkdir(base_dir .. "/src", "p")
    vim.fn.mkdir(base_dir .. "/tests", "p")

    -- Create index.ts
    local index_content = [[import express from 'express';

const app = express();
const PORT = 3000;

app.use(express.json());

app.get('/', (req, res) => {
  res.json({ message: 'Hello from Node.js + TypeScript!' });
});

app.listen(PORT, () => {
  console.log(`🚀 Server running on http://localhost:${PORT}`);
});
]]
    vim.fn.writefile(vim.split(index_content, "\n"), base_dir .. "/src/index.ts")

    -- Create package.json
    local package_json = [[{
  "name": "]] .. project_name .. [[",
  "version": "1.0.0",
  "type": "module",
  "scripts": {
    "dev": "tsx watch src/index.ts",
    "build": "tsc",
    "start": "node dist/index.js",
    "test": "vitest"
  },
  "dependencies": {
    "express": "^4.18.2"
  },
  "devDependencies": {
    "@types/express": "^4.17.21",
    "@types/node": "^20.10.0",
    "tsx": "^4.7.0",
    "typescript": "^5.3.3",
    "vitest": "^1.0.4"
  }
}
]]
    vim.fn.writefile(vim.split(package_json, "\n"), base_dir .. "/package.json")

    -- Create tsconfig.json
    local tsconfig = [[{
  "compilerOptions": {
    "target": "ES2022",
    "module": "ESNext",
    "moduleResolution": "bundler",
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist"]
}
]]
    vim.fn.writefile(vim.split(tsconfig, "\n"), base_dir .. "/tsconfig.json")

    -- Create .gitignore
    local gitignore = [[node_modules/
dist/
.env
*.log
.DS_Store
]]
    vim.fn.writefile(vim.split(gitignore, "\n"), base_dir .. "/.gitignore")

    -- Create README
    local readme = [[# ]] .. project_name .. [[

Node.js + TypeScript + Express

## Install
```bash
npm install
```

## Dev
```bash
npm run dev
```

## Build
```bash
npm run build
npm start
```
]]
    vim.fn.writefile(vim.split(readme, "\n"), base_dir .. "/README.md")

    print("✅ Node.js project created: " .. project_name)
    vim.cmd("cd " .. base_dir)
    vim.cmd("edit src/index.ts")
  end)
end

-- Keymappings untuk JS/TS
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
  callback = function()
    local filename = vim.fn.expand("%:t")

    if filename:match("%.test%.") or filename:match("%.spec%.") then
      -- Test file
      vim.keymap.set("n", "<leader>nr", ":lua RunJS()<CR>", { buffer = true, desc = "Node Run" })
      vim.keymap.set("n", "<leader>nt", ":lua TestJS()<CR>", { buffer = true, desc = "Node Test All" })
      vim.keymap.set("n", "<leader>nf", ":lua TestJSFile()<CR>", { buffer = true, desc = "Node Test File" })
      vim.keymap.set("n", "<leader>no", ":lua ToggleTestOutputMode()<CR>", { buffer = true, desc = "Toggle Output" })
    else
      -- Regular file
      vim.keymap.set("n", "<F5>", ":lua RunJS()<CR>", { buffer = true, desc = "Run JS/TS" })
      vim.keymap.set("n", "<leader>nr", ":lua RunJS()<CR>", { buffer = true, desc = "Node Run" })
      vim.keymap.set("n", "<leader>nd", ":lua RunDevServer()<CR>", { buffer = true, desc = "Node Dev" })
      vim.keymap.set("n", "<leader>nb", ":lua BuildJS()<CR>", { buffer = true, desc = "Node Build" })
      vim.keymap.set("n", "<leader>nt", ":lua TestJS()<CR>", { buffer = true, desc = "Node Test" })
    end

    -- Common keybindings
    vim.keymap.set("n", "<leader>nF", ":lua FormatJS()<CR>", { buffer = true, desc = "Format" })
    vim.keymap.set("n", "<leader>nL", ":lua LintJS()<CR>", { buffer = true, desc = "Lint" })
    vim.keymap.set("n", "<leader>ni", ":lua InstallDeps()<CR>", { buffer = true, desc = "Install Deps" })

    -- TypeScript specific
    if vim.bo.filetype == "typescript" or vim.bo.filetype == "typescriptreact" then
      vim.keymap.set("n", "<leader>nT", ":lua TypeCheck()<CR>", { buffer = true, desc = "Type Check" })
    end
  end
})

-- Keymappings untuk Vue
vim.api.nvim_create_autocmd("FileType", {
  pattern = "vue",
  callback = function()
    vim.keymap.set("n", "<F5>", ":lua RunDevServer()<CR>", { buffer = true, desc = "Vue Dev" })
    vim.keymap.set("n", "<leader>vd", ":lua RunDevServer()<CR>", { buffer = true, desc = "Vue Dev" })
    vim.keymap.set("n", "<leader>vb", ":lua BuildJS()<CR>", { buffer = true, desc = "Vue Build" })
    vim.keymap.set("n", "<leader>vt", ":lua TestJS()<CR>", { buffer = true, desc = "Vue Test" })
  end
})

-- Keymappings untuk Svelte
vim.api.nvim_create_autocmd("FileType", {
  pattern = "svelte",
  callback = function()
    vim.keymap.set("n", "<F5>", ":lua RunDevServer()<CR>", { buffer = true, desc = "Svelte Dev" })
    vim.keymap.set("n", "<leader>sd", ":lua RunDevServer()<CR>", { buffer = true, desc = "Svelte Dev" })
    vim.keymap.set("n", "<leader>sb", ":lua BuildJS()<CR>", { buffer = true, desc = "Svelte Build" })
    vim.keymap.set("n", "<leader>st", ":lua TestJS()<CR>", { buffer = true, desc = "Svelte Test" })
  end
})

print("✅ JavaScript/TypeScript utilities loaded!")
