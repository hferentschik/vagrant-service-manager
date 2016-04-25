require "bundler/gem_tasks"
require 'rake/clean'

CLOBBER.include('pkg/*')

desc 'Run acceptance specs using vagrant-spec'
task :acceptance, [:provider] do |t, args|
  if args[:provider].nil?
  	provider='virtualbox'
  else
  	provider=args[:provider]
  end
  components = %w(
    cdk
  ).map{|s| "provider/#{provider}/#{s}" }
  sh "export VAGRANT_SPEC_PROVIDER=#{provider} && bundle exec vagrant-spec test --components=#{components.join(' ')}"
end


