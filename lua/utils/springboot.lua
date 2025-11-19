-- ========================================
-- Spring Boot Utility Functions
-- File: ~/.config/nvim/lua/utils/springboot.lua
-- ========================================

-- Fungsi untuk run Spring Boot (Java)
function RunSpringBootJava()
  if vim.fn.filereadable("pom.xml") == 1 then
    print("🍃 Running Spring Boot with Maven...")
    vim.cmd("!mvn spring-boot:run")
  elseif vim.fn.filereadable("build.gradle") == 1 or vim.fn.filereadable("build.gradle.kts") == 1 then
    print("🍃 Running Spring Boot with Gradle...")
    vim.cmd("!./gradlew bootRun")
  else
    print("❌ No Maven or Gradle project detected!")
  end
end

-- Fungsi untuk run Spring Boot (Kotlin)
function RunSpringBootKotlin()
  if vim.fn.filereadable("build.gradle.kts") == 1 then
    print("🍃 Running Spring Boot Kotlin with Gradle...")
    vim.cmd("!./gradlew bootRun")
  elseif vim.fn.filereadable("pom.xml") == 1 then
    print("🍃 Running Spring Boot Kotlin with Maven...")
    vim.cmd("!mvn spring-boot:run")
  else
    print("❌ No Gradle or Maven project detected!")
  end
end

-- Fungsi untuk build Spring Boot
function BuildSpringBoot()
  if vim.fn.filereadable("pom.xml") == 1 then
    print("🔨 Building Spring Boot with Maven...")
    vim.cmd("!mvn clean package")
  elseif vim.fn.filereadable("build.gradle") == 1 or vim.fn.filereadable("build.gradle.kts") == 1 then
    print("🔨 Building Spring Boot with Gradle...")
    vim.cmd("!./gradlew clean build")
  else
    print("❌ No build tool detected!")
  end
end

-- Global variable untuk test output mode
vim.g.test_output_mode = "split" -- "split" atau "inline"

-- Fungsi untuk toggle test output mode
function ToggleTestOutputMode()
  if vim.g.test_output_mode == "split" then
    vim.g.test_output_mode = "inline"
    print("📺 Test output: INLINE (fullscreen)")
  else
    vim.g.test_output_mode = "split"
    print("📺 Test output: SPLIT (bottom window)")
  end
end

-- Fungsi untuk run test dengan output di split terminal
function RunTestWithOutput(command)
  -- Close existing test terminal if any
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local buf_name = vim.api.nvim_buf_get_name(buf)
    if buf_name:match("term://.*test") then
      vim.api.nvim_win_close(win, true)
    end
  end
  
  -- Create horizontal split at bottom
  vim.cmd("botright split")
  vim.cmd("resize 15")
  
  -- Open terminal and run command
  local term_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_win_set_buf(0, term_buf)
  
  -- Run command in terminal
  vim.fn.termopen(command, {
    on_exit = function(_, exit_code)
      if exit_code == 0 then
        print("✅ Tests passed!")
      else
        print("❌ Tests failed! Check output above.")
      end
    end
  })
  
  -- Start in insert mode to see output
  vim.cmd("startinsert")
  
  -- Return to previous window after command completes
  vim.defer_fn(function()
    vim.cmd("wincmd p")
  end, 500)
end

-- Fungsi untuk run test dengan quickfix window
function RunTestWithQuickfix(command)
  print("🧪 Running tests...")
  
  -- Run command and capture output
  local output = vim.fn.system(command)
  local exit_code = vim.v.shell_error
  
  -- Parse output for errors
  local lines = vim.split(output, "\n")
  local qf_list = {}
  
  for i, line in ipairs(lines) do
    -- Parse Maven/Gradle test failures
    if line:match("FAILED") or line:match("ERROR") or line:match("FAILURE") then
      table.insert(qf_list, {
        text = line,
        lnum = i,
        type = "E"
      })
    elseif line:match("Tests run:") then
      table.insert(qf_list, {
        text = line,
        lnum = i,
        type = "I"
      })
    end
  end
  
  -- Show in quickfix
  if #qf_list > 0 then
    vim.fn.setqflist(qf_list)
    vim.cmd("copen")
  end
  
  -- Show summary
  if exit_code == 0 then
    print("✅ All tests passed!")
  else
    print("❌ Some tests failed! Check quickfix (:copen)")
  end
  
  -- Print full output
  print(output)
end

-- Fungsi untuk test Spring Boot (all tests)
function TestSpringBoot()
  local command
  if vim.fn.filereadable("pom.xml") == 1 then
    command = "mvn test"
  elseif vim.fn.filereadable("build.gradle") == 1 or vim.fn.filereadable("build.gradle.kts") == 1 then
    command = "./gradlew test"
  else
    print("❌ No build tool detected!")
    return
  end
  
  if vim.g.test_output_mode == "split" then
    RunTestWithOutput(command)
  else
    vim.cmd("!" .. command)
  end
end

-- Fungsi untuk run single test class
function RunTestClass()
  local file = vim.fn.expand("%:p")
  local filename = vim.fn.expand("%:t:r")
  
  -- Check if this is a test file
  if not filename:match("Test$") and not filename:match("Tests$") then
    print("❌ Not a test file! Test files should end with 'Test' or 'Tests'")
    return
  end
  
  -- Get package name from file
  local package = ""
  for line in io.lines(file) do
    local pkg = line:match("^package%s+([%w%.]+)")
    if pkg then
      package = pkg
      break
    end
  end
  
  local full_class = package .. "." .. filename
  local command
  
  if vim.fn.filereadable("pom.xml") == 1 then
    command = "mvn test -Dtest=" .. full_class
  elseif vim.fn.filereadable("build.gradle") == 1 or vim.fn.filereadable("build.gradle.kts") == 1 then
    command = "./gradlew test --tests " .. full_class
  else
    print("❌ No build tool detected!")
    return
  end
  
  print("🧪 Running test class: " .. full_class)
  
  if vim.g.test_output_mode == "split" then
    RunTestWithOutput(command)
  else
    vim.cmd("!" .. command)
  end
end

-- Fungsi untuk run single test method
function RunTestMethod()
  local file = vim.fn.expand("%:p")
  local filename = vim.fn.expand("%:t:r")
  
  -- Check if this is a test file
  if not filename:match("Test$") and not filename:match("Tests$") then
    print("❌ Not a test file!")
    return
  end
  
  -- Get current line and find test method name
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
  
  -- Search upward for @Test annotation and method name
  local method_name = nil
  local has_test_annotation = false
  
  for i = cursor_line, 1, -1 do
    local line = lines[i]
    
    -- Check for @Test annotation
    if line:match("@Test") or line:match("@ParameterizedTest") or line:match("@RepeatedTest") then
      has_test_annotation = true
    end
    
    -- Find method name
    local method = line:match("void%s+([%w_]+)%s*%(") or line:match("fun%s+([%w_`]+)%s*%(")
    if method and has_test_annotation then
      -- Remove backticks from Kotlin method names
      method_name = method:gsub("`", "")
      break
    end
    
    -- Stop if we hit another method or class declaration
    if line:match("^%s*class%s+") or (line:match("^%s*public") and not has_test_annotation) then
      break
    end
  end
  
  if not method_name then
    print("❌ No test method found! Make sure cursor is inside a @Test method")
    return
  end
  
  -- Get package name
  local package = ""
  for line in io.lines(file) do
    local pkg = line:match("^package%s+([%w%.]+)")
    if pkg then
      package = pkg
      break
    end
  end
  
  local full_class = package .. "." .. filename
  local command
  
  if vim.fn.filereadable("pom.xml") == 1 then
    command = "mvn test -Dtest=" .. full_class .. "#" .. method_name
  elseif vim.fn.filereadable("build.gradle") == 1 or vim.fn.filereadable("build.gradle.kts") == 1 then
    command = "./gradlew test --tests " .. full_class .. "." .. method_name
  else
    print("❌ No build tool detected!")
    return
  end
  
  print("🧪 Running test method: " .. method_name)
  
  if vim.g.test_output_mode == "split" then
    RunTestWithOutput(command)
  else
    vim.cmd("!" .. command)
  end
end

-- Fungsi untuk run in dev mode
function RunSpringBootDev()
  if vim.fn.filereadable("pom.xml") == 1 then
    print("🔥 Running Spring Boot DevTools with Maven...")
    vim.cmd("!mvn spring-boot:run -Dspring-boot.run.profiles=dev")
  elseif vim.fn.filereadable("build.gradle") == 1 or vim.fn.filereadable("build.gradle.kts") == 1 then
    print("🔥 Running Spring Boot DevTools with Gradle...")
    vim.cmd("!./gradlew bootRun --args='--spring.profiles.active=dev'")
  end
end

-- Fungsi untuk create Spring Boot Java project
function CreateSpringBootJavaProject()
  vim.ui.input({ prompt = "Project name: " }, function(project_name)
    if not project_name or project_name == "" then return end
    
    vim.ui.input({ prompt = "Package name (e.g., com.example): " }, function(package_name)
      if not package_name or package_name == "" then 
        package_name = "com.example"
      end

      local base_dir = vim.fn.getcwd() .. "/" .. project_name
      local package_path = package_name:gsub("%.", "/")

      -- Buat struktur folder Spring Boot
      vim.fn.mkdir(base_dir .. "/src/main/java/" .. package_path .. "/controller", "p")
      vim.fn.mkdir(base_dir .. "/src/main/java/" .. package_path .. "/service", "p")
      vim.fn.mkdir(base_dir .. "/src/main/java/" .. package_path .. "/model", "p")
      vim.fn.mkdir(base_dir .. "/src/main/java/" .. package_path .. "/repository", "p")
      vim.fn.mkdir(base_dir .. "/src/main/resources", "p")
      vim.fn.mkdir(base_dir .. "/src/test/java/" .. package_path, "p")

      -- Buat Application.java
      local app_content = string.format([[package %s;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class Application {
    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }
}
]], package_name)
      vim.fn.writefile(vim.split(app_content, "\n"), base_dir .. "/src/main/java/" .. package_path .. "/Application.java")

      -- Buat HelloController.java
      local controller_content = string.format([[package %s.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloController {
    
    @GetMapping("/")
    public String hello() {
        return "Hello, Spring Boot!";
    }
}
]], package_name)
      vim.fn.writefile(vim.split(controller_content, "\n"), base_dir .. "/src/main/java/" .. package_path .. "/controller/HelloController.java")

      -- Buat pom.xml
      local pom_content = string.format([[<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 
         http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>3.2.0</version>
        <relativePath/>
    </parent>

    <groupId>%s</groupId>
    <artifactId>%s</artifactId>
    <version>0.0.1-SNAPSHOT</version>
    <name>%s</name>

    <properties>
        <java.version>17</java.version>
    </properties>

    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-devtools</artifactId>
            <scope>runtime</scope>
            <optional>true</optional>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>
</project>
]], package_name, project_name, project_name)
      vim.fn.writefile(vim.split(pom_content, "\n"), base_dir .. "/pom.xml")

      -- Buat application.properties
      local props_content = [[server.port=8080
spring.application.name=]] .. project_name .. [[

# DevTools
spring.devtools.restart.enabled=true
]]
      vim.fn.writefile(vim.split(props_content, "\n"), base_dir .. "/src/main/resources/application.properties")

      -- Buat .gitignore
      local gitignore_content = [[target/
!.mvn/wrapper/maven-wrapper.jar
*.jar
*.war
*.ear
*.class
.idea/
*.iml
.vscode/
]]
      vim.fn.writefile(vim.split(gitignore_content, "\n"), base_dir .. "/.gitignore")

      -- Buat README.md
      local readme_content = [[# ]] .. project_name .. [[

Spring Boot application created with Neovim

## Run
```bash
# With Neovim: Space + r
# Or manually:
mvn spring-boot:run

# Access: http://localhost:8080
```

## Build
```bash
mvn clean package
```
]]
      vim.fn.writefile(vim.split(readme_content, "\n"), base_dir .. "/README.md")

      print("✅ Spring Boot Java project created: " .. project_name)
      vim.cmd("cd " .. base_dir)
      vim.cmd("edit src/main/java/" .. package_path .. "/Application.java")
    end)
  end)
end

-- Fungsi untuk create Spring Boot Kotlin project
function CreateSpringBootKotlinProject()
  vim.ui.input({ prompt = "Project name: " }, function(project_name)
    if not project_name or project_name == "" then return end
    
    vim.ui.input({ prompt = "Package name (e.g., com.example): " }, function(package_name)
      if not package_name or package_name == "" then 
        package_name = "com.example"
      end

      local base_dir = vim.fn.getcwd() .. "/" .. project_name
      local package_path = package_name:gsub("%.", "/")

      -- Buat struktur folder Spring Boot Kotlin
      vim.fn.mkdir(base_dir .. "/src/main/kotlin/" .. package_path .. "/controller", "p")
      vim.fn.mkdir(base_dir .. "/src/main/kotlin/" .. package_path .. "/service", "p")
      vim.fn.mkdir(base_dir .. "/src/main/kotlin/" .. package_path .. "/model", "p")
      vim.fn.mkdir(base_dir .. "/src/main/kotlin/" .. package_path .. "/repository", "p")
      vim.fn.mkdir(base_dir .. "/src/main/resources", "p")
      vim.fn.mkdir(base_dir .. "/src/test/kotlin/" .. package_path, "p")

      -- Buat Application.kt
      local app_content = string.format([[package %s

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication

@SpringBootApplication
class Application

fun main(args: Array<String>) {
    runApplication<Application>(*args)
}
]], package_name)
      vim.fn.writefile(vim.split(app_content, "\n"), base_dir .. "/src/main/kotlin/" .. package_path .. "/Application.kt")

      -- Buat HelloController.kt
      local controller_content = string.format([[package %s.controller

import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RestController

@RestController
class HelloController {
    
    @GetMapping("/")
    fun hello(): String {
        return "Hello, Spring Boot with Kotlin!"
    }
}
]], package_name)
      vim.fn.writefile(vim.split(controller_content, "\n"), base_dir .. "/src/main/kotlin/" .. package_path .. "/controller/HelloController.kt")

      -- Buat build.gradle.kts
      local gradle_content = string.format([[import org.jetbrains.kotlin.gradle.tasks.KotlinCompile

plugins {
    id("org.springframework.boot") version "3.2.0"
    id("io.spring.dependency-management") version "1.1.4"
    kotlin("jvm") version "1.9.20"
    kotlin("plugin.spring") version "1.9.20"
}

group = "%s"
version = "0.0.1-SNAPSHOT"

java {
    sourceCompatibility = JavaVersion.VERSION_17
}

repositories {
    mavenCentral()
}

dependencies {
    implementation("org.springframework.boot:spring-boot-starter-web")
    implementation("com.fasterxml.jackson.module:jackson-module-kotlin")
    implementation("org.jetbrains.kotlin:kotlin-reflect")
    developmentOnly("org.springframework.boot:spring-boot-devtools")
    testImplementation("org.springframework.boot:spring-boot-starter-test")
}

tasks.withType<KotlinCompile> {
    kotlinOptions {
        freeCompilerArgs += "-Xjsr305=strict"
        jvmTarget = "17"
    }
}

tasks.withType<Test> {
    useJUnitPlatform()
}
]], package_name)
      vim.fn.writefile(vim.split(gradle_content, "\n"), base_dir .. "/build.gradle.kts")

      -- Buat settings.gradle.kts
      local settings_content = [[rootProject.name = "]] .. project_name .. [["
]]
      vim.fn.writefile(vim.split(settings_content, "\n"), base_dir .. "/settings.gradle.kts")

      -- Buat application.properties
      local props_content = [[server.port=8080
spring.application.name=]] .. project_name .. [[

# DevTools
spring.devtools.restart.enabled=true
]]
      vim.fn.writefile(vim.split(props_content, "\n"), base_dir .. "/src/main/resources/application.properties")

      -- Buat .gitignore
      local gitignore_content = [[.gradle/
build/
!gradle/wrapper/gradle-wrapper.jar
*.jar
*.war
*.ear
*.class
.idea/
*.iml
.vscode/
]]
      vim.fn.writefile(vim.split(gitignore_content, "\n"), base_dir .. "/.gitignore")

      -- Buat README.md
      local readme_content = [[# ]] .. project_name .. [[

Spring Boot Kotlin application created with Neovim

## Run
```bash
# With Neovim: Space + r
# Or manually:
./gradlew bootRun

# Access: http://localhost:8080
```

## Build
```bash
./gradlew clean build
```
]]
      vim.fn.writefile(vim.split(readme_content, "\n"), base_dir .. "/README.md")

      print("✅ Spring Boot Kotlin project created: " .. project_name)
      vim.cmd("cd " .. base_dir)
      vim.cmd("edit src/main/kotlin/" .. package_path .. "/Application.kt")
    end)
  end)
end

-- Keymapping untuk Spring Boot (Java & Kotlin)
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "java", "kotlin" },
  callback = function()
    -- Cek apakah ini Spring Boot project
    if vim.fn.filereadable("pom.xml") == 1 or 
       vim.fn.filereadable("build.gradle") == 1 or 
       vim.fn.filereadable("build.gradle.kts") == 1 then
      
      local filetype = vim.bo.filetype
      
      -- Run application
      if filetype == "java" then
        vim.keymap.set("n", "<leader>sr", ":lua RunSpringBootJava()<CR>", { buffer = true, desc = "Spring Boot Run" })
      elseif filetype == "kotlin" then
        vim.keymap.set("n", "<leader>sr", ":lua RunSpringBootKotlin()<CR>", { buffer = true, desc = "Spring Boot Run" })
      end
      
      vim.keymap.set("n", "<leader>sb", ":lua BuildSpringBoot()<CR>", { buffer = true, desc = "Spring Boot Build" })
      vim.keymap.set("n", "<leader>sd", ":lua RunSpringBootDev()<CR>", { buffer = true, desc = "Spring Boot Dev" })
      
      -- Test keybindings (check if in test file)
      local filename = vim.fn.expand("%:t")
      if filename:match("Test%.java$") or filename:match("Test%.kt$") or 
         filename:match("Tests%.java$") or filename:match("Tests%.kt$") then
        
        vim.keymap.set("n", "<leader>st", ":lua TestSpringBoot()<CR>", { buffer = true, desc = "Run All Tests" })
        vim.keymap.set("n", "<leader>sc", ":lua RunTestClass()<CR>", { buffer = true, desc = "Run Test Class" })
        vim.keymap.set("n", "<leader>sm", ":lua RunTestMethod()<CR>", { buffer = true, desc = "Run Test Method" })
        vim.keymap.set("n", "<leader>so", ":lua ToggleTestOutputMode()<CR>", { buffer = true, desc = "Toggle Test Output" })
        
        print("🧪 Test shortcuts: <leader>st (all), <leader>sc (class), <leader>sm (method), <leader>so (toggle output)")
      else
        vim.keymap.set("n", "<leader>st", ":lua TestSpringBoot()<CR>", { buffer = true, desc = "Spring Boot Test" })
      end
    end
  end
})