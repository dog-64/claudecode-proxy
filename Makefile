.PHONY: shellcheck install help

help:
	@echo "Доступные цели:"
	@echo "  make shellcheck  - Проверить скрипты через shellcheck"
	@echo "  make install     - Установить clc в /usr/local/bin"
	@echo "  make help        - Показать эту справку"

shellcheck:
	shellcheck --severity=warning clc

install: clc
	@echo "Установка clc в /usr/local/bin..."
	install -m 755 clc /usr/local/bin/clc
	@echo "Установлено: /usr/local/bin/clc"