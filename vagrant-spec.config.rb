Vagrant::Spec::Acceptance.configure do |c|
  c.provider 'virtualbox', box: 'file:///Users/hardy/Downloads/rhel-cdk-kubernetes-7.2-21.x86_64.vagrant-virtualbox.box'
  c.component_paths << 'vagrant-spec'
  c.skeleton_paths << 'vagrant-spec/skeleton'
end
