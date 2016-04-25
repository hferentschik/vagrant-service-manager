Feature: Command output from various OpenShift related commands
  service-manager should return the correct output from commands affecting OpenShift

  @openshift
  Scenario Outline: Boot and execute commands
    Given a file named "Vagrantfile" with:
    """
    Vagrant.configure('2') do |config|
      config.vm.box = '<box>'
      config.vm.box_url = '<baseurl>-<provider>.box'
      config.vm.network :private_network, ip: '10.10.10.123'
      config.servicemanager.services = 'docker'
      config.vm.provision "shell", inline: <<-SHELL
        systemctl enable openshift 2>&1
        systemctl start openshift | true
      SHELL
    end
    """

    When I successfully run `bundle exec vagrant up --provider <provider>`
    # TODO, for some reason I can not use 'successfully' here. Seems the exit code is not 0 in this case!?
    And I run `bundle exec vagrant service-manager env openshift`
    Then stdout from "bundle exec vagrant service-manager env openshift" should be evaluable in a shell
    And stdout from "bundle exec vagrant service-manager env openshift" should contain:
    """
    # You can access the OpenShift console on: https://10.10.10.123:8443/console
    # To use OpenShift CLI, run: oc login https://10.10.10.123:8443
    export OPENSHIFT_URL=https://10.10.10.123:8443
    export OPENSHIFT_WEB_CONSOLE=https://10.10.10.123:8443/console

    # run following command to configure your shell:
    # eval "$(vagrant service-manager env openshift)"
    """

    When I successfully run `bundle exec vagrant service-manager env openshift --script-readable`
    Then stdout from "bundle exec vagrant service-manager env openshift --script-readable" should be script readable
    And stdout from "bundle exec vagrant service-manager env openshift --script-readable" should contain:
    """
    OPENSHIFT_URL=https://10.10.10.123:8443
    OPENSHIFT_WEB_CONSOLE=https://10.10.10.123:8443/console
    """

    Examples:
      | box   | provider   | baseurl              |
      | cdk   | virtualbox | file://../boxes/cdk  |
      #| adb   | virtualbox | file://../boxes/adb  |
