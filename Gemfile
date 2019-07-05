source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

# Specify your gem's dependencies in genba-ruby.gemspec
gemspec

gem 'activemodel', require: 'active_model'

group :development do
  gem 'rake'
  gem 'webmock'
  gem 'uuidtools'

  platforms :mri do
    # to avoid problems, bring Byebug in on just versions of Ruby under which
    # it's known to work well
    if Gem::Version.new(RUBY_VERSION.dup) >= Gem::Version.new('2.0.0')
      gem 'byebug'
      gem 'pry'
      gem 'pry-byebug'
    end
  end
end
