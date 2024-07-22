FROM node:20.11.0-alpine as build

WORKDIR /

COPY package.json ./package.json
COPY yarn.lock ./yarn.lock

RUN yarn install

COPY . .

RUN yarn build

FROM nginx:1.23.2-alpine as start

COPY --from=build ./dist /usr/share/nginx/html

RUN rm /etc/nginx/conf.d/default.conf

COPY nginx/nginx.conf /etc/nginx/conf.d

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]