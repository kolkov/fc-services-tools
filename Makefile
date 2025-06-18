VERSION := 1.1.0
EBUILD_DIR := ebuilds/app-admin/fc-services-tools

.PHONY: all build release test clean

all: build

build:
	@echo "Building version $(VERSION)"
	# Копируем исходники
	cp src/* $(EBUILD_DIR)/files/
	cp initd/fc-services.initd $(EBUILD_DIR)/files/
	cp confd/fc-services.confd $(EBUILD_DIR)/files/
	cp profile/fc-services.profile $(EBUILD_DIR)/files/

	# Обновляем версию в ebuild
	sed -i "s/^PV=.*/PV=\"$(VERSION)\"/" $(EBUILD_DIR)/fc-services-tools-$(VERSION).ebuild

	# Генерируем манифест
	cd $(EBUILD_DIR) && ebuild fc-services-tools-$(VERSION).ebuild digest

release: build
	# Проверяем, что версия в CHANGELOG.md соответствует
	@if ! grep -q "## [$(VERSION)]" CHANGELOG.md; then \
		echo "Error: Version $(VERSION) not found in CHANGELOG.md"; \
		exit 1; \
	fi

	# Создаем тег версии
	git tag -a v$(VERSION) -m "Release version $(VERSION)"
	git push origin v$(VERSION)

	# Создаем архив для релиза
	git archive --format=tar.gz --prefix=fc-services-tools-$(VERSION)/ HEAD -o fc-services-tools-$(VERSION).tar.gz

test:
	# Запуск тестов (можно добавить позже)
	@echo "Running tests..."

clean:
	rm -rf dist/*
	rm -f fc-services-tools-*.tar.gz
	# Очищаем files, но сохраняем .gitkeep
	find $(EBUILD_DIR)/files/ -type f ! -name '.gitkeep' -delete