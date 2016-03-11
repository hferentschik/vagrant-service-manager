shared_examples "provider/service-manager" do |provider, options|
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

  it "prints version" do
    result = execute("vagrant", "service-manager")
    expect(result).to exit_with(1)
    expect(result.stdout).to match(/Service manager for services inside vagrant box./)
  end
end
