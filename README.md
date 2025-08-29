# Claude Code Proxy

Скрипт `clc` для запуска Claude Code через SSH-туннель и squid-прокси.

## Оглавление
- [🛠️ Как установить скрипт `clc` в `~/.local/bin`](#🛠️-как-установить-скрипт-clc-в-localbin)
- [✅ Проверка: всё ли работает](#✅-проверка-всё-ли-работает)
- [🎉 Почему это лучше, чем `/usr/local/bin`?](#🎉-почему-это-лучше-чем-usrlocalbin)
- [✅ Итог](#✅-итог)

## 🛠️ Как установить скрипт `clc` в `~/.local/bin`

### 1. Убедись, что каталог существует:
```bash
mkdir -p ~/.local/bin
```

### 2. Создай скрипт:
```bash
nano ~/.local/bin/clc
```

### 3. Вставь код

```bash
#!/bin/bash

# Имя: clc — запуск Claude Code через прокси
# Назначение: Автоматически использует SSH-туннель к dog@vdsina и squid

TUNNEL_LOCAL_PORT=1080
SSH_TARGET="dog@vdsina"          # ← Теперь всегда dog@vdsina
PROXY_URL="http://127.0.0.1:$TUNNEL_LOCAL_PORT"

# Проверяем, запущен ли туннель
TUNNEL_PID=$(pgrep -f "ssh.*-L.*$TUNNEL_LOCAL_PORT.*dog@vdsina")

if [ -z "$TUNNEL_PID" ]; then
    echo "🔹 Запускаю SSH-туннель: $TUNNEL_LOCAL_PORT → squid на $SSH_TARGET"
    ssh -L $TUNNEL_LOCAL_PORT:127.0.0.1:3128 -N -f $SSH_TARGET
    TUNNEL_PID=$(pgrep -f "ssh.*-L.*$TUNNEL_LOCAL_PORT.*dog@vdsina")
    if [ -z "$TUNNEL_PID" ]; then
        echo "❌ Не удалось запустить туннель. Проверь:"
        echo "   - Имя хоста 'vdsina' в ~/.ssh/config"
        echo "   - Наличие SSH-ключа для пользователя 'dog'"
        exit 1
    fi
    echo "✅ Туннель запущен (PID: $TUNNEL_PID)"
    OWN_TUNNEL=true
else
    echo "🔹 Использую существующий туннель (PID: $TUNNEL_PID)"
    OWN_TUNNEL=false
fi

# Убираем блокировку прокси
unset NO_PROXY no_proxy
export http_proxy=$PROXY_URL
export https_proxy=$PROXY_URL

echo "🌐 Запускаю Claude Code через прокси: $PROXY_URL"
echo "💡 Трафик идёт через squid на 109.234.34.112 (vdsina)"

# Запуск
exec claude
```

### 4. Сделай исполняемым:
```bash
chmod +x ~/.local/bin/clc
```

---

## ✅ Проверка: всё ли работает

```bash
clc
```

➡️ Скрипт должен запуститься и открыть `claude` через прокси.

---

## 🎉 Почему это лучше, чем `/usr/local/bin`?

- `~/.local/bin` — **твой личный каталог**, не требует `sudo`
- Он **уже в `PATH`** — ничего добавлять не нужно
- Это **стандарт** (согласно [XDG](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html))
- Не мешает системным или Homebrew-установкам

---

## ✅ Итог

> ✅ **Используй `~/.local/bin/clc` — это идеальное место.**

Ты:
- Не создаёшь лишние каталоги
- Не используешь `sudo`
- Следуешь стандартам
- Уже в `PATH`

---

Теперь у тебя есть:
- Удобная команда: `clc`
- Полностью автоматизированный запуск через прокси
- Чистая и безопасная установка

Можешь смело закрывать терминал и открывать `clc` в любое время.