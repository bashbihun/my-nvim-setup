-- ========================================
-- Project Creation Utilities
-- File: ~/.config/nvim/lua/utils/projects.lua
-- ========================================

-- Fungsi untuk membuat file baru
function CreateNewFile()
  vim.ui.input({ prompt = "New file name: " }, function(input)
    if input and input ~= "" then
      local filepath = vim.fn.getcwd() .. "/" .. input
      local dir = vim.fn.fnamemodify(filepath, ":h")

      vim.fn.mkdir(dir, "p")
      vim.cmd("edit " .. filepath)
      print("Created file: " .. filepath)
    end
  end)
end

-- Fungsi untuk membuat folder baru
function CreateNewFolder()
  vim.ui.input({ prompt = "New folder name: " }, function(input)
    if input and input ~= "" then
      local folderpath = vim.fn.getcwd() .. "/" .. input

      vim.fn.mkdir(folderpath, "p")
      print("Created folder: " .. folderpath)
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
    -- vim.fn.mkdir(base_dir .. "/src/main/java/com/example", "p")
    -- vim.fn.mkdir(base_dir .. "/src/test/java/com/example", "p")
    vim.fn.mkdir(base_dir .. "/src", "p")
    vim.fn.mkdir(base_dir .. "/bin", "p")
    vim.fn.mkdir(base_dir .. "/lib", "p")

    -- Buat Main.java
--     local main_content = [[package com.example;

-- public class Main {
--     public static void main(String[] args) {
--         System.out.println("Hello, Java!");
--     }
-- }
-- ]]
--     vim.fn.writefile(vim.split(main_content, "\n"), base_dir .. "/src/main/java/com/example/Main.java")
 local main_content = [[

public class Main {
    public static void main(String[] args) {
        System.out.println("Hello, Java!");
    }
}
]]
    vim.fn.writefile(vim.split(main_content, "\n"), base_dir .. "/src/Main.java")

    -- Buat build.gradle
--     local gradle_content = [[plugins {
--     id 'java'
--     id 'application'
-- }

-- group = 'com.example'
-- version = '1.0-SNAPSHOT'

-- repositories {
--     mavenCentral()
-- }

-- dependencies {
--     testImplementation 'org.junit.jupiter:junit-jupiter:5.9.2'
-- }

-- application {
--     mainClass = 'com.example.Main'
-- }

-- tasks.named('test') {
--     useJUnitPlatform()
-- }
-- ]]
--     vim.fn.writefile(vim.split(gradle_content, "\n"), base_dir .. "/build.gradle")

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
    -- vim.cmd("edit src/main/java/com/example/Main.java")
    vim.cmd("edit src/Main.java")
  end)
end

-- Fungsi untuk create Kotlin project
function CreateKotlinProject()
  vim.ui.input({ prompt = "Project name: " }, function(project_name)
    if not project_name or project_name == "" then return end

    local base_dir = vim.fn.getcwd() .. "/" .. project_name

    -- Buat struktur folder
    -- vim.fn.mkdir(base_dir .. "/src/main/kotlin/com/example", "p")
    -- vim.fn.mkdir(base_dir .. "/src/test/kotlin/com/example", "p")
    vim.fn.mkdir(base_dir .. "/src", "p")
    vim.fn.mkdir(base_dir .. "/bin", "p")
    vim.fn.mkdir(base_dir .. "/lib", "p")

    -- Buat Main.kt
--     local main_content = [[package com.example

-- fun main() {
--     println("Hello, Kotlin!")
-- }
-- ]]
--     vim.fn.writefile(vim.split(main_content, "\n"), base_dir .. "/src/main/kotlin/com/example/Main.kt")

--     -- Buat build.gradle.kts
--     local gradle_content = [[plugins {
--     kotlin("jvm") version "1.9.20"
--     application
-- }

-- group = "com.example"
-- version = "1.0-SNAPSHOT"

-- repositories {
--     mavenCentral()
-- }

-- dependencies {
--     testImplementation(kotlin("test"))
-- }

-- tasks.test {
--     useJUnitPlatform()
-- }

-- kotlin {
--     jvmToolchain(17)
-- }

-- application {
--     mainClass.set("com.example.MainKt")
-- }
-- ]]
--     vim.fn.writefile(vim.split(gradle_content, "\n"), base_dir .. "/build.gradle.kts")

--     -- Buat settings.gradle.kts
--     local settings_content = [[rootProject.name = "]] .. project_name .. [["
-- ]]
--     vim.fn.writefile(vim.split(settings_content, "\n"), base_dir .. "/settings.gradle.kts")
local main_content = [[

fun main() {
    println("Hello, Kotlin!")
}
]]
    vim.fn.writefile(vim.split(main_content, "\n"), base_dir .. "/src/Main.kt")

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
    -- vim.cmd("edit src/main/kotlin/com/example/Main.kt")
     vim.cmd("edit src/Main.kt")
  end)
end

-- Fungsi untuk show project creation menu
function ShowProjectMenu()
  vim.ui.select(
    { 
      "Java Project", 
      "Kotlin Project", 
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
      elseif choice == "Spring Boot Java" then
        CreateSpringBootJavaProject()
      elseif choice == "Spring Boot Kotlin" then
        CreateSpringBootKotlinProject()
      end
    end
  )
end