Feature: Command output from box command
  service-manager should return the correct output from box commands

  @box
  Scenario Outline: Boot and execute box commands
    Given a file named "Vagrantfile" with:
    """
    Vagrant.configure('2') do |config|
      config.vm.box = '<box>'
      config.vm.box_url = '<baseurl>-<provider>.box'
      config.vm.network :private_network, ip: '10.10.10.123'
      config.servicemanager.services = 'docker'
    end
    """

    When I successfully run `bundle exec vagrant up --provider <provider>`
    And I run `bundle exec vagrant service-manager box`
    Then the exit status should be 1
    And stdout from "bundle exec vagrant service-manager box" should contain:
    """
    Usage: vagrant service-manager box <sub-command> [options]

    Sub-Command:
          version    display version and release information about the running VM
          ip         display routable IP address of the running VM

    Options:
          --script-readable  display information in a script readable format
          -h, --help         print this help
    """

    When I successfully run `bundle exec vagrant service-manager box ip`
    Then stdout from "bundle exec vagrant service-manager box ip" should contain "10.10.10.123"

    Examples:
      | box   | provider   | baseurl              |
      | cdk   | virtualbox | file://../boxes/cdk  |
      | adb   | virtualbox | file://../boxes/adb  |
