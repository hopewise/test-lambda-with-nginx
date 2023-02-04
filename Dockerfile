FROM public.ecr.aws/docker/library/ruby:2.7.2-buster

RUN apt update -y
RUN apt install -y nginx
COPY --from=public.ecr.aws/awsguru/aws-lambda-adapter:0.6.1 /lambda-adapter /opt/extensions/lambda-adapter
RUN apt-get --assume-yes install autoconf bison patch build-essential rustc libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libgmp-dev libncurses5-dev libffi-dev libgdbm6 libgdbm-dev libdb-dev uuid-dev

RUN apt-get install -y rubygems #ruby-dev
RUN gem install bundler -v '2.2.27'

# UPDATE NODE:
RUN curl -sL https://deb.nodesource.com/setup_12.x |  bash -

RUN bundle config set without 'development test'
WORKDIR "/app"
COPY . .

RUN bundle install # --path=vendor
ENV RAILS_SERVE_STATIC_FILES false

#Rails App
RUN rm -f /etc/service/nginx/down
RUN rm -f /etc/nginx/sites-enabled/default
ADD webapp.conf /etc/nginx/sites-enabled/webapp.conf

WORKDIR "/tmp"

ADD nginx/app/config/ /etc/nginx/
ADD nginx/app/images/ /usr/share/nginx/html/images
USER root

WORKDIR "/app"
COPY ./entrypoint.sh /app/entrypoint.sh
COPY ./config/puma.rb /app/config/puma.rb
RUN chmod 777 /app/config/puma.rb
RUN chmod 777 /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

EXPOSE 80 8080
ENV RAILS_ENV=production

CMD ["/app/entrypoint.sh"]


