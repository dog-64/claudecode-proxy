- [ ]  GLM-4.7 поддерживает extended thinking через параметр thinking: {type: "enabled"} в теле запроса, но Claude Code
  использует другой формат (Anthropic Messages API с MAX_THINKING_TOKENS). Для решения нужен либо патч Claude Code для
  поддержки Z.ai-формата, либо локальный HTTP-прокси, который будет автоматически подставлять этот параметр в запросы к
  API.
- [ ] Github Actions - проверка clc & install.sh
- [ ] install - При установке смотрите где уже установлен скрипт crc и предлагать дефолтным значением именно этот каталог.
- [ ] при использовании `model=opus` появляется 4я модель - наверное из за того что нужно в скрипте кнутри использовать Opus но не
 clc --model opus
🔧 Переключаюсь на Node.js 20...
✅ Node.js v20.19.4 активирован
🔹 Использую существующий туннель (PID: 27947)
🚀 Используется модель: Opus (оригинальный Anthropic, через прокси)
🌐 Работает через прокси: http://127.0.0.1:1080
💡 Трафик идёт через squid на 109.234.34.112 (vdsina)
<<
 ▐▛███▜▌   Claude Code v2.1.25
▝▜█████▛▘  Opus 4.5 · Claude Pro
  ▘▘ ▝▝    ~/Sites/claudecode-proxy

───────────────────────────────────────────────────────────────────────────────────────────────────────────────
 Select model
 Switch between Claude models. Applies to this session and future Claude Code sessions. For other/previous
 model names, specify with --model.

   1. Opus    Opus 4.5 · Most capable for complex work
   2. Sonnet  Sonnet 4.5 · Best for everyday tasks
   3. Haiku   Haiku 4.5 · Fastest for quick answers
   ❯ 4. opus ✔  Custom model
-