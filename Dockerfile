# syntax=docker/dockerfile:1.4
FROM node:16.14-alpine AS build

WORKDIR /usr/src/app

COPY package*.json ./

RUN --mount=type=cache,target=/usr/src/app/.npm \
  npm set cache /usr/src/app/.npm \
  && npm install

COPY . .

RUN npm run build

FROM node:16.14-alpine AS production

ENV NODE_ENV production

ENV HOST 0.0.0.0

ENV PORT 3000

USER node

WORKDIR /usr/src/app

COPY --chown=node:node --from=build /usr/src/app ./

EXPOSE $PORT

CMD ["npm", "start"]
