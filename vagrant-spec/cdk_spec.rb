help_text = <<-HELP
Usage: vagrant service-manager <command> [options]

Commands:
     env          displays connection information for services in the box
     box          displays box related information like version, release, IP etc
     restart      restarts the given systemd service in the box
     status       list services and their running state

Options:
     -h, --help   print this help

For help on any individual command run `vagrant service-manager COMMAND -h`
HELP

def stdout_without_plugin_context(raw_stdout)
  raw_stdout.lines.to_a[6..-1].join
end

shared_examples "provider/cdk" do |provider, options|
  if !options[:box]
    raise ArgumentError,
      "box_basic option must be specified for provider: #{provider}"
  end

  include_context "acceptance"

  before do
    environment.skeleton("cdk")
    assert_execute("vagrant", "box", "add", "box", options[:box])
    assert_execute("vagrant", "up", "--provider=#{provider}")
  end

  after do
    assert_execute("vagrant", "destroy", "--force")
  end

  # We put all of this in a single RSpec test so that we can test all
  # the cases within a single VM rather than having to `vagrant up` many
  # times.
  it "verify cli output" do
    status("Test: service-manager call without argument")
    result = execute("vagrant", "service-manager")
    # TODO, why does this return an error code of 1!?
    expect(result).to exit_with(1)
    expect(stdout_without_plugin_context(result.stdout)).to eq(help_text)

    status("Test: service-manager with short option -h")
    result = execute("vagrant", "service-manager", "-h")
    expect(result).to exit_with(0)
    expect(stdout_without_plugin_context(result.stdout)).to eq(help_text)

    status("Test: service-manager with long option --help")
    result = execute("vagrant", "service-manager", "--help")
    expect(result).to exit_with(0)
    expect(stdout_without_plugin_context(result.stdout)).to eq(help_text)

    status("Test: service-manager with unkown option")
    result = execute("vagrant", "service-manager", "--foo")
    expect(result).to exit_with(1)
    expect(stdout_without_plugin_context(result.stdout)).to eq(help_text)
  end
end
