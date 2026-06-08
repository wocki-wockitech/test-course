# StudyMe Course Template

Скелет курса для платформы [StudyMe](https://studyme.wockitech.local). Используй
"Use this template" на GitHub чтобы получить чистый репозиторий.

## Что это

Курс — это набор блоков. Блок — набор уроков. Урок — markdown + пул вопросов.
Платформа индексирует репозиторий по тегам Git.

```
my-course/
├── course.yaml              ← манифест курса (название, язык, порядок блоков)
├── block-1/                 ← блок (slug = имя папки)
│   ├── block.yaml
│   ├── lesson-1/            ← урок (slug = имя папки)
│   │   ├── lesson.md
│   │   ├── questions.yaml
│   │   └── challenges/      ← опционально, код-задачи
│   └── lesson-2/
└── block-2/
    └── ...
```

## Быстрый старт

1. Жми **Use this template** на GitHub
2. Клонируй свой новый репозиторий
3. Открой [`_templates/README.md`](_templates/README.md) — там заготовки для копирования
4. Скопируй `_templates/block/` в корень и переименуй
5. Заполни контент
6. Открой PR — GitHub Action сам пропишет недостающие UUID
7. Замержи в `main`
8. Создай тег: `git tag v1.0.0 && git push --tags`
9. На платформе StudyMe нажми "Подключить курс" → вставь URL репо

## Stable UUID

Каждая сущность (курс, блок, урок, вопрос, челлендж) имеет два идентификатора:

- **`id` (UUID)** — техническая личность, **никогда не меняется**. Используется
  платформой для отслеживания прогресса студентов. При переименовании папки или
  правке slug — UUID остаётся тот же, прогресс не теряется.
- **slug** — человеческое имя. Для уроков и блоков выводится из имени папки.
  Для вопросов задаётся явно (нужен для ссылок из markdown).

UUID генерируется автоматически:
- При коммите через GitHub Action `studyme-id.yml`
- Локально через CLI: `studyme-cli new lesson <name>` (опционально, V2)

Никогда не меняй `id` вручную — это ломает прогресс студентов.

## Игнорируемые пути

Платформа НЕ индексирует:

- Папки начинающиеся с `_` (например `_templates/`, `_drafts/`)
- Папки начинающиеся с `.` (например `.github/`)
- Файлы и папки в `.studymeignore` (gitignore-подобный синтаксис)

## Публикация

Платформа индексирует **только теги Git**, не каждый коммит в `main`.

```bash
# Доводишь курс до готовности в main или PR
git checkout main
git pull

# Создаёшь тег версии (semver)
git tag v1.0.0
git push --tags
```

Платформа автоматически:
1. Получает webhook от GitHub
2. Клонирует репо на этом теге
3. Валидирует структуру
4. Индексирует контент в БД и MinIO
5. Запускает миграцию активных студентов с предыдущей версии

Можно перепрыгнуть несколько версий — платформа возьмёт последний тег и
посчитает кумулятивный diff.

### Откат версии (yank)

Если нашёл серьёзную ошибку в опубликованной версии:
1. Создай новый тег с фиксом (`v1.0.1`)
2. На платформе нажми "Yank v1.0.0" — новые студенты получат v1.0.1, активные останутся на v1.0.0 с предупреждением

## Версионирование

Используй [Semantic Versioning](https://semver.org/):

- **MAJOR** (`v2.0.0`) — крупная переработка, удаление блоков, переход на новый язык
- **MINOR** (`v1.1.0`) — добавлены новые уроки, расширенные темы
- **PATCH** (`v1.0.1`) — исправление опечаток, улучшение формулировок

Студенты автоматически мигрируют на новую версию. Если нужно оставить студента на старой — у него в профиле есть опция "Закрепить версию".

## Локальная разработка

```bash
# Клонировать
git clone https://github.com/<your-username>/my-course.git
cd my-course

# Валидация перед коммитом
npx @wockitech/studyme-lint .

# Превью урока в браузере (V2)
npx @wockitech/studyme-preview lesson block-1/lesson-1
```

## Редактирование в Obsidian

Репозиторий совместим с [Obsidian](https://obsidian.md). Открой папку
курса как vault — frontmatter, граф связей, поиск, теги работают сразу.

Что настроено в `.obsidian/`:

- **Стандартные markdown-ссылки** — `[text](path)` вместо `[[wiki]]`,
  чтобы рендерер платформы их понимал
- **Картинки автоматически в `assets/`** — перетаскиваешь файл, попадает
  куда нужно
- **Шаблоны** в `_templates/obsidian/` доступны через `Cmd/Ctrl+P` →
  "Insert template" (вопросы, директивы, frontmatter уроков)
- **`_templates/`, `.github/`, `docs/`** скрыты из file tree

Что Obsidian показывает иначе чем платформа:

- Custom-тип callouts (`> [!quiz]`, `> [!challenge]`, `> [!sandbox]`)
  в Obsidian рендерятся как обычные блоки. На платформе StudyMe — как
  встроенные виджеты с реальным тестом / редактором кода / песочницей
- Можно положить CSS snippet в vault чтобы стилизовать quiz/challenge
  в Obsidian с теми же иконками что на платформе

В будущем планируется свой Obsidian-плагин StudyMe, который будет
рендерить эти callouts как живые виджеты прямо в редакторе.

## Структура контента

См. подробности в [docs/CONTENT-FORMAT.md](docs/CONTENT-FORMAT.md).

Кратко:

- **`course.yaml`** — манифест курса
- **`block.yaml`** — манифест блока (порядок уроков, настройки итогового теста)
- **`lesson.md`** — контент урока с frontmatter и markdown-директивами
- **`questions.yaml`** — пул вопросов для мини-теста урока и итогового теста блока
- **`challenges/<slug>/challenge.yaml`** — описание код-задачи

## Обновление из шаблона

Шаблон развивается — появляются новые форматы, CI-шаги, Obsidian-настройки.
Ваш контент при обновлении не затрагивается.

### Автоматически (рекомендуется)

Нажмите **Actions → Sync template → Run workflow** в вашем репозитории.
Workflow подтянет обновления из шаблона и создаст PR.

### Вручную

```bash
# Добавить remote (один раз)
git remote add template https://github.com/wocki-wockitech/studyme-course-template.git

# Подтянуть и перезаписать инфра-файлы
git fetch template main
git checkout template/main -- _templates/ .github/ docs/ .obsidian/ .studymeignore .gitignore

# Закоммитить
git add .
git commit -m "chore: sync from template"
```

### Что обновляется

| Перезаписывается из шаблона | Не трогается |
|---|---|
| `_templates/` | `course.yaml` |
| `.github/` | Папки блоков и уроков |
| `docs/` | `questions.yaml` в уроках |
| `.obsidian/` | `README.md` |
| `.studymeignore`, `.gitignore` | |

## Ссылки

- [Документация StudyMe](https://docs.studyme.wockitech.local)
- [GitHub Action: studyme-course-tools](https://github.com/wocki-wockitech/studyme-course-tools)
- [CLI: studyme-cli](https://github.com/wockitech/studyme-cli)
- [Сообщество авторов](https://t.me/studyme_authors)

## Лицензия

Шаблон — MIT. Контент твоего курса — на твоё усмотрение (укажи в `course.yaml`).
