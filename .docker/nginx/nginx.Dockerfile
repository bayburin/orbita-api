ARG APP_IMAGE_NAME
FROM ${APP_IMAGE_NAME}:latest AS app
FROM nginx:1.19.10-alpine

ARG RAILS_ROOT
ENV RAILS_ROOT ${RAILS_ROOT}

ARG APP_HOSTNAME
ENV APP_HOSTNAME ${APP_HOSTNAME}

WORKDIR ${RAILS_ROOT}
RUN mkdir log
COPY --from=app /app/public/ public/

COPY .docker/nginx/nginx.prod.conf /tmp/nginx.prod.conf
COPY .docker/tls/ /etc/pki/tls/nginx/

RUN envsubst '$RAILS_ROOT $APP_HOSTNAME' < /tmp/nginx.prod.conf > /etc/nginx/conf.d/default.conf

EXPOSE 80
EXPOSE 443
