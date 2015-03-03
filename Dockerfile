# Hubot Control

FROM ruby:2.0.0-onbuild

# Install nodejs and npm
RUN curl -sL https://deb.nodesource.com/setup | bash -
RUN apt-get update && apt-get install -y nodejs
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install hubot
RUN npm install -g coffee-script hubot yo generator-hubot
RUN apt-get clean && npm cache clean

RUN useradd -m hubot

EXPOSE 3000

WORKDIR /usr/src/app
RUN mkdir hubots
RUN chown -R hubot:hubot /usr/src/app

USER hubot
# disable first time yo generator notice
RUN mkdir -p /home/hubot/.config/configstore
RUN echo "optOut: true" > /home/hubot/.config/configstore/insight-yo.yml
RUN RAILS_ENV=production bundle exec rake assets:precompile

CMD ["bundle", "exec", "unicorn", "-p", "3000", "-c", "./config/unicorn.rb", "-E", "production"]
