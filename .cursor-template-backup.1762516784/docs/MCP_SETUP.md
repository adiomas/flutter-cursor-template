# MCP (Model Context Protocol) Setup

> **Extend AI capabilities with custom tools and integrations**

## 🎯 What is MCP?

MCP (Model Context Protocol) allows AI to use external tools and services:
- Access documentation
- Interact with APIs
- Use custom workflows
- Integrate with services

---

## 📦 Recommended MCP Servers

### 1. Context7 (Documentation Access)

**What it does:**
- Provides up-to-date documentation for frameworks
- Powers @Docs feature in Cursor
- Always current API references

**Setup:**

```json
{
  "mcpServers": {
    "context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp@latest"]
    }
  }
}
```

**Usage in Cursor:**
```
@Docs Flutter StatefulWidget
@Docs Supabase realtime subscriptions
@Docs Riverpod family providers
```

---

### 2. GitHub Integration

**What it does:**
- Search issues and PRs
- Create issues from chat
- Review code
- Access repository information

**Setup:**

1. Create GitHub Personal Access Token:
   - Go to GitHub Settings → Developer Settings → Personal Access Tokens
   - Generate new token with `repo` scope
   - Copy token

2. Add to `~/.cursor/mcp.json`:

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "your_token_here"
      }
    }
  }
}
```

3. Add to `~/.zshrc` or `~/.bash_profile`:

```bash
export GITHUB_PERSONAL_ACCESS_TOKEN="your_token_here"
source ~/.zshrc  # or source ~/.bash_profile
```

**Usage in Cursor:**
```
Search issues related to authentication
Create issue: "Bug in boat booking flow"
Review PR #45
Show recent commits
```

---

### 3. Supabase MCP (Custom - Optional)

**What it does:**
- Direct Supabase interaction
- Database queries from chat
- Schema inspection
- RPC calls

**Setup:**

Create custom MCP server for Supabase:

```json
{
  "mcpServers": {
    "supabase": {
      "command": "npx",
      "args": ["-y", "@supabase/mcp-server"],
      "env": {
        "SUPABASE_URL": "your_project_url",
        "SUPABASE_SERVICE_KEY": "your_service_key"
      }
    }
  }
}
```

**Usage in Cursor:**
```
Show boats table schema
Query all boats with status active
Create RLS policy for users table
Check database performance
```

---

### 4. Firecrawl (Web Scraping)

**What it does:**
- Scrape web pages
- Extract structured data
- Monitor websites
- Access web content

**Setup:**

1. Get API key from [Firecrawl](https://firecrawl.dev)

2. Add to `~/.cursor/mcp.json`:

```json
{
  "mcpServers": {
    "firecrawl": {
      "command": "npx",
      "args": ["-y", "mcp-server-firecrawl"],
      "env": {
        "FIRECRAWL_API_KEY": "your_api_key"
      }
    }
  }
}
```

**Usage in Cursor:**
```
Scrape Flutter changelog for version 3.16
Extract pricing from competitor website
Monitor Flutter blog for new posts
```

---

## 📁 Complete MCP Configuration

### File Location

```
~/.cursor/mcp.json
```

### Full Example

```json
{
  "mcpServers": {
    "context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp@latest"]
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "ghp_your_token_here"
      }
    },
    "firecrawl": {
      "command": "npx",
      "args": ["-y", "mcp-server-firecrawl"],
      "env": {
        "FIRECRAWL_API_KEY": "fc_your_api_key"
      }
    }
  }
}
```

---

## 🔧 Environment Variables

### Setup Shell Profile

Add to `~/.zshrc` or `~/.bash_profile`:

```bash
# MCP Environment Variables

# GitHub
export GITHUB_PERSONAL_ACCESS_TOKEN="ghp_your_token_here"

# Firecrawl
export FIRECRAWL_API_KEY="fc_your_api_key"

# Supabase (if using Supabase MCP)
export SUPABASE_URL="https://your-project.supabase.co"
export SUPABASE_SERVICE_KEY="your_service_key"

# OpenAI (for AI analysis features)
export OPENAI_API_KEY="sk-your_key"
```

### Reload Configuration

```bash
source ~/.zshrc
# or
source ~/.bash_profile
```

### Verify Setup

```bash
echo $GITHUB_PERSONAL_ACCESS_TOKEN
echo $FIRECRAWL_API_KEY
```

---

## 🚀 Usage Examples

### Context7 (Documentation)

```
User: @Docs Flutter how to optimize list performance?

AI: [Loads current Flutter documentation]
For list performance optimization:
1. Use ListView.builder instead of ListView
2. Implement const constructors
3. Use RepaintBoundary for complex items
[...detailed response with current API info]
```

### GitHub Integration

```
User: Search open issues with label "bug"

AI: [Queries GitHub API]
Found 3 open bugs:
1. #123: Login fails on iOS 
2. #124: Image upload timeout
3. #125: Navigation crash
[...with details and links]
```

```
User: Create issue for slow boat loading

AI: [Creates GitHub issue]
Created issue #126: "Performance: Slow boat list loading"
Description: Boats list takes 3+ seconds to load...
[...issue link]
```

### Firecrawl (Web Access)

```
User: Check latest Flutter release notes

AI: [Scrapes Flutter website]
Flutter 3.16.5 released on Nov 2025:
- Bug fixes for iOS
- Performance improvements
- New Material 3 widgets
[...detailed changelog]
```

---

## 🎯 Best Practices

### Security

1. **Never commit tokens to git**
   ```bash
   # Add to .gitignore
   .cursor/mcp.json
   .env
   ```

2. **Use environment variables**
   ```json
   "env": {
     "API_KEY": "${API_KEY}"  // Reads from shell env
   }
   ```

3. **Rotate tokens regularly**
   - GitHub tokens: Every 90 days
   - API keys: Every 6 months

### Performance

1. **Only enable needed servers**
   ```json
   // ❌ Don't enable everything
   {
     "mcpServers": {
       "server1": {...},
       "server2": {...},
       "server3": {...},
       "server4": {...},
       "server5": {...}
     }
   }
   
   // ✅ Enable what you use
   {
     "mcpServers": {
       "context7": {...},
       "github": {...}
     }
   }
   ```

2. **Cache documentation**
   - Context7 caches automatically
   - Reduces API calls
   - Faster responses

### Usage

1. **Be specific in requests**
   ```
   ❌ "Search issues"
   ✅ "Search open bugs with label 'authentication'"
   ```

2. **Combine with @-symbols**
   ```
   @Docs Flutter + @Codebase show me similar implementations
   ```

3. **Use for research, not replacement**
   - Good: "What's new in Flutter 3.16?"
   - Bad: "Write entire app for me"

---

## 🔍 Troubleshooting

### MCP Server Not Working

**1. Check Configuration**
```bash
cat ~/.cursor/mcp.json
# Verify JSON is valid
```

**2. Check Environment Variables**
```bash
printenv | grep GITHUB
printenv | grep FIRECRAWL
```

**3. Test API Keys**
```bash
# GitHub
curl -H "Authorization: token $GITHUB_PERSONAL_ACCESS_TOKEN" \
  https://api.github.com/user

# Should return your user info
```

**4. Restart Cursor**
```
Close and reopen Cursor completely
MCP servers load on startup
```

### Common Issues

**Issue**: "MCP server failed to start"
```
Solution:
1. Check npx is installed: npx --version
2. Clear npm cache: npm cache clean --force
3. Reinstall package: npx -y @package/name
```

**Issue**: "Authentication failed"
```
Solution:
1. Verify token is correct
2. Check token has required scopes
3. Regenerate token if needed
4. Update ~/.zshrc and source it
```

**Issue**: "Rate limit exceeded"
```
Solution:
1. GitHub: Check rate limit status
2. Wait for reset (shown in error)
3. Use personal token (higher limits)
4. Implement caching
```

---

## 📊 MCP Server Comparison

| Server | Purpose | Cost | Setup Difficulty | Use Case |
|--------|---------|------|------------------|----------|
| Context7 | Documentation | Free | Easy | @Docs queries |
| GitHub | Git integration | Free | Easy | Issue tracking, PRs |
| Firecrawl | Web scraping | Paid | Medium | Monitoring, research |
| Supabase | Database access | Free | Medium | Direct DB queries |

---

## 🌟 Advanced: Custom MCP Server

### Create Project-Specific MCP

For specialized workflows:

```typescript
// tools/mcp-server/index.ts

import { Server } from "@modelcontextprotocol/sdk/server/index.js";

const server = new Server({
  name: "omiline-tools",
  version: "1.0.0",
});

server.setRequestHandler(ListToolsRequestSchema, async () => ({
  tools: [{
    name: "generate_boat_report",
    description: "Generate boat analytics report",
    inputSchema: {
      type: "object",
      properties: {
        boat_id: { type: "string" },
        date_range: { type: "string" }
      }
    }
  }]
}));

// Start server
await server.connect(process.stdin, process.stdout);
```

### Add to Configuration

```json
{
  "mcpServers": {
    "omiline-tools": {
      "command": "node",
      "args": ["tools/mcp-server/index.js"]
    }
  }
}
```

---

## 🚀 Quick Start Checklist

- [ ] Create `~/.cursor/mcp.json`
- [ ] Add Context7 server (for @Docs)
- [ ] Get GitHub personal access token
- [ ] Add GitHub server configuration
- [ ] Add env variables to shell profile
- [ ] Source shell profile
- [ ] Restart Cursor
- [ ] Test with `@Docs Flutter`
- [ ] Test GitHub integration
- [ ] Verify all servers work

---

**MCP supercharges your AI capabilities! Set it up once, benefit forever.** 🚀

