# NovelReader.nvim - 小说阅读插件

`Neovim` 小说阅读插件，支持章节跳转和阅读位置记忆功能。

## 功能特性

### 核心功能
- 📖 **智能章节检测** - 通过正则表达式匹配小说章节
- 🔖 **阅读位置记忆** - 自动保存最后阅读位置
- ⚡ **高效导航** - 快速跳转章节

### 特色功能
- 📚 支持多种章节格式 (中文/英文/数字)
- 🔄 自动缓存章节位置
- 🛠️ 可自定义章节匹配模式

## 安装

使用 [Lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
    "your-username/novel-reader.nvim",
    ft = "text", -- 仅对文本文件加载
    config = function()
        require("novel-reader").setup()
    end
}
```

## 命令列表

请根据自身需求设置合适的keymap

| 命令 | 描述 | 示例 |
|------|------|------|
| `NovelReaderSetRegex` | 设置章节匹配正则 | `:NovelReaderSetRegex 第\d\+章` |
| `NovelReaderNextChapter` | 跳转到下一章 | `:NovelReaderNextChapter` |
| `NovelReaderPrevChapter` | 跳转到上一章 | `:NovelReaderPrevChapter` |
| `NovelReaderCurrentChapter` | 显示当前章节 | `:NovelReaderCurrentChapter` |
| `NovelReaderSetChapter` | 跳转到指定章节 | `:NovelReaderSetChapter 5` |
| `NovelReaderCacheStatus` | 显示缓存状态 | `:NovelReaderCacheStatus` |

## 配置

```lua
require("novel-reader").setup({
    -- 默认章节匹配模式
    default_pattern = "第\\d\\+章",

})
```

---

# NovelReader.nvim - Novel Reading Plugin

A `Neovim` plugin for reading novels with chapter navigation and reading position memory.

## Features

### Core Features
- 📖 **Smart Chapter Detection** - Regex-based chapter matching
- 🔖 **Reading Position Memory** - Automatically saves last position
- ⚡ **Efficient Navigation** - Quick chapter jumping

### Special Features
- 📚 Supports multiple chapter formats (Chinese/English/Numeric)
- 🔄 Auto-caches chapter locations
- 🛠️ Customizable chapter patterns

## Installation

Using [Lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
    "your-username/novel-reader.nvim",
    ft = "text", -- Load only for text files
    config = function()
        require("novel-reader").setup()
    end
}
```

## Commands

Customize your keymap to suit your preferences.

| Command | Description | Example |
|---------|-------------|---------|
| `NovelReaderSetRegex` | Set chapter regex pattern | `:NovelReaderSetRegex Chapter\s\d+` |
| `NovelReaderNextChapter` | Go to next chapter | `:NovelReaderNextChapter` |
| `NovelReaderPrevChapter` | Go to previous chapter | `:NovelReaderPrevChapter` |
| `NovelReaderCurrentChapter` | Show current chapter | `:NovelReaderCurrentChapter` |
| `NovelReaderSetChapter` | Jump to specific chapter | `:NovelReaderSetChapter 5` |
| `NovelReaderCacheStatus` | Show cache status | `:NovelReaderCacheStatus` |

## Configuration

```lua
require("novel-reader").setup({
    -- Default chapter pattern
    default_pattern = "Chapter\\s\\d+",
    
})
```
