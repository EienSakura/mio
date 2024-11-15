FROM python:3.10-slim
WORKDIR /app

ENV TZ=Asia/Shanghai
ENV LANG zh_CN.UTF-8
ENV LANGUAGE zh_CN.UTF-8
ENV LC_ALL zh_CN.UTF-8
ENV TZ Asia/Shanghai
ENV DEBIAN_FRONTEND noninteractive

COPY . /app/

COPY docker/sources.list /etc/apt/sources.list
COPY docker/resolv.conf /etc/resolv.conf

RUN apt update && apt install -y libzbar0 locales locales-all fonts-noto

#RUN sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list

RUN apt-get install -y libnss3-dev libxss1 libasound2 libxrandr2\
  libatk1.0-0 libgtk-3-0 libgbm-dev libxshmfence1

RUN python3 -m pip config set global.index-url https://mirrors.aliyun.com/pypi/simple  \
    &&pip install -r requirements.txt
#   && pip install poetry \
#   && poetry config virtualenvs.create false

#RUN pip install poetry \
#  && poetry config virtualenvs.create false

#COPY  pyproject.toml /
#COPY  poetry.lock /

#RUN poetry export --without-hashes -f requirements.txt \
#  | poetry run pip install -r /dev/stdin
RUN pip install -r /dev/stdin
RUN playwright install chromium && playwright install-deps

CMD ["python","bot.py"]