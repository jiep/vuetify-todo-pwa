FROM node:10-jessie

WORKDIR /app

RUN apt-get update
RUN apt-get install -y apt-transport-https
RUN curl -o- -L https://yarnpkg.com/install.sh | bash

RUN yarn add @vue/cli

EXPOSE 8080

CMD ["yarn", "serve"]
