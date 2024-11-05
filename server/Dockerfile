from node:23.1-alpine

RUN mkdir -p /usr/app
WORKDIR /usr/app

COPY package.json .
COPY tsconfig.json .
COPY src src
RUN npm i

EXPOSE 8000

ENTRYPOINT ["npm", "run", "start"]
