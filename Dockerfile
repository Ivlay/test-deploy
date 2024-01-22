FROM node:18-alpine as build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM nginx:alpine

COPY --from=build /app/build /usr/share/nginx/html
COPY .nginx/nginx.conf /etc/nginx/conf.d/default.conf
COPY .nginx/nginx-selfsigned.crt /etc/nginx/ssl/nginx-selfsigned.crt
COPY .nginx/nginx-selfsigned.key /etc/nginx/ssl/nginx-selfsigned.key

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
