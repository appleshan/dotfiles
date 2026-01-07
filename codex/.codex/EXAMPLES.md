# EXAMPLES.md

> 📖 **返回核心指南**: [AGENTS.md](./AGENTS.md)

本文档包含代理行为的完整示例集合，用于参考和学习最佳实践。

---

## Preamble Messages 示例

以下是高质量的 preamble 消息示例，展示如何在工具调用前简洁地说明意图：

- "I've explored the repo; now checking the API route definitions."
- "Next, I'll patch the config and update the related tests."
- "I'm about to scaffold the CLI commands and helper functions."
- "Ok cool, so I've wrapped my head around the repo. Now digging into the API routes."
- "Config's looking tidy. Next up is patching helpers to keep things in sync."
- "Finished poking at the DB gateway. I will now chase down error handling."
- "Alright, build pipeline order is interesting. Checking how it reports failures."
- "Spotted a clever caching util; now hunting where it gets used."

---

## Planning 示例

### 高质量计划 (High-Quality Plans)

**Example 1: Markdown to HTML CLI**

1. Add CLI entry with file args
2. Parse Markdown via CommonMark library
3. Apply semantic HTML template
4. Handle code blocks, images, links
5. Add error handling for invalid files

**Example 2: Dark Mode Toggle**

1. Define CSS variables for colors
2. Add toggle with localStorage state
3. Refactor components to use variables
4. Verify all views for readability
5. Add smooth theme-change transition

**Example 3: Real-time Chat**

1. Set up Node.js + WebSocket server
2. Add join/leave broadcast events
3. Implement messaging with timestamps
4. Add usernames + mention highlighting
5. Persist messages in lightweight DB
6. Add typing indicators + unread count

### 低质量计划 (Low-Quality Plans - 避免这些模式)

**Example 1: 过于简化**

1. Create CLI tool
2. Add Markdown parser
3. Convert to HTML

**Example 2: 缺乏细节**

1. Add dark mode toggle
2. Save preference
3. Make styles look good

**Example 3: 过于宽泛**

1. Create single-file HTML game
2. Run quick sanity check
3. Summarize usage instructions

---

## 使用建议

- **Preambles**: 简洁（8-12词），连接上下文，展示进度和下一步
- **Plans**: 参考高质量示例的粒度和具体性，避免低质量示例的模糊性
- **Step 长度**: 每步5-7词，具体可操作
