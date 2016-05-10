Feature: Command output from help command
  service-manager should return the correct output from its help commands

  @help
  Scenario Outline: Boot and execute help commands
    Given provider is <provider>
    And a file named "Vagrantfile" with:
    """
    Vagrant.configure('2') do |config|
      config.vm.box = '<box>'
      config.vm.box_url = '<baseurl>-<provider>.box'
      config.vm.network :private_network, ip: '10.10.10.123'
      config.servicemanager.services = 'docker'
    end
    """

    When I successfully run `bundle exec vagrant up --provider <provider>`
    And I successfully run `bundle exec vagrant service-manager --help`
    Then stdout from "bundle exec vagrant service-manager --help" should contain:
    """
    Usage: vagrant service-manager <command> [options]

    Commands:
         env          displays connection information for services in the box
         box          displays box related information like version, release, IP etc
         restart      restarts the given systemd service in the box
         status       list services and their running state

    Options:
         -h, --help   print this help

    For help on any individual command run `vagrant service-manager COMMAND -h`
    """

    When I successfully run `bundle exec vagrant service-manager -h`
    Then stdout from "bundle exec vagrant service-manager -h" should contain:
    """
    Usage: vagrant service-manager <command> [options]

    Commands:
         env          displays connection information for services in the box
         box          displays box related information like version, release, IP etc
         restart      restarts the given systemd service in the box
         status       list services and their running state

    Options:
         -h, --help   print this help

    For help on any individual command run `vagrant service-manager COMMAND -h`
    """

    When I run `bundle exec vagrant service-manager`
    Then the exit status should be 1
    And stdout from "bundle exec vagrant service-manager -h" should contain:
    """
    Usage: vagrant service-manager <command> [options]

    Commands:
         env          displays connection information for services in the box
         box          displays box related information like version, release, IP etc
         restart      restarts the given systemd service in the box
         status       list services and their running state

    Options:
         -h, --help   print this help

    For help on any individual command run `vagrant service-manager COMMAND -h`
    """

    Examples:
      | box   | provider   | baseurl              |
      | cdk   | virtualbox | file://../boxes/cdk  |
      | adb   | virtualbox | file://../boxes/adb  |
      | cdk   | libvirt    | file://../boxes/cdk  |
      | adb   | libvirt    | file://../boxes/adb  |
