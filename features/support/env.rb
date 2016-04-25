require 'aruba/cucumber'
require 'komenda'

Aruba.configure do |config|
  config.exit_timeout = 300
  config.activate_announcer_on_command_failure = [:stdout, :stderr]
  config.working_directory = 'build/aruba'
end

After do |_scenario|
  if File.exist?(File.join(aruba.config.working_directory, 'Vagrantfile'))
    Komenda.run('bundle exec vagrant destroy -f', cwd: aruba.config.working_directory, fail_on_fail: true)
  end
end

###############################################################################
# Some helper functions
###############################################################################
# When running Vagrant from within a plugin development environment, Vagrant
# prints a warning which we can ignore
def stdout_without_plugin_context(raw_stdout)
  raw_stdout.lines.to_a[6..-1].join
end

def output_is_evaluable(raw_stdout)
  console_out = stdout_without_plugin_context(raw_stdout)
  console_out.each_line do |line|
    expect(line).to match(/^#.*|^export [a-zA-Z_]+=.*|^\n/)
  end
end

def output_is_script_readable(raw_stdout)
  console_out = stdout_without_plugin_context(raw_stdout)
  console_out.each_line do |line|
    expect(line).to match(/^[a-zA-Z_]+=.*$/)
  end
end

Then(/^stdout from "([^"]*)" should be evaluable in a shell$/) do |cmd|
  output_is_evaluable(aruba.command_monitor.find(Aruba.platform.detect_ruby(cmd)).send(:stdout))
end

Then(/^stdout from "([^"]*)" should be script readable$/) do |cmd|
  output_is_script_readable(aruba.command_monitor.find(Aruba.platform.detect_ruby(cmd)).send(:stdout))
end

Then(/^stdout from "([^"]*)" should match \/(.*)\/$/) do |cmd, regexp|
  aruba.command_monitor.find(Aruba.platform.detect_ruby(cmd)).send(:stdout)  =~ /#{regexp}/
end
