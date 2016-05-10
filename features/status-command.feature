Feature: Command output from status command
  service-manager should return the correct output from status command

  @status
  Scenario Outline: Boot and execute status command
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
    And I successfully run `bundle exec vagrant service-manager status`
    Then stdout from "bundle exec vagrant service-manager status" should contain "docker - running"
    Then stdout from "bundle exec vagrant service-manager status" should contain "openshift - stopped"

    Examples:
      | box   | provider   | baseurl              |
      | cdk   | virtualbox | file://../boxes/cdk  |
      | adb   | virtualbox | file://../boxes/adb  |
      | cdk   | libvirt    | file://../boxes/cdk  |
      | adb   | libvirt    | file://../boxes/adb  |
