- [ ]  GLM-4.7 поддерживает extended thinking через параметр thinking: {type: "enabled"} в теле запроса, но Claude Code
  использует другой формат (Anthropic Messages API с MAX_THINKING_TOKENS). Для решения нужен либо патч Claude Code для
  поддержки Z.ai-формата, либо локальный HTTP-прокси, который будет автоматически подставлять этот параметр в запросы к
  API.
