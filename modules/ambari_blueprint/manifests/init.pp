class ambari_blueprint {

    exec { 'ambari-ready':
      path      => ["/bin/", "/sbin/", "/usr/bin/", "/usr/sbin/"],
      tries     => 4,
      try_sleep => 30,
      command   => "curl --user admin:admin http://192.168.0.101:8080/api/v1/hosts -I | grep '200 OK'"      
    }

    exec { 'ambari-blueprint':
      path    => ["/bin/", "/sbin/", "/usr/bin/", "/usr/sbin/"],
      require => Exec['ambari-ready'],
      cwd     => "/vagrant",
      command => "curl --user admin:admin -H 'X-Requested-By:mycompany' -X POST http://192.168.0.101:8080/api/v1/blueprints/blueprint-c1 -d @blueprint.json"
    }

    exec { 'ambari-host-mappings':
      path    => ["/bin/", "/sbin/", "/usr/bin/", "/usr/sbin/"],
      require => Exec['ambari-blueprint'],
      cwd     => "/vagrant",
      command => "curl --user admin:admin -H 'X-Requested-By:mycompany' -X POST http://192.168.0.101:8080/api/v1/clusters/c1 -d @hostmapping.json",
    }

}