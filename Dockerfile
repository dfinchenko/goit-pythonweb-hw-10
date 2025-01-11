# Вибираємо базовий образ
FROM python:3.13-slim

RUN apt-get update && apt-get install -y gcc curl libpq-dev

# Встановлюємо необхідні системні пакети для Poetry та компіляції залежностей
RUN apt-get update && apt-get install -y gcc curl

# Встановлюємо Poetry
RUN curl -sSL https://install.python-poetry.org | python3 -

# Додаємо Poetry до PATH
ENV PATH="/root/.local/bin:$PATH"

# Створюємо та переміщаємося до робочої директорії
WORKDIR /app

COPY poetry.lock pyproject.toml /app/

RUN poetry config virtualenvs.create false && poetry install --no-interaction --no-ansi

# Копіюємо файли проєкту до контейнера
COPY . /app

# Встановлюємо залежності через Poetry
RUN poetry install --no-interaction --no-dev --no-root

# Відкриваємо порт, який буде використовувати додаток
EXPOSE 8000

# Запускаємо сервер
CMD ["sh", "-c", "alembic upgrade head && python3 main.py"]
