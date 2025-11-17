-- ========================================
-- Java Utility Functions
-- File: ~/.config/nvim/lua/utils/java.lua
-- ========================================

-- Fungsi untuk compile dan run Java
function CompileAndRunJava()
  local file = vim.fn.expand("%:p")
  local filename = vim.fn.expand("%:t:r")
  local bin_dir = vim.fn.getcwd() .. "/bin"

  vim.fn.mkdir(bin_dir, "p")

  local compile_cmd = string.format("javac -d %s %s", bin_dir, file)
  print("Compiling: " .. compile_cmd)

  local compile_result = vim.fn.system(compile_cmd)
  if vim.v.shell_error ~= 0 then
    print("Compilation failed:")
    print(compile_result)
    return
  end

  local run_cmd = string.format("java -cp %s %s", bin_dir, filename)
  print("Running: " .. run_cmd)
  vim.cmd("!" .. run_cmd)
end

-- Fungsi untuk build Java project
function BuildJava()
  local bin_dir = vim.fn.getcwd() .. "/bin"
  vim.fn.mkdir(bin_dir, "p")

  if vim.fn.filereadable("pom.xml") == 1 then
    print("Building with Maven...")
    vim.cmd("!mvn compile")
  elseif vim.fn.filereadable("build.gradle") == 1 or vim.fn.filereadable("build.gradle.kts") == 1 then
    print("Building with Gradle...")
    vim.cmd("!./gradlew build")
  else
    print("Building all Java files...")
    vim.cmd("!javac -d " .. bin_dir .. " src/**/*.java")
  end
end

-- Fungsi untuk run unit test Java
function TestJava()
  if vim.fn.filereadable("pom.xml") == 1 then
    print("Running Java tests with Maven...")
    vim.cmd("!mvn test")
  elseif vim.fn.filereadable("build.gradle") == 1 or vim.fn.filereadable("build.gradle.kts") == 1 then
    print("Running Java tests with Gradle...")
    vim.cmd("!./gradlew test")
  else
    print("No test framework detected. Please setup Maven or Gradle with JUnit")
  end
end

-- Keymapping untuk Java
vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  callback = function()
    vim.keymap.set("n", "<F5>", ":lua CompileAndRunJava()<CR>", { buffer = true, desc = "Compile and Run Java" })
    vim.keymap.set("n", "<leader>jr", ":lua CompileAndRunJava()<CR>", { buffer = true, desc = "Java Run" })
    vim.keymap.set("n", "<leader>jb", ":lua BuildJava()<CR>", { buffer = true, desc = "Java Build" })
    vim.keymap.set("n", "<leader>jt", ":lua TestJava()<CR>", { buffer = true, desc = "Java Test" })
  end
})