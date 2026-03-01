-- ========================================
-- Project Creation Utilities
-- File: ~/.config/nvim/lua/utils/projects.lua
-- ========================================

-- Fungsi untuk membuat file baru
function CreateNewFile()
  local ok, nvim_tree = pcall(require, "nvim-tree.api")
  local base_path

  if ok then
    local node = nvim_tree.tree.get_node_under_cursor()
    if node then
      if node.type == "directory" then
        base_path = node.absolute_path
      else
        base_path = vim.fn.fnamemodify(node.absolute_path, ":h")
      end
    end
  end

  if not base_path then
    base_path = vim.fn.getcwd()
  end

  vim.ui.input({ prompt = "New file (" .. base_path .. "): " }, function(input)
    if input and input ~= "" then
      local filepath = base_path .. "/" .. input
      local dir = vim.fn.fnamemodify(filepath, ":h")
      vim.fn.mkdir(dir, "p")
      vim.cmd("edit " .. filepath)
      print("✅ Created file: " .. filepath)
    end
  end)
end

-- Fungsi untuk membuat folder baru
function CreateNewFolder()
  -- Coba ambil path dari node nvim-tree yang sedang dikursor
  local ok, nvim_tree = pcall(require, "nvim-tree.api")
  local base_path

  if ok then
    local node = nvim_tree.tree.get_node_under_cursor()
    if node then
      if node.type == "directory" then
        base_path = node.absolute_path
      else
        -- Kalau cursor di file, ambil direktori parentnya
        base_path = vim.fn.fnamemodify(node.absolute_path, ":h")
      end
    end
  end

  -- Fallback ke cwd kalau nvim-tree tidak aktif
  if not base_path then
    base_path = vim.fn.getcwd()
  end

  vim.ui.input({ prompt = "New folder (" .. base_path .. "): " }, function(input)
    if input and input ~= "" then
      local folderpath = base_path .. "/" .. input
      vim.fn.mkdir(folderpath, "p")
      print("✅ Created folder: " .. folderpath)
      -- Refresh nvim-tree
      pcall(function() require("nvim-tree.api").tree.reload() end)
    end
  end)
end

-- Fungsi untuk buka terminal dengan pilihan split
function OpenTerminal()
  vim.ui.select(
    { "horizontal", "vertical" },
    { prompt = "Select terminal split:" },
    function(choice)
      if choice == "horizontal" then
        vim.cmd("split | terminal")
        vim.cmd("resize 15")
      elseif choice == "vertical" then
        vim.cmd("vsplit | terminal")
      end
      vim.cmd("startinsert")
    end
  )
end

-- Fungsi untuk create Java project
function CreateJavaProject()
  vim.ui.input({ prompt = "Project name: " }, function(project_name)
    if not project_name or project_name == "" then return end

    local base_dir = vim.fn.getcwd() .. "/" .. project_name

    -- Buat struktur folder
    vim.fn.mkdir(base_dir .. "/src/main/java/com/example", "p")
    vim.fn.mkdir(base_dir .. "/src/test/java/com/example", "p")
    vim.fn.mkdir(base_dir .. "/bin", "p")
    vim.fn.mkdir(base_dir .. "/lib", "p")

    -- Buat Main.java
    local main_content = [[package com.example;

public class Main {
    public static void main(String[] args) {
        System.out.println("Hello, Java!");
    }
}
]]
    vim.fn.writefile(vim.split(main_content, "\n"), base_dir .. "/src/main/java/com/example/Main.java")

    -- Buat build.gradle
    local gradle_content = [[plugins {
    id 'java'
    id 'application'
}

group = 'com.example'
version = '1.0-SNAPSHOT'

repositories {
    mavenCentral()
}

dependencies {
    testImplementation 'org.junit.jupiter:junit-jupiter:5.9.2'
}

application {
    mainClass = 'com.example.Main'
}

tasks.named('test') {
    useJUnitPlatform()
}
]]
    vim.fn.writefile(vim.split(gradle_content, "\n"), base_dir .. "/build.gradle")

    -- Buat .gitignore
    local gitignore_content = [[bin/
build/
.gradle/
*.class
*.jar
.idea/
*.iml
]]
    vim.fn.writefile(vim.split(gitignore_content, "\n"), base_dir .. "/.gitignore")

    -- Buat README.md
    local readme_content = [[# ]] .. project_name .. [[

Java project created with Neovim

## Run
```bash
# With Neovim: Space + r
# Or manually: gradle run
```
]]
    vim.fn.writefile(vim.split(readme_content, "\n"), base_dir .. "/README.md")

    print("✅ Java project created: " .. project_name)
    vim.cmd("cd " .. base_dir)
    vim.cmd("edit src/main/java/com/example/Main.java")
  end)
end

-- Fungsi untuk create Kotlin project
function CreateKotlinProject()
  vim.ui.input({ prompt = "Project name: " }, function(project_name)
    if not project_name or project_name == "" then return end

    local base_dir = vim.fn.getcwd() .. "/" .. project_name

    -- Buat struktur folder
    vim.fn.mkdir(base_dir .. "/src/main/kotlin/com/example", "p")
    vim.fn.mkdir(base_dir .. "/src/test/kotlin/com/example", "p")
    vim.fn.mkdir(base_dir .. "/bin", "p")
    vim.fn.mkdir(base_dir .. "/lib", "p")

    -- Buat Main.kt
    local main_content = [[package com.example

fun main() {
    println("Hello, Kotlin!")
}
]]
    vim.fn.writefile(vim.split(main_content, "\n"), base_dir .. "/src/main/kotlin/com/example/Main.kt")

    -- Buat build.gradle.kts
    local gradle_content = [[plugins {
    kotlin("jvm") version "1.9.20"
    application
}

group = "com.example"
version = "1.0-SNAPSHOT"

repositories {
    mavenCentral()
}

dependencies {
    testImplementation(kotlin("test"))
}

tasks.test {
    useJUnitPlatform()
}

kotlin {
    jvmToolchain(17)
}

application {
    mainClass.set("com.example.MainKt")
}
]]
    vim.fn.writefile(vim.split(gradle_content, "\n"), base_dir .. "/build.gradle.kts")

    -- Buat settings.gradle.kts
    local settings_content = [[rootProject.name = "]] .. project_name .. [["
]]
    vim.fn.writefile(vim.split(settings_content, "\n"), base_dir .. "/settings.gradle.kts")

    -- Buat .gitignore
    local gitignore_content = [[bin/
build/
.gradle/
*.class
*.jar
.idea/
*.iml
]]
    vim.fn.writefile(vim.split(gitignore_content, "\n"), base_dir .. "/.gitignore")

    -- Buat README.md
    local readme_content = [[# ]] .. project_name .. [[

Kotlin project created with Neovim

## Run
```bash
# With Neovim: Space + r
# Or manually: gradle run
```
]]
    vim.fn.writefile(vim.split(readme_content, "\n"), base_dir .. "/README.md")

    print("✅ Kotlin project created: " .. project_name)
    vim.cmd("cd " .. base_dir)
    vim.cmd("edit src/main/kotlin/com/example/Main.kt")
  end)
end

-- Fungsi untuk show project creation menu
function ShowProjectMenu()
  vim.ui.select(
    {
      "Java Project",
      "Kotlin Project",
      "Go Project",
      "Node.js + TypeScript",
      "React (Vite)",
      "Vue",
      "Svelte",
      "Spring Boot Java",
      "Spring Boot Kotlin",
      "Cancel"
    },
    { prompt = "Create new project:" },
    function(choice)
      if choice == "Java Project" then
        CreateJavaProject()
      elseif choice == "Kotlin Project" then
        CreateKotlinProject()
      elseif choice == "Go Project" then
        CreateGoProject()
      elseif choice == "Node.js + TypeScript" then
        CreateNodeProject()
      elseif choice == "React (Vite)" then
        CreateReactProject()
      elseif choice == "Vue" then
        CreateVueProject()
      elseif choice == "Svelte" then
        CreateSvelteProject()
      elseif choice == "Spring Boot Java" then
        CreateSpringBootJavaProject()
      elseif choice == "Spring Boot Kotlin" then
        CreateSpringBootKotlinProject()
      end
    end
  )
end
