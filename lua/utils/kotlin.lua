-- ========================================
-- Kotlin Utility Functions
-- File: ~/.config/nvim/lua/utils/kotlin.lua
-- ========================================

-- Fungsi untuk compile dan run Kotlin
function CompileAndRunKotlin()
  local file = vim.fn.expand("%:p")
  local filename = vim.fn.expand("%:t:r")
  local bin_dir = vim.fn.getcwd() .. "/bin"

  vim.fn.mkdir(bin_dir, "p")

  local compile_cmd = string.format("kotlinc %s -include-runtime -d %s/%s.jar", file, bin_dir, filename)
  print("Compiling: " .. compile_cmd)

  local compile_result = vim.fn.system(compile_cmd)
  if vim.v.shell_error ~= 0 then
    print("Compilation failed:")
    print(compile_result)
    return
  end

  local run_cmd = string.format("java -jar %s/%s.jar", bin_dir, filename)
  print("Running: " .. run_cmd)
  vim.cmd("!" .. run_cmd)
end

-- Fungsi untuk build Kotlin project
function BuildKotlin()
  local bin_dir = vim.fn.getcwd() .. "/bin"
  vim.fn.mkdir(bin_dir, "p")

  if vim.fn.filereadable("build.gradle.kts") == 1 or vim.fn.filereadable("build.gradle") == 1 then
    print("Building with Gradle...")
    vim.cmd("!./gradlew build")
  else
    print("Building all Kotlin files...")
    vim.cmd("!kotlinc src/**/*.kt -include-runtime -d " .. bin_dir .. "/app.jar")
  end
end

-- Fungsi untuk run unit test Kotlin
function TestKotlin()
  if vim.fn.filereadable("build.gradle.kts") == 1 or vim.fn.filereadable("build.gradle") == 1 then
    print("Running Kotlin tests with Gradle...")
    vim.cmd("!./gradlew test")
  else
    print("No test framework detected. Please setup Gradle with JUnit or KotlinTest")
  end
end

-- Keymapping untuk Kotlin
vim.api.nvim_create_autocmd("FileType", {
  pattern = "kotlin",
  callback = function()
    vim.keymap.set("n", "<F5>", ":lua CompileAndRunKotlin()<CR>", { buffer = true, desc = "Compile and Run Kotlin" })
    vim.keymap.set("n", "<leader>kr", ":lua CompileAndRunKotlin()<CR>", { buffer = true, desc = "Run Kotlin" })
    vim.keymap.set("n", "<leader>kb", ":lua BuildKotlin()<CR>", { buffer = true, desc = "Build Kotlin" })
    vim.keymap.set("n", "<leader>kt", ":lua TestKotlin()<CR>", { buffer = true, desc = "Test Kotlin" })
  end
})