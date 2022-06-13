source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.5'

gem 'rails', '~> 6.0.4', '>= 6.0.4.4'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 4.1'
gem 'redis', '~> 4.0'
gem 'sidekiq', '~> 6.4', '>= 6.4.1'
gem 'bootsnap', '>= 1.4.2', require: false
gem 'rack-cors'
gem 'bcrypt', '~> 3.1', '>= 3.1.16'
gem 'jwt', '~> 2.3'
gem 'jsonapi-rails', '~> 0.4.0'
gem 'ancestry', '~> 4.1'
gem 'kaminari', '~> 1.2', '>= 1.2.2'
gem 'httparty', '~> 0.20.0'
gem "image_processing", ">= 1.2"


group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]

  %w[rspec-core rspec-expectations rspec-mocks rspec-rails rspec-support].each do |lib|
    gem lib, git: "https://github.com/rspec/#{lib}.git", branch: 'master'
  end
end

group :development do
  gem 'listen', '~> 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'faker', git: 'https://github.com/faker-ruby/faker.git', branch: 'master'
  gem 'shoulda-matchers', '~> 5.1'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
