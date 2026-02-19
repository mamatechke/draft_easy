web: bundle exec puma -C config/puma.rb -p ${PORT:-3000}
assets: yarn build:css && rails assets:precompile
