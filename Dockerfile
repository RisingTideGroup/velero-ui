FROM node:lts-alpine as build-stage
RUN npm install npm@latest -g
RUN npm update

WORKDIR /app
COPY package*.json ./
RUN npm install -g
RUN yarn install
COPY . .
RUN yarn build

FROM nginx:stable-alpine as production-stage
ENV API_URL http://kubernetes.local
COPY nginx.conf.template /etc/nginx/templates/default.conf.template
COPY --from=build-stage /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
